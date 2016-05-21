//
//  EQCreateClientViewController.h
//  EQ
//
//  Created by Sebastian Borda on 5/8/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewController.h"
#import "EQCreateClientViewModel.h"
#import "EQTablePopover.h"

@protocol EQCreateClientViewControllerDelegate <NSObject>

- (void)createClientCancelled;
- (void)clientSaved;

@end

@interface EQCreateClientViewController : EQBaseViewController<UIAlertViewDelegate, EQTablePopoverDelegate, UITextFieldDelegate>
@property (strong, nonatomic) IBOutlet UILabel *createClientTitleLabel;
@property (assign, nonatomic) id<EQCreateClientViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITextField *clientNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *clientAliasTextField;
@property (strong, nonatomic) IBOutlet UITextField *clientAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *clientLocalityTextField;
@property (strong, nonatomic) IBOutlet UITextField *clientZipCodeTextField;
@property (strong, nonatomic) IBOutlet UITextField *ownerNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *purchaseManagerTextField;
@property (strong, nonatomic) IBOutlet UITextField *clientPhoneTextField;
@property (strong, nonatomic) IBOutlet UITextField *clientEmailTextField;
@property (strong, nonatomic) IBOutlet UITextField *clientWebTextField;
@property (strong, nonatomic) IBOutlet UITextField *deliveryAddressTextField;
@property (strong, nonatomic) IBOutlet UITextField *scheduleTextField;
@property (strong, nonatomic) IBOutlet UITextField *CUITTextField;
@property (strong, nonatomic) IBOutlet UITextField *collectionDaysTextField;
@property (strong, nonatomic) IBOutlet UITextField *discount1TextField;
@property (strong, nonatomic) IBOutlet UITextField *discount2TextField;
@property (strong, nonatomic) IBOutlet UITextField *discount3TextField;
@property (strong, nonatomic) IBOutlet UITextField *discount4TextField;
@property (strong, nonatomic) IBOutlet UIButton *provinceButton;
@property (strong, nonatomic) IBOutlet UIButton *deliveryAreaButton;
@property (strong, nonatomic) IBOutlet UIButton *expressButton;
@property (strong, nonatomic) IBOutlet UITextView *observationsTextField;
@property (strong, nonatomic) IBOutlet UIButton *sellerButton;
@property (strong, nonatomic) IBOutlet UIButton *collectorButton;
@property (strong, nonatomic) IBOutlet UIButton *salesLineButton;
@property (strong, nonatomic) IBOutlet UIButton *paymentConditionButton;
@property (strong, nonatomic) IBOutlet UIButton *taxesButton;
@property (strong, nonatomic) IBOutletCollection(UITextField) NSArray *textFieldList;
@property (strong, nonatomic) IBOutlet UIButton *discountButton;

- (IBAction)deliveryAreaButtonAction:(id)sender;
- (IBAction)provinceButtonAction:(id)sender;
- (IBAction)expressButonAction:(id)sender;
- (IBAction)sellerButtonAction:(id)sender;
- (IBAction)collectorButtonAction:(id)sender;
- (IBAction)salesLineButtonAction:(id)sender;
- (IBAction)paymentConditionButtonAction:(id)sender;
- (IBAction)saveButtonAction:(id)sender;
- (IBAction)cancelButtonAction:(id)sender;
- (IBAction)taxesButtonAction:(id)sender;
- (IBAction)addressChanged:(id)sender;
- (IBAction)discountButtonAction:(id)sender;

- (id)initWithClient:(Cliente *)client;

@end
