//
//  EQBaseViewController.m
//  EQ
//
//  Created by Sebastian Borda on 4/14/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewController.h"
#import "EQTablePopover.h"
#import "EQSession.h"
#import "EQPopover.h"
#import "EQDataAccessLayer.h"
#import "EQDataManager.h"
#import "AFNetworking/AFHTTPClient.h"
#import <QuartzCore/QuartzCore.h>

#define KEYBOARD_HEIGHT 210
#define kUpdateAlertView 0

#define kAlertCancelButton 0
#define kAlertAcceptButton 1

@interface EQBaseViewController ()<UIAlertViewDelegate>

@property (nonatomic, strong) UIPopoverController *popoverVC;
@property (nonatomic, strong) EQBaseViewModel *viewModel;
@property (nonatomic, strong) UIAlertView *logoutAlert;
@property (nonatomic, strong) UIScrollView *scroll;
@property (nonatomic, weak) UIView *activeField;
@property (nonatomic, strong) UIAlertView* forceSyncAlert;

@end

@implementation EQBaseViewController 

- (void)viewDidLoad{
    [super viewDidLoad];
    [self loadTopBarInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:DATA_UPDATED_NOTIFICATION object:nil];
    self.scroll = [[UIScrollView alloc] initWithFrame:self.view.frame];
    self.view.frame = CGRectMake(0, 0, self.scroll.frame.size.width, self.scroll.frame.size.height);
    [self.scroll addSubview:self.view];
    self.view = self.scroll;
	[[self navigationController] setNavigationBarHidden:YES animated:NO];

}

- (void)viewWillAppear:(BOOL)animated
{
    //TESTPOL
    [super viewWillAppear:animated];
    
    [self incrementalSyncCheck];
}

- (void) incrementalSyncCheck
{
    if ([[EQSession sharedInstance] checkIfIncrementalSyncIsNeeded])
    {
        NSString* msg = [NSString stringWithFormat:@"Se detecto que la aplicación lleva mas de %d días sin actualizar, desea actualizar ahora?",kMaxNumberOfDaysWithoutUpdate];
        self.forceSyncAlert = [[UIAlertView alloc] initWithTitle:@"Actualizar" message:msg delegate:self cancelButtonTitle:@"Posponer" otherButtonTitles:@"Actualizar", nil];
        [self.forceSyncAlert show];
    }   
}

- (void) viewDidLayoutSubviews {
    if ([self respondsToSelector:@selector(topLayoutGuide)]) {
        CGRect viewBounds = self.view.bounds;
        CGFloat topBarOffset = self.topLayoutGuide.length;
        viewBounds.origin.y = topBarOffset * -1;
        self.view.bounds = viewBounds;
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.viewModel = nil;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeField = textField;
    [self moveUp];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeField = nil;
    [self moveDown];
    [textField resignFirstResponder];
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.activeField = textView;
    [self moveUp];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.activeField = nil;
    [self moveDown];
    [textView resignFirstResponder];
}

- (void)moveUp {
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your app might not need or want this behavior.
    CGRect aRect = self.view.frame;
    aRect.size.height -= KEYBOARD_HEIGHT;
    CGPoint point = CGPointMake(self.activeField.frame.origin.x, self.activeField.frame.origin.y + self.activeField.frame.size.height);
    if (!CGRectContainsPoint(aRect, self.activeField.frame.origin) || !CGRectContainsPoint(aRect, point )) {
        [self.scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, self.scroll.frame.size.height + KEYBOARD_HEIGHT)];
        [self.scroll setContentOffset:CGPointMake(0, KEYBOARD_HEIGHT) animated:YES];
    }
}

- (void)moveDown {
    [self.scroll setContentSize:CGSizeMake(self.scroll.frame.size.width, self.scroll.frame.size.height)];
    [self.scroll setContentOffset:CGPointMake(0, 0) animated:NO];
}

-(void)dataUpdated:(NSNotification *)notification
{
    UIViewController *controller = self.tabBarController.selectedViewController;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        controller = ((UINavigationController *)controller).topViewController;
    }
    if ([controller isKindOfClass:[self class]]) {
        [self.viewModel loadData];
    }
}

- (void)loadTopBarInfo{
    self.pendingOrdersButton.hidden = [self.viewModel obtainPendigOrdersCount] == 0;
    [self.pendingOrdersButton setTitle:[NSString stringWithFormat:@"%i",[self.viewModel obtainPendigOrdersCount]] forState:UIControlStateNormal];
    
    self.goalsButton.hidden = [self.viewModel obtainUnreadGoalsCount] == 0;
    [self.goalsButton setTitle:[NSString stringWithFormat:@"%i",[self.viewModel obtainUnreadGoalsCount]] forState:UIControlStateNormal];
    
    int notificationsCount = [self.viewModel obtainUnreadOperativesCount] + [self.viewModel obtainUnreadCommercialsCount];
    self.notificationsButton.hidden = notificationsCount == 0;
    [self.notificationsButton setTitle:[NSString stringWithFormat:@"%i",notificationsCount] forState:UIControlStateNormal];
    [self.sellerNameLabel setText:self.viewModel.sellerName];
    [self.dateLabel setText:self.viewModel.currentDateWithFormat];
    [self.syncDateLabel setText:self.viewModel.lastUpdateWithFormat];
    [self.clientStatusLabel setText: self.viewModel.clientStatus];
    [self.clientNameLabel setText:self.viewModel.activeClientName];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    UIViewController *controller = self.tabBarController.selectedViewController;
    if ([controller isKindOfClass:[UINavigationController class]]) {
        controller = ((UINavigationController *)controller).topViewController;
    }
    if (![controller isKindOfClass:[self class]]) {
        [self.viewModel releaseUnusedMemory];
    }
}

