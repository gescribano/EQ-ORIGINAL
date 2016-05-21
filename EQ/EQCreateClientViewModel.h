//
//  EQCreateClientViewModel.h
//  EQ
//
//  Created by Sebastian Borda on 5/8/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewModel.h"
#import "Cliente+extra.h"

@interface EQCreateClientViewModel : EQBaseViewModel

@property(nonatomic,assign) int selectedTaxAtIndex;
@property(nonatomic,assign) int selectedProvinceAtIndex;
@property(nonatomic,assign) int selectedPaymentConditionAtIndex;
@property(nonatomic,assign) int selectedCollectorAtIndex;
@property(nonatomic,assign) int selectedSellerAtIndex;
@property(nonatomic,assign) int selectedSalesLineAtIndex;
@property(nonatomic,assign) int selectedDeliveryAreaAtIndex;
@property(nonatomic,assign) int selectedExpressAtIndex;
@property(nonatomic,assign) BOOL hasDiscount;

@property (nonatomic,weak) id<EQBaseViewModelDelegate> delegate;
//@property (nonatomic,strong) NSString *clientID;
@property (nonatomic,strong) Cliente *client;

- (void)loadData;
- (void)saveClient:(NSDictionary *)clientDictionary;
- (NSArray *)obtainProvinces;
- (NSArray *)obtainDeliveryAreaList;
- (NSArray *)obtainExpressList;
- (NSArray *)obtainSellersList;
- (NSArray *)obtainCollectorList;
- (NSArray *)obtainSalesLineList;
- (NSArray *)obtainPaymentConditionList;
- (NSArray *)obtainTaxesList;

- (void)selectedDiscountAtIndex:(int)index;

- (NSString *)obtainSelectedSeller;
- (NSString *)obtainSelectedCollector;
- (NSString *)obtainSelectedProvince;
- (NSString *)obtainSelectedDeliveryArea;
- (NSString *)obtainSelectedPaymentCondition;
- (NSString *)obtainSelectedExpress;
- (NSString *)obtainSelectedTaxes;
- (NSString *)obtainSelectedSalesLine;

@end
