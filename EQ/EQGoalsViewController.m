//
//  EQGoalsViewController.m
//  EQ
//
//  Created by Sebastian Borda on 6/13/13.
//  Copyright (c) 2013 EQ. All rights reserved.
//

#import "EQGoalsViewController.h"
#import "EQGoalsViewModel.h"

@interface EQGoalsViewController ()

@property (nonatomic,strong) EQGoalsViewModel *viewModel;

@end

@implementation EQGoalsViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.viewModel = [EQGoalsViewModel new];
    self.viewModel.delegate = self;
    self.viewModel.communicationType = COMMUNICATION_TYPE_GOAL;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)filterClientsButtonAction:(id)sender {
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:self.viewModel.clientsList delegate:self];
    [self presentPopoverInView:sender withContent:popover];
}

- (void)tablePopover:(EQTablePopover *)sender selectedRow:(int)rowNumber selectedData:(NSString *)selectedData{
    if ([self.popoverOwner isEqual:self.filterClientsButton]) {
        [self.viewModel defineClient:selectedData];
        [self.popoverOwner setTitle:[NSString stringWithFormat:@"  %@",selectedData] forState:UIControlStateNormal];
    }
    
    [self closePopover];
    [super tablePopover:sender selectedRow:rowNumber selectedData:selectedData];
}

- (void)modelDidUpdateData{
    NSString *clientName = @"  Todos";
    if (self.viewModel.clientName) {
        clientName = [@"  " stringByAppendingString:self.viewModel.clientName];
    }
    [self.filterClientsButton setTitle:clientName forState:UIControlStateNormal];
    [super modelDidUpdateData];
}

@end
