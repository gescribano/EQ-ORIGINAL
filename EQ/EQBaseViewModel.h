//
//  EQBaseViewModel.h
//  EQ
//
//  Created by Sebastian Borda on 4/14/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Cliente+extra.h"
#import "Vendedor+extra.h"

@protocol EQBaseViewModelDelegate;

@interface EQBaseViewModel : NSObject

@property (nonatomic,strong) NSArray* clientsName;

- (NSString *)sellerName;
- (NSString *)lastUpdateWithFormat;
- (NSString*) lastUpdateCatalogWithFormat;
-(NSString*) numberOfImagesToDownload;
- (NSString *)initialDateImportWithFormat;
- (NSString*) ventanaSincronizacion;
- (NSString *)currentDateWithFormat;
- (NSString *)activeClientName;
- (NSString *)clientStatus;
- (Cliente *)ActiveClient;
- (Vendedor *)currentSeller;
- (void)loadClients;
- (void)loadTopBarData;
- (void)selectClientAtIndex:(NSUInteger)index;
- (NSArray *)clientsNameList;
- (int)obtainPendigOrdersCount;
- (int)obtainUnreadOperativesCount;
- (int)obtainUnreadGoalsCount;
- (int)obtainUnreadCommercialsCount;
- (void)loadData;
- (void)loadDataInBackGround;
- (void)releaseUnusedMemory;

@end

@protocol EQBaseViewModelDelegate <NSObject>

- (void)modelDidUpdateData;
- (void)modelDidFinishWithError:(NSError *)error;
- (void)modelWillStartDataLoading;

//TESTPOL
@optional
- (void)modelDidUpdateData:(NSInteger)level recalculate:(BOOL)recalculate;


@end
