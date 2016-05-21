//
//  EQNewOrderViewModel.m
//  EQ
//
//  Created by Sebastian Borda on 5/18/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQNewOrderViewModel.h"
#import "EQDataAccessLayer.h"
#import "ItemPedido.h"
#import "EQNetworkManager.h"
#import "ItemPedido+extra.h"
#import "Grupo+extra.h"
#import "EQDataManager.h"
#import "Vendedor+extra.h"
#import "EQSession.h"

#define DEFAULT_CATEGORY @"artistica"

@interface EQNewOrderViewModel()

@property (nonatomic,strong) NSUndoManager *undoManager;
@property (nonatomic,strong) NSSortDescriptor *sortArticle;
@property (nonatomic,strong) NSSortDescriptor *sortGroup1;
@property (nonatomic,strong) NSSortDescriptor *sortGroup2;
@property (nonatomic,strong) NSArray* allCategories;
@property (nonatomic,weak) ItemPedido* itemSelected;

@end

@implementation EQNewOrderViewModel

- (id)initWithOrder:(Pedido *)order{
    self = [super init];
    if (self) {
        self.order = order;
        [self initilize];
    }
    
    return self;
}

- (id)init {
    self = [super init];
    if (self) {
            self.order = (Pedido *)[[EQDataAccessLayer sharedInstance] createManagedObject:NSStringFromClass([Pedido class])];
            self.order.cliente = self.ActiveClient;
            self.order.descuento3 = self.ActiveClient.descuento3;
            self.order.descuento4 = self.ActiveClient.descuento4;
            self.order.vendedorID = self.currentSeller.identifier;
            [self initilize];
    }
    return self;
}

- (NSArray*) allCategories
{
    if (!_allCategories)
    {
        _allCategories = [[EQDataAccessLayer sharedInstance] objectListForClass:[Grupo class] filterByPredicate:nil];
    }
    return _allCategories;
}

- (void)initilize{
    
    [self.delegate modelWillStartDataLoading];

    self.undoManager = [[NSUndoManager alloc] init];
    [[self.order managedObjectContext] setUndoManager:self.undoManager];
    [self.undoManager beginUndoGrouping];
    self.categories = [self.allCategories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"parentID == '0'"]];
    
    [self sortArticlesByIndex:0];
    [self sortGroup1ByIndex:0];
    [self sortGroup2ByIndex:0];
    //POL
    [self loadData:0];
    self.categorySelected = (int)[self.categories indexOfObject:self.categories.lastObject];
    [self defineSelectedCategory:self.categorySelected];
    [self.delegate modelDidUpdateData:0 recalculate:NO];
    
}

//- (void)loadData{
//    int level = 0;
//    [self.delegate modelWillStartDataLoading];
//    if (([self.group2 count] == 0 && self.group1Selected != NSNotFound) || self.group2Selected != NSNotFound) {
//        Grupo *group = self.group2Selected != NSNotFound ? self.group2[self.group2Selected] : self.group1[self.group1Selected];
//        self.articles = [group.articulos sortedArrayUsingDescriptors:@[self.sortArticle]];
//    }
//    if ([self.group1 count] > 0) {
//        level = 1;
//        self.group1 = [self.group1 sortedArrayUsingDescriptors:@[self.sortGroup1]];
//    }
//    if ([self.group2 count] > 0) {
//        level = 2;
//        self.group2 = [self.group2 sortedArrayUsingDescriptors:@[self.sortGroup2]];
//    }
//    
////    [self.delegate modelDidUpdateData:level];
//}


