//
//  EQBaseViewController.h
//  EQ
//
//  Created by Sebastian Borda on 4/14/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewModel.h"
#import "EQTablePopover.h"

@interface EQBaseViewController : UIViewController<EQBaseViewModelDelegate,UIAlertViewDelegate,EQTablePopoverDelegate>
@property (weak, nonatomic) IBOutlet UILabel *sellerNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *syncDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *clientNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *notificationsButton;
@property (weak, nonatomic) IBOutlet UIButton *goalsButton;
@property (weak, nonatomic) IBOutlet UIButton *pendingOrdersButton;
@property (weak, nonatomic) UIButton *popoverOwner;
@property (weak, nonatomic) IBOutlet UIButton *chooseClientButton;

- (IBAction)pendingOrdersAction:(id)sender;
- (IBAction)notificationsAction:(id)sender;
- (IBAction)goalsAction:(id)sender;
- (IBAction)logoutAction:(id)sender;
- (IBAction)clientsButtonAction:(id)sender;
- (IBAction)synchronizeAction:(id)sender;
- (BOOL)isButtonPopoverOwner:(UIButton *)button;

- (void)presentPopoverInView:(UIButton *)view withContent:(UIViewController *)content;
- (void)closePopover;
- (void)startLoading;
- (void)stopLoading;
- (void)notImplemented;
- (UIImage *)captureView:(UIView *)view;
- (void)selectedActiveClientAtIndex:(int)index;
- (void)loadTopBarInfo;
- (void)dataUpdated:(NSNotification *)notification;

@end
