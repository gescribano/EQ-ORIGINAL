//
//  EQNewLightOrderViewModel.h
//  EQ
//
//  Created by Sebastian Borda on 5/18/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewModel.h"
#import "Pedido+extra.h"
#import "Articulo+extra.h"

#import "LightOrder.h"

@protocol EQNewLightOrderViewModelDelegate <EQBaseViewModelDelegate>

- (void)modelAddItemDidFail;
- (void)articleUnavailable;

@optional
- (void)modelDidUpdateItem:(NSInteger)itemOrder;
- (void)modelDidAddItem:(NSInteger)itemOrder;
- (void)modelDidRemoveItem:(NSInteger)itemOrder;

@end

@interface EQNewLightOrderViewModel : EQBaseViewModel

- (id)initWithOrder:(Pedido *)order;
- (void)loadData:(int) level;
- (void)save_NLOVM;

@property (nonatomic,assign) id<EQNewLightOrderViewModelDelegate> delegate;
@property (nonatomic,strong) NSArray *articles;
@property (nonatomic,strong) Articulo *articleSelected;
@property (nonatomic,strong) NSArray *group1;
@property (nonatomic,strong) NSArray *group2;
@property (nonatomic,strong) NSArray *categories;

@property (nonatomic,assign) NSInteger categorySelected;
@property (nonatomic,assign) NSInteger group1Selected;
@property (nonatomic,assign) NSInteger group2Selected;
@property (nonatomic,assign) NSInteger articleSelectedIndex;

@property (nonatomic,assign) BOOL newOrder;

@property (nonatomic,strong) Pedido *order;

- (void)defineSelectedCategory:(NSInteger)index;
- (void)defineSelectedGroup1:(NSInteger)index;
- (void)defineSelectedGroup2:(NSInteger)index;
- (void)defineSelectedArticle:(NSInteger)index;
- (void)defineOrderStatus:(NSInteger)index;
- (BOOL)addItemQuantity:(int)quantity;
- (NSNumber *)itemsQuantity;
- (NSNumber *)subTotal;
- (float)discountPercentage;
- (float)discountValue;
- (float)total;
- (NSArray *)items;
- (int)orderStatusIndex;
- (NSDate *)date;
- (void)removeItem:(ItemPedido *)item;
- (void)editItem:(ItemPedido *)item;
- (NSInteger)quantityOfCurrentArticle;
- (void)cancelOrder;
- (void)sortArticlesByIndex:(int)index;
- (void)sortGroup2ByIndex:(int)index;
- (void)sortGroup1ByIndex:(int)index;

- (NSString *)orderHTML;


- (NSInteger) numberOfItems;

@end