- (void)loadData:(int) level{
    
//    [self.delegate modelWillStartDataLoading];
    
    if (([self.group2 count] == 0 && self.group1Selected != NSNotFound) || self.group2Selected != NSNotFound) {
        Grupo *group = self.group2Selected != NSNotFound ? self.group2[self.group2Selected] : self.group1[self.group1Selected];
        NSLog(@"articulos [%lu]", (unsigned long)[group.articulos count]);
        self.articles = [group.articulos sortedArrayUsingDescriptors:@[self.sortArticle]];
    }
    if ([self.group1 count] > 0 && level <=0) {
        self.group1 = [self.group1 sortedArrayUsingDescriptors:@[self.sortGroup1]];
    }
    if ([self.group2 count] > 0 && level <=1) {
        self.group2 = [self.group2 sortedArrayUsingDescriptors:@[self.sortGroup2]];
    }
    
//    [self.delegate modelDidUpdateData:level];
}




- (void)save{
    [self.undoManager endUndoGrouping];
    if (self.order.fecha == nil) {
        self.order.fecha = [NSDate date];
        self.order.latitud = [[EQSession sharedInstance] currentLatitude];
        self.order.longitud = [[EQSession sharedInstance] currentLongitude];
    }

    if (self.newOrder) {
        if (!self.order.estado) {
            self.order.estado = @"pendiente";
        }
        
        if (self.ActiveClient){
            self.order.cliente = self.ActiveClient;
        }
    }
    
    self.order.subTotal = [self subTotal];
    self.order.total = [NSNumber numberWithFloat:[self total]];
    self.order.descuento = [NSNumber numberWithInt:[self discountValue]];
    self.order.activo = [NSNumber numberWithBool:YES];
    self.order.actualizado = [NSNumber numberWithBool:NO];
    [[EQDataAccessLayer sharedInstance] saveContext];
    [[EQSession sharedInstance] updateCache];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [[EQDataManager sharedInstance] sendOrder:self.order success:^{
            
        } failure:^(NSError *error) {
            
        }];
    });
}

- (void)defineSelectedCategory:(NSInteger)index{
    [self.delegate modelWillStartDataLoading];

    self.categorySelected = index;
    self.group1Selected = self.group2Selected = NSNotFound;
    Grupo *grupo = self.categories[self.categorySelected];
    self.group1 = [[EQDataAccessLayer sharedInstance] objectListForClass:[Grupo class] filterByPredicate:[NSPredicate predicateWithFormat:@"self.parentID == %@",grupo.identifier]];
    self.group1 = [self.group1 sortedArrayUsingDescriptors:@[self.sortGroup1]];
    self.group2 = nil;
    self.articles = nil;
    self.articleSelected = nil;
    [self.delegate modelDidUpdateData:0 recalculate:NO];
}

- (void)defineSelectedGroup1:(NSInteger)index{

    [self.delegate modelWillStartDataLoading];

    self.group1Selected = index;
    Grupo *grupo = self.group1[self.group1Selected];
    self.group2 = [[EQDataAccessLayer sharedInstance] objectListForClass:[Grupo class] filterByPredicate:[NSPredicate predicateWithFormat:@"self.parentID == %@",grupo.identifier]];
    self.group2 = [self.group2 sortedArrayUsingDescriptors:@[self.sortGroup2]];
    self.group2Selected = NSNotFound;
    self.articles = nil;
    self.articleSelected = nil;
    if ([self.group2 count] == 0) {
        [self loadData:1];
//  } else{
    }
    
    [self.delegate modelDidUpdateData:1 recalculate:NO];

}

- (void)defineSelectedGroup2:(NSInteger)index{
    
    [self.delegate modelWillStartDataLoading];

    self.group2Selected = index;
    self.articleSelected = nil;
    self.articleSelectedIndex = NSNotFound;
    [self loadData:2];
    [self.delegate modelDidUpdateData:2 recalculate:NO];

}

//- (void)defineSelectedArticle:(NSInteger)index{
//    Articulo *article = [self.articles objectAtIndex:index];
//    if ([self canAddArticle:article]) {
//        self.articleSelected = article;
//        self.articleSelectedIndex = index;
//        
//        [self.delegate modelDidUpdateData:2];
//    } else {
//        [self.delegate articleUnavailable];
//    }
//}


//POLX

