//
//  EQGoalsViewController.h
//  EQ
//
//  Created by Sebastian Borda on 6/13/13.
//  Copyright (c) 2013 EQ. All rights reserved.
//

#import "EQCommunicationsViewController.h"

@interface EQGoalsViewController : EQCommunicationsViewController
@property (strong, nonatomic) IBOutlet UIButton *filterClientsButton;
- (IBAction)filterClientsButtonAction:(id)sender;

@end
