//
//  EQLoginViewController.m
//  EQ
//
//  Created by Sebastian Borda on 4/13/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQLoginViewController.h"
#import "EQMainScreenViewController.h"
#import "EQSession.h"

@interface EQLoginViewController ()

@property (nonatomic,strong) UIAlertView *alert;

@end

@implementation EQLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.viewModel = [EQLoginViewModel new];
        self.viewModel.delegate = self;
    }
    return self;
}

- (void)viewDidLoad{
    [super viewDidLoad];
    if ([[EQSession sharedInstance] isUserLogged]) {
        [self.navigationController pushViewController:[EQMainScreenViewController new] animated:YES];
    }
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self resetTextFields];
}

- (IBAction)loginButtonAction:(id)sender {
    [self.passwordTextField resignFirstResponder];
    [self.usuarioTextField resignFirstResponder];
    [self startLoading];
    [self.viewModel loginUser:self.usuarioTextField.text withPassword:self.passwordTextField.text];
}

- (void)loginFail{
    [self stopLoading];
    NSString *errorMessage = @"Usuario y/o contraseña invalido";
    self.alert = [[UIAlertView alloc] initWithTitle:nil
                                            message:errorMessage
                                           delegate:self
                                  cancelButtonTitle:@"Continuar"
                                  otherButtonTitles:nil];
    [self.alert show];
}

-(void)loginSuccessful{
    [self stopLoading];
    [self.navigationController pushViewController:[EQMainScreenViewController new] animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self resetTextFields];
}

- (void)resetTextFields
{
    self.passwordTextField.text = @"";
}

- (BOOL)hideTabBar{
    return YES;
}

@end