- (void)defineSelectedArticle:(NSInteger)index{
    Articulo *article = [self.articles objectAtIndex:index];
    self.itemSelected = nil;

    if ([self canAddArticle:article]) {
        self.articleSelected = article;
        self.articleSelectedIndex = index;
        
        for (ItemPedido *item in self.order.items) {
            if ([item.articulo.identifier isEqualToString:self.articleSelected.identifier]) {
                self.itemSelected = item;
                break;
            }
        }

        [self.delegate modelDidUpdateData:2 recalculate:NO];
    } else {
        [self.delegate articleUnavailable];
    }
}




- (void)defineOrderStatus:(NSInteger)index{
    if (index == 0) {
        self.order.estado = @"presupuestado";
    } else {
        self.order.estado = @"pendiente";
    }
}

//- (void)AddQuantity:(int)quantity canAdd:(BOOL)canAdd {
//    if (canAdd) {
//        BOOL existItem = NO;
//        for (ItemPedido *item in self.order.items) {
//            if ([item.articulo.identifier isEqualToString:self.articleSelected.identifier]) {
//                existItem = YES;
//                item.cantidad = [NSNumber numberWithInt:quantity];
//                //POL
//                [self.delegate modelDidUpdateItem:item.orden.integerValue-1];
//                return;
//            }
//        }
//        
//        if (!existItem) {
//            EQDataAccessLayer * DAL = [EQDataAccessLayer sharedInstance];
//            ItemPedido *item = (ItemPedido *)[DAL createManagedObject:@"ItemPedido"];
//            item.articuloID = self.articleSelected.identifier;
//            item.cantidad = [NSNumber numberWithInt:quantity];
//            [self.order addItemsObject:item];
//            item.orden = @([self.order.items count]);
//            //POL
//            [self.delegate modelDidAddItem:item.orden.integerValue-1];
//        }
//        
//        
//    } else {
//        [self.delegate modelAddItemDidFail];
//    }
//}


//POLX
- (void)AddQuantity:(int)quantity canAdd:(BOOL)canAdd {
    if (canAdd) {
        if (self.itemSelected!=nil) {
            self.itemSelected.cantidad = [NSNumber numberWithInt:quantity];
            
            NSArray *allItems = [self items];
            int itemIndex = -1;
            for (int i = 0; i<[allItems count]; i++) {
                if ([((ItemPedido *) allItems[i]).articuloID isEqualToString:self.itemSelected.articuloID]) {
                    itemIndex = i;
                    break;
                }
            }
            [self.delegate modelDidUpdateItem:itemIndex];
        } else {
            EQDataAccessLayer * DAL = [EQDataAccessLayer sharedInstance];
            ItemPedido *item = (ItemPedido *)[DAL createManagedObject:@"ItemPedido"];
            item.articuloID = self.articleSelected.identifier;
            item.cantidad = [NSNumber numberWithInt:quantity];
            [self.order addItemsObject:item];
            item.orden = @([self.order.items count]);
            self.itemSelected = item;
            //NSLog(@"[%ld]", (long)item.orden.integerValue);
            [self.delegate modelDidAddItem:item.orden.integerValue-1];
            
        }
    } else {
        [self.delegate modelAddItemDidFail];
    }
}

- (BOOL)addItemQuantity:(int)quantity{
    int multiplo = [self.articleSelected.multiploPedido intValue];
    int minimo = [self.articleSelected.minimoPedido intValue];
    BOOL canAdd = self.articleSelected && quantity % multiplo == 0 && quantity >= minimo;
    [self AddQuantity:quantity canAdd:canAdd];
    
    return canAdd;
}


- (NSNumber *)itemsQuantity{
    int quantity = 0;
    for (ItemPedido *item in self.order.items) {
        quantity += [item.cantidad intValue];
    }
    
    return [NSNumber numberWithInt:quantity];
}

- (NSNumber *)subTotal{
    CGFloat subtotal = 0;
    for (ItemPedido *item in self.order.items) {
        subtotal += [item totalConDescuento];
    }
    
    return [NSNumber numberWithFloat:subtotal];
}

