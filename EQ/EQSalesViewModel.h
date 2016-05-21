//
//  EQSalesViewModel.h
//  EQ
//
//  Created by Sebastian Borda on 6/22/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewModel.h"

@interface EQSalesViewModel : EQBaseViewModel

@property (nonatomic,strong) NSArray *salesList;
@property (nonatomic,strong) NSArray *sortFields;
@property (nonatomic,strong) NSDate *periodStart;
@property (nonatomic,strong) NSDate *periodEnd;
@property (nonatomic,weak) id<EQBaseViewModelDelegate> delegate;
@property (nonatomic,assign) BOOL onlySubTotalAvailable;
@property (nonatomic, strong) NSString *clientName;

- (void)changeSortOrder:(int)index;
- (NSArray *)clients;
- (NSArray *)groupsName;
- (NSArray *)totals;
- (void)filterByGroup:(NSString *)Group;
- (void)filterByClient:(NSString *)client;
- (BOOL)isSortingByClient;
- (BOOL)isSortingByPeriod;
- (BOOL)isSortingByGroup;
- (void)initializeData;
- (int)articlesQuantity;
- (float)articlesPrice;
@end
