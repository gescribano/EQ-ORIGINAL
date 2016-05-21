//
//  EQMainScreenViewController.m
//  EQ
//
//  Created by Sebastian Borda on 4/19/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQMainScreenViewController.h"
#import "EQMainScreenViewModel.h"

@interface EQMainScreenViewController ()

@property (nonatomic,strong) EQMainScreenViewModel *viewModel;
@property (nonatomic,strong) EQCreateClientViewController *createClient;

@end

@implementation EQMainScreenViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewModel = [EQMainScreenViewModel new];
        self.viewModel.delegate = self;
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.loggedUserLabel.text = [[self.viewModel loggedUserName] uppercaseString];
    self.versionLabel.text = [NSString stringWithFormat:@"Número de versión: %@",[[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey]];
    [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
}

- (IBAction)sectionButtonAction:(id)sender{
    UIButton *button = (UIButton *)sender;
    [APP_DELEGATE pushTabBarAtIndex:(int)button.tag];
}

- (IBAction)createClientButtonAction:(id)sender {
    self.createClient = [EQCreateClientViewController new];
    self.createClient.delegate = self;
    [self presentViewController:self.createClient animated:YES completion:nil];
}

- (void)createClientCancelled{
    [self.createClient dismissViewControllerAnimated:YES completion:nil];
}

- (void)clientSaved{
    [self.createClient dismissViewControllerAnimated:YES completion:nil];
    [APP_DELEGATE pushTabBarAtIndex:EQTabIndexOrders];
}

- (void)clientSelected:(NSString *)clientName{
    self.chooseClientButton.titleLabel.text = [NSString stringWithFormat:@"  %@",clientName];
    [self closePopover];
    [APP_DELEGATE pushTabBarAtIndex:EQTabIndexOrders];
}

@end