- (float)discountPercentage{
    return [self.order porcentajeDescuento];
}


- (float)discountValue{
    return  ([[self subTotal] floatValue] * [self discountPercentage]) / 100;
}

- (float)total{
    return [[self subTotal] floatValue] - [self discountValue];
}

- (NSArray *)items{
    return [self.order sortedItems];
}

- (int)orderStatusIndex{
    if ([self.order.estado isEqualToString:@"presupuestado"]) {
        return 0;
    }
    
    return 1;
}

- (NSDate *)date{
    return self.order.fecha ? self.order.fecha : [NSDate date];
}

- (void)removeItem:(ItemPedido *)itemToRemove{
    [self.delegate modelWillStartDataLoading];
    self.itemSelected = nil;
    
    NSArray *allItems = [self items];
    int itemIndex = -1;
    for (int i = 0; i<[allItems count]; i++) {
        ItemPedido *item = (ItemPedido *) allItems[i];
        item.orden = [NSNumber numberWithInt:i + 1];
        if ([item.articuloID isEqualToString:itemToRemove.articuloID]) {
            itemIndex = i;
        }
    }
    
    if (itemIndex > -1) {
        [self.order removeItemsObject:itemToRemove];
        [self.delegate modelDidRemoveItem:itemIndex];
    }
    
}

- (void)editItem:(ItemPedido *)item{
    Grupo *g1 = item.articulo.grupo;
    Grupo *g3 , *g2 = nil;
    
    if (![g1.parentID isEqualToString:@"0"]) {
        g2 = g1.parent;
    }
    
    if (![g2.parentID isEqualToString:@"0"]) {
        g3 = g2.parent;
    }
    
    if (g3) {
        NSInteger index = [self.categories indexOfObject:g3];
        [self defineSelectedCategory:index];
        
        index = [self.group1 indexOfObject:g2];
        [self defineSelectedGroup1:index];
        
        index = [self.group2 indexOfObject:g1];
        [self defineSelectedGroup2:index];
        
        index = [self.articles indexOfObject:item.articulo];
        [self defineSelectedArticle:index];
    } else {
        NSInteger index = [self.categories indexOfObject:g2];
        [self defineSelectedCategory:index];
        
        index = [self.group1 indexOfObject:g1];
        [self defineSelectedGroup1:index];
        
        index = [self.articles indexOfObject:item.articulo];
        [self defineSelectedArticle:index];
    }
}


- (NSNumber *)quantityOfCurrentArticle{
    for (ItemPedido *item in self.order.items) {
        if ([self.articleSelected isEqual:item.articulo]) {
            return item.cantidad;
        }
    }
    
    return @0;
}

- (void)cancelOrder{
    [self.undoManager endUndoGrouping];
    [self.undoManager undo];
}

- (void)sortArticlesByIndex:(int)index{
    self.sortArticle = [NSSortDescriptor sortDescriptorWithKey:index == 0 ? @"codigo" : @"nombre" ascending:YES];
    //POL
    //[self loadData];
}

- (void)sortGroup2ByIndex:(int)index{
    self.sortGroup2 = [NSSortDescriptor sortDescriptorWithKey:index == 0 ? @"relevancia" : @"nombre" ascending:index == 1];
    //POL
    //[self loadData];
}

- (void)sortGroup1ByIndex:(int)index{
    self.sortGroup1 = [NSSortDescriptor sortDescriptorWithKey:index == 0 ? @"relevancia" : @"nombre" ascending:index == 1];
    //POL
    //[self loadData];
}

- (BOOL)canAddArticle:(Articulo *)article{
    Cliente *client = self.ActiveClient;
    if (!self.newOrder)
    {
        client = self.order.cliente;
    }
    
    return [article priceForClient:client] != nil && [article.disponibilidadID intValue] == 1 && [article.activo boolValue];
}

- (NSString *)orderHTML {
    return [self.order pedidoHTML];
}

@end
