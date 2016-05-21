//
//  EQClientsViewController.h
//  EQ
//
//  Created by Sebastian Borda on 4/20/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewController.h"
#import "EQTransparentBackgroundSearchBar.h"
#import "EQTablePopover.h"
#import "EQClientCell.h"
#import "EQCreateClientViewController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface EQClientsViewController : EQBaseViewController<EQTablePopoverDelegate, EQClientCellDelegate, EQCreateClientViewControllerDelegate, MFMailComposeViewControllerDelegate>
@property (strong, nonatomic) IBOutlet UIButton *sortButton;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet EQTransparentBackgroundSearchBar *searchBar;

- (IBAction)sortButtonAction:(id)sender;
- (IBAction)newClientButtonAction:(id)sender;

@end
