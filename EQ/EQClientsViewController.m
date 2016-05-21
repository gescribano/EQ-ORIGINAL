//
//  EQClientsViewController.m
//  EQ
//
//  Created by Sebastian Borda on 4/20/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQClientsViewController.h"
#import "EQClientsViewModel.h"
#import "Cliente.h"
#import "EQTablePopover.h"
#import "UIColor+EQ.h"

#define cellIdentifier @"ClientCell"

@interface EQClientsViewController ()

@property (nonatomic,strong) EQClientsViewModel *viewModel;
@property (nonatomic,strong) EQCreateClientViewController *createClient;

@end

@implementation EQClientsViewController

- (void)viewDidLoad{
    
    self.viewModel = [EQClientsViewModel new];
    self.viewModel.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"EQClientCell" bundle: nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.viewModel loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.tableView = nil;
}

-(void)modelDidUpdateData{
    [self.tableView reloadData];
    [super modelDidUpdateData];
}

- (IBAction)sortButtonAction:(id)sender {
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:self.viewModel.sortFields delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)newClientButtonAction:(id)sender {
    self.createClient = [[EQCreateClientViewController alloc] init];
    self.createClient.delegate = self;
    [self presentViewController:self.createClient animated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.viewModel.clients count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EQClientCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    Cliente *cliente = [self.viewModel.clients objectAtIndex:indexPath.row];
    cell.clientLabel.text = cliente.nombre;
    cell.addressLabel.text = cliente.domicilio;
    cell.localityLabel.text = cliente.localidad;
    cell.phoneLabel.text = cliente.telefono;
    cell.client = cliente;
    [cell hasEmail:[cliente.mail length] > 0];
    cell.delegate = self;
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor grayForCell] : [UIColor whiteColor];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (void)tablePopover:(EQTablePopover *)sender selectedRow:(int)rowNumber selectedData:(NSString *)selectedData{
    if (self.popoverOwner == self.sortButton) {
        [self.viewModel changeSortOrder:rowNumber];
        self.sortButton.titleLabel.text = selectedData;
        [self closePopover];
    }
    [super tablePopover:sender selectedRow:rowNumber selectedData:selectedData];
}

#pragma mark - search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.viewModel defineSearchTerm:searchText];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self.viewModel selector:@selector(loadData) object:nil];
    [self.viewModel performSelector:@selector(loadData) withObject:nil afterDelay:.8];
}

- (void)editClient:(Cliente *)client{
    self.createClient = [[EQCreateClientViewController alloc] initWithClient:client];
    self.createClient.delegate = self;
    [self presentViewController:self.createClient animated:YES completion:nil];
}

- (void)mailToClient:(Cliente *)cliente
{
    if ([MFMailComposeViewController canSendMail]){
        MFMailComposeViewController *compose = [[MFMailComposeViewController alloc] init];
        [compose setToRecipients:[NSArray arrayWithObject:cliente.mail]];
        compose.mailComposeDelegate = self;
        [self presentViewController:compose animated:YES completion:nil];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"El mail no puede ser enviado" message:@"Verifique que su iPad tiene una cuenta de mail configurada" delegate:nil cancelButtonTitle:@"Continuar" otherButtonTitles:nil];
        [alert show];
    }
}

- (void)mailComposeController:(MFMailComposeViewController*)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError*)error;
{
    [controller dismissViewControllerAnimated:YES completion:nil];
}

- (void)createClientCancelled{
    [self.createClient dismissViewControllerAnimated:YES completion:nil];
}

- (void)clientSaved{
    [self.createClient dismissViewControllerAnimated:YES completion:nil];
    [APP_DELEGATE selectTabAtIndex:EQTabIndexOrders];
}

@end
