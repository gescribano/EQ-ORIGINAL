//
//  EQNewOrderViewController.h
//  EQ
//
//  Created by Sebastian Borda on 4/21/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewController.h"
#import "EQNewOrderViewModel.h"
#import "EQTablePopover.h" 

@interface EQNewOrderViewController : EQBaseViewController<EQNewOrderViewModelDelegate, UITableViewDelegate, UITableViewDataSource, EQTablePopoverDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) IBOutletCollection(UISegmentedControl) NSArray *segmentedControls;
@property (strong, nonatomic) IBOutlet UIButton *categoryButton;
@property (strong, nonatomic) IBOutlet UITableView *tableGroup1;
@property (strong, nonatomic) IBOutlet UITableView *tableGroup2;
@property (strong, nonatomic) IBOutlet UITableView *tableGroup3;
@property (strong, nonatomic) IBOutlet UITableView *tableOrderDetail;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentGroup1;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentGroup2;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentArticles;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *quantityButtons;
@property (strong, nonatomic) IBOutlet UITextField *quantityTextField;
@property (strong, nonatomic) IBOutlet UILabel *itemsLabel;
@property (strong, nonatomic) IBOutlet UILabel *discountLabel;
@property (strong, nonatomic) IBOutlet UILabel *totalLabel;
@property (strong, nonatomic) IBOutlet UILabel *subTotalLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderClientLabel;
@property (strong, nonatomic) IBOutlet UITextView *observationTextView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *segmentStatus;

- (id)initWithOrder:(Pedido *)order;
- (id)initWithClonedOrder:(Pedido *)order;
- (IBAction)categoryButtonAction:(id)sender;
- (IBAction)saveQuantity:(id)sender;
- (IBAction)segmentSortChanged:(id)sender;
- (IBAction)articleDetailButton:(id)sender;
- (IBAction)segmentStatusChange:(id)sender;
- (IBAction)quantityButtonAction:(id)sender;
- (IBAction)saveOrder:(id)sender;
- (IBAction)cancelOrder:(id)sender;

@end