- (IBAction)pendingOrdersAction:(id)sender {
    [APP_DELEGATE showPendingOrders];
}

- (IBAction)notificationsAction:(id)sender {
    NSString *operatives = [NSString stringWithFormat:@"Operativas                    %i",[self.viewModel obtainUnreadOperativesCount]];
    NSString *commercials = [NSString stringWithFormat:@"Oportunidades comerciales     %i",[self.viewModel obtainUnreadCommercialsCount]];
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:@[operatives,commercials] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)goalsAction:(id)sender {
    [APP_DELEGATE selectTabAtIndex:EQTabIndexGoals];
}

- (IBAction)logoutAction:(id)sender {
    self.logoutAlert = [[UIAlertView alloc] initWithTitle:@"" message:@"Esta a punto de cerrar la session, ¿Desea continuar?" delegate:self cancelButtonTitle:@"Cancelar" otherButtonTitles:@"Continuar", nil];
    [self.logoutAlert  show];
}

- (IBAction)clientsButtonAction:(id)sender {
    [self.viewModel loadClients];
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:self.viewModel.clientsName delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (void)selectedActiveClientAtIndex:(int)index {
    [self.viewModel selectClientAtIndex:index];
}

- (void)logout{
    [APP_DELEGATE reStartNavigation];
    [[EQSession sharedInstance] endSession];
//    [[EQDataAccessLayer sharedInstance] resetUserDatabase];
//    [[EQDataManager sharedInstance] resetUpdateCompleteForAllEntities];
}

- (void)startLoading{
    if (![NSThread isMainThread]) {
        [APP_DELEGATE performSelectorOnMainThread:@selector(showLoadingView) withObject:nil waitUntilDone:NO];
    } else {
        [APP_DELEGATE showLoadingView];
    }
}

- (void)stopLoading{
    if (![NSThread isMainThread]) {
        [APP_DELEGATE performSelectorOnMainThread:@selector(hideLoadingView) withObject:nil waitUntilDone:NO];
    } else {
        [APP_DELEGATE hideLoadingView];
    }
}

- (void)presentPopoverInView:(UIButton *)view withContent:(UIViewController *)content{
    self.popoverVC = [[UIPopoverController alloc] initWithContentViewController:content];
    [self.popoverVC presentPopoverFromRect:view.frame inView:view.superview permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
    if ([content conformsToProtocol:@protocol(EQPopover)]) {
        [self.popoverVC setPopoverContentSize:[((id<EQPopover>)content) popoverSize] animated:NO];
    }
    
    self.popoverOwner = view;
}

- (BOOL)isButtonPopoverOwner:(UIButton *)view{
    return [self.popoverOwner isEqual:view];
}

- (void)closePopover{
    [self.popoverVC dismissPopoverAnimated:YES];
}

- (void)modelWillStartDataLoading{
    [self startLoading];
}

- (void)modelDidUpdateData{
    [self loadTopBarInfo];
    [self stopLoading];
}

- (void)modelDidFinishWithError:(NSError *)error{
    [self stopLoading];
}

- (UIImage *)captureView:(UIView *)view {
    CGRect screenRect = [view bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    [view.layer renderInContext:ctx];
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

- (void)notImplemented{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Funcionalidad no implementada" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}



- (void)tablePopover:(EQTablePopover *)sender selectedRow:(int)rowNumber selectedData:(NSString *)selectedData{
    if ([self.chooseClientButton isEqual:self.popoverOwner]) {
        [self.chooseClientButton setTitle:@"" forState:UIControlStateNormal];
        [self closePopover];
        [self selectedActiveClientAtIndex:rowNumber];
        [self clientSelected:selectedData];
    } else if([self.notificationsButton isEqual:self.popoverOwner]) {
        if(rowNumber == 0){
            [APP_DELEGATE showOperativeCommunications];
        } else {
            [APP_DELEGATE showCommercialCommunications];
        }
        [self closePopover];
    }
}

- (void)clientSelected:(NSString *)clientName{
    if (![clientName isEqualToString:@"Todos"]) {
        self.clientNameLabel.text = clientName;
    } else {
        self.clientNameLabel.text = @"";
    }
}

- (IBAction)synchronizeAction:(id)sender{
    [[EQSession sharedInstance] forceSynchronization];
}


#pragma mark - UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if ([self.logoutAlert isEqual:alertView]) {
        if (buttonIndex != alertView.cancelButtonIndex) {
            [self logout];
        }
    } else
    {
        if ([alertView isEqual:self.forceSyncAlert])
        {
            if (buttonIndex == kAlertAcceptButton)
            {
                [[EQSession sharedInstance] forceSynchronization];
            }
        }
    }
}

@end
