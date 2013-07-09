//
//  EQCommunicationsViewController.m
//  EQ
//
//  Created by Sebastian Borda on 6/13/13.
//  Copyright (c) 2013 EQ. All rights reserved.
//

#import "EQCommunicationsViewController.h"
#import "EQCommunicationCell.h"
#import "Comunicacion+extra.h"

#define cellIdentifier @"CommunicationCell"

@interface EQCommunicationsViewController ()

@property (nonatomic,strong) EQCommunicationsViewModel *viewModel;
@property (nonatomic,strong) NSMutableArray *openedSections;
@property (nonatomic,strong) NSMutableArray *headers;
@property (nonatomic,assign) BOOL editionMode;
@property (nonatomic,strong) UIAlertView *sendResponseAlert;
@property (nonatomic,strong) UIAlertView *cancelResponseAlert;
@property (nonatomic,assign) BOOL viewLoaded;

@end

@implementation EQCommunicationsViewController

- (void)viewDidLoad{
    self.viewModel = [EQCommunicationsViewModel new];
    self.viewModel.delegate = self;
    [self changeToOperative];
    UINib *nib = [UINib nibWithNibName:@"EQCommunicationCell" bundle: nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    self.openedSections = [NSMutableArray array];
    self.headers = [NSMutableArray array];
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    self.viewLoaded = YES;
    [self openCommunication:nil atIndex:nil];
    [self.viewModel loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)notificationKindChange:(id)sender {
    self.openedSections = [NSMutableArray array];
    [self openCommunication:nil atIndex:nil];
    
    UISegmentedControl *control = sender;
    if (control.selectedSegmentIndex == 0) {
        [self changeToOperative];
    } else {
        [self changeToCommercial];
    }
}

- (void)changeToOperative{
    self.viewModel.communicationType = COMMUNICATION_TYPE_OPERATIVE;
    self.segmentCommunicationType.selectedSegmentIndex = 0;
    if (self.viewLoaded) {
        [self.viewModel loadData];
    }
}

- (void)changeToCommercial{
    self.viewModel.communicationType = COMMUNICATION_TYPE_COMMERCIAL;
    self.segmentCommunicationType.selectedSegmentIndex = 1;
    if (self.viewLoaded) {
        [self.viewModel loadData];
    }

}


- (IBAction)finishButtonAction:(id)sender {
    if (self.editionMode) {
        self.cancelResponseAlert = [[UIAlertView alloc] initWithTitle:@"Descartar respuesta" message:@"¿Esta seguro de que quiere descartar la respuesta?" delegate:self cancelButtonTitle:@"SI" otherButtonTitles:@"NO", nil];
        [self.cancelResponseAlert show];
    } else {
        [self.viewModel finalizeThread];
        for (EQCommunicationHeaderView *header in self.headers) {
            if ([header.mainCommunication.threadID isEqualToNumber:self.viewModel.selectedCommunication.threadID]) {
                [header finalizeThread];
                break;
            }
        }
    }
}

- (IBAction)replybuttonAction:(id)sender {
    if (!self.editionMode) {
        [self.finishButton setTitle:@"Cancel" forState:UIControlStateNormal];
        [self.replyButton  setTitle:@"Enviar" forState:UIControlStateNormal];
        self.bodyTextView.userInteractionEnabled = NO;
        [self.bodyTextView becomeFirstResponder];
        self.bodyTextView.text = @"";
        
        self.messageHeader.text = @"";
        self.editionMode = YES;
    } else {
        self.sendResponseAlert = [[UIAlertView alloc] initWithTitle:@"Enviar respuesta" message:@"¿Esta seguro de que quiere enviar la respuesta?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"SI", nil];
        [self.sendResponseAlert show];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [super alertView:alertView clickedButtonAtIndex:buttonIndex];
    if ([alertView isEqual:self.cancelResponseAlert]) {
        if (buttonIndex == alertView.cancelButtonIndex) {
            self.editionMode = NO;
            [self openCommunication:self.viewModel.selectedCommunication atIndex:self.tableView.indexPathForSelectedRow];
        }
    } else if([alertView isEqual:self.sendResponseAlert]){
        if (buttonIndex != alertView.cancelButtonIndex) {
            EQCommunicationHeaderView *headerView = nil;
            for (EQCommunicationHeaderView *header in self.headers) {
                if ([header.mainCommunication.threadID isEqualToNumber:self.viewModel.selectedCommunication.threadID]) {
                    headerView = header;
                    break;
                }
            }
            
            [self.viewModel sendResponseWithMessage:self.bodyTextView.text];
            self.editionMode = NO;
            
            NSIndexPath *newIndex = [NSIndexPath indexPathForRow:[headerView.communications count] - 1 inSection:headerView.section];
            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:@[newIndex] withRowAnimation:UITableViewRowAnimationMiddle];
            [self.tableView endUpdates];
        }
    }
}

- (void)finalizeEdition{
    [self.finishButton setTitle:@"Finalizar" forState:UIControlStateNormal];
    [self.replyButton  setTitle:@"Responder" forState:UIControlStateNormal];
    
    self.bodyTextView.userInteractionEnabled = NO;
    [self.bodyTextView resignFirstResponder];
    self.editionMode = NO;
}

#pragma mark - search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.viewModel defineSearchTerm:searchText];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self.viewModel selector:@selector(loadData) object:nil];
    [self.viewModel performSelector:@selector(loadData) withObject:nil afterDelay:.8];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [self.viewModel.communications count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.openedSections containsObject:[NSNumber numberWithInt:section]]) {
        NSNumber *key = [self.viewModel.communications keyAtIndex:section];
        NSArray *communications = [self.viewModel.communications objectForKey:key];
        return [communications count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EQCommunicationCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    NSNumber *key = [self.viewModel.communications keyAtIndex:indexPath.section];
    NSArray *communications = [self.viewModel.communications objectForKey:key];
    Comunicacion *communication = communications[indexPath.row];
    cell.senderNameLabel.text = communication.sender.nombre;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    cell.dateLabel.text = [dateFormatter stringFromDate:communication.creado];
    cell.communication = communication;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    EQCommunicationHeaderView *view = nil;
    NSNumber *key = [self.viewModel.communications keyAtIndex:section];
    NSArray *communications = [self.viewModel.communications objectForKey:key];
    Comunicacion *communication = communications[0];
    for (EQCommunicationHeaderView *header in self.headers) {
        if ([header.mainCommunication.threadID isEqualToNumber:communication.threadID]) {
            view = header;
            break;
        }
    }
    
    if (!view) {
        NSArray *arrayOfViews = [[NSBundle mainBundle] loadNibNamed:@"EQCommunicationHeaderView"
                                                              owner:nil
                                                            options:nil];
        view = [arrayOfViews objectAtIndex:0];
        [self.headers addObject:view];
    }

    [view loadCommunications:communications];
    view.section = section;
    view.delegate = self;
    
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 104;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSNumber *key = [self.viewModel.communications keyAtIndex:indexPath.section];
    NSArray *communications = [self.viewModel.communications objectForKey:key];
    [self openCommunication:communications[indexPath.row] atIndex:indexPath];
}

- (void)communicationHeaderSelecter:(EQCommunicationHeaderView *)sender{
    if (![self.viewModel.communicationType isEqualToString:COMMUNICATION_TYPE_OPERATIVE]){
        if ([self.openedSections containsObject:[NSNumber numberWithInt:sender.section]]) {
            [self.openedSections removeObject:[NSNumber numberWithInt:sender.section]];
            [self closeSection:sender.section];
        } else {
            [self.openedSections addObject:[NSNumber numberWithInt:sender.section]];
            [self openSection:sender.section];
        }
    }
    
    NSIndexPath *rowIndex = [NSIndexPath indexPathForRow:0 inSection:sender.section];
    [self openCommunication:sender.mainCommunication atIndex:rowIndex];
}

- (void)openSection:(int)section{
    NSNumber *key = [self.viewModel.communications keyAtIndex:section];
    NSArray *communications = [self.viewModel.communications objectForKey:key];
    
    NSMutableArray *rows = [NSMutableArray array];
    for (int index = 0; index < [communications count]; index++) {
        NSIndexPath *rowIndex = [NSIndexPath indexPathForRow:index inSection:section];
        [rows addObject:rowIndex];
    }
    
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationMiddle];
    [self.tableView endUpdates];
}

- (void)closeSection:(int)section{
    NSNumber *key = [self.viewModel.communications keyAtIndex:section];
    NSArray *communications = [self.viewModel.communications objectForKey:key];
    
    NSMutableArray *rows = [NSMutableArray array];
    for (int index = 0; index < [communications count]; index++) {
        NSIndexPath *rowIndex = [NSIndexPath indexPathForRow:index inSection:section];
        [rows addObject:rowIndex];
    }
    
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:rows withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
}

- (void)markHeaderAsRead{
    [self.viewModel didReadCommunication];
    for (EQCommunicationHeaderView *header in self.headers) {
        if ([header.mainCommunication.threadID isEqualToNumber:self.viewModel.selectedCommunication.threadID]) {
            [header markAsRead];
            break;
        }
    }
}

- (void)openCommunication:(Comunicacion *)communication atIndex:(NSIndexPath *)indexPath{
    [self finalizeEdition];
    self.titleLabel.text = communication.titulo;
    self.bodyTextView.text = communication.descripcion;
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:communication.creado];
    if (communication) {
        self.viewModel.selectedCommunication = communication;
        [self markHeaderAsRead];
        if ([self.viewModel.communicationType isEqualToString:COMMUNICATION_TYPE_OPERATIVE]) {
            self.messageHeader.text = @"Comunicaciones";
            self.finishButton.hidden = YES;
            self.replyButton.hidden = YES;
        } else {
            NSNumber *key = [self.viewModel.communications keyAtIndex:indexPath.section];
            self.messageHeader.text = [NSString stringWithFormat:@"%i de %i",indexPath.row + 1,[[self.viewModel.communications objectForKey:key] count]];
            self.finishButton.hidden = NO;
            self.replyButton.hidden = NO;
        }
    } else {
        self.viewModel.selectedCommunication = nil;
        self.finishButton.hidden = YES;
        self.replyButton.hidden = YES;
        self.messageHeader.text = nil;
    }
}

-(void)modelDidUpdateData{
    [super modelDidUpdateData];
    self.notificationsTitleLabel.text = self.viewModel.notificationsTitle;
    self.headers = [NSMutableArray array];
    [self.tableView reloadData];
}

@end
