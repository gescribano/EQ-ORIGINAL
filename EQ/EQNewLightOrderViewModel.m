//
//  EQNewLightOrderViewModel.m
//  EQ
//
//  Created by Sebastian Borda on 5/18/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQNewLightOrderViewModel.h"
#import "EQDataAccessLayer.h"
#import "ItemPedido.h"
#import "EQNetworkManager.h"
#import "Pedido+extra.h"
#import "ItemPedido+extra.h"
#import "Grupo+extra.h"
#import "EQDataManager.h"
#import "Vendedor+extra.h"
#import "EQSession.h"

#import "LightItem.h"
#import "Precio+extra.h"

#define DEFAULT_CATEGORY @"artistica"

@interface EQNewLightOrderViewModel()

@property (nonatomic,strong) NSUndoManager *undoManager;
@property (nonatomic,strong) NSSortDescriptor *sortArticle;
@property (nonatomic,strong) NSSortDescriptor *sortGroup1;
@property (nonatomic,strong) NSSortDescriptor *sortGroup2;
@property (nonatomic,strong) NSArray* allCategories;

@property (nonatomic,strong) LightOrder *lightOrder;
@property (nonatomic,strong) LightItem *itemSelected;


@end

@implementation EQNewLightOrderViewModel

- (id)initWithOrder:(Pedido *)order{
    self = [super init];
    if (self) {
        self.order = order;
        [self initialize];
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
        self.lightOrder = [[LightOrder alloc]init];
        [self initialize];
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

- (void)initialize{
    [self.delegate modelWillStartDataLoading];

    self.undoManager = [[NSUndoManager alloc] init];
    [[self.order managedObjectContext] setUndoManager:self.undoManager];
    [self.undoManager beginUndoGrouping];
    self.categories = [self.allCategories filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"parentID == '0'"]];
  
    [self loadLightOrder];
  
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


-(void) loadLightOrder{
  
  NSLog(@"loadLightOrder  starts");
    self.lightOrder = [[LightOrder alloc]init];
 
    for (ItemPedido *item in self.order.items) {
        LightItem *lightItem = [[LightItem alloc] init];
        lightItem.articuloID = item.articuloID;
        lightItem.cantidad = [item.cantidad integerValue];
        lightItem.nombre = item.articulo.nombre;
        lightItem.codigo = item.articulo.codigo;
        
        Precio *precio = [item.articulo priceForClient:item.pedido.cliente];
        lightItem.precio = [precio priceForClient:item.pedido.cliente];
        
        NSLog(@"item data[%@][%ld][%@][%f]", lightItem.articuloID, (long)lightItem.cantidad, lightItem.nombre, lightItem.precio);
        NSInteger orden = [self.lightOrder addItem:lightItem] - 1;
        NSLog(@"orden  [%ld]", (long)orden);

    }

  NSLog(@"loadLightOrder  ends");

  [self.delegate modelDidUpdateData:0 recalculate:YES];
  
}


- (void) deleteOrderItems {
  
  //NSLog(@"deleteOrderItems [%d]", self.order.items.count);
//  for (ItemPedido *item in self.order.items) {
//    //NSLog(@"deleteOrderItems item to delete[%@]", item.articuloID);
//    
//    //[self.order removeItemsObject:item];
//  }
  
  
  [self.order removeItems:self.order.items];
  
}


- (void) createOrderItems {

    EQDataAccessLayer *DAL = [EQDataAccessLayer sharedInstance];
  
    for (LightItem *lightItem in [self.lightOrder orderItems]){
      ItemPedido *item;
      item = (ItemPedido *)[DAL createManagedObject:@"ItemPedido"];
      item.articuloID = lightItem.articuloID;
      item.cantidad = [NSNumber numberWithInteger:lightItem.cantidad];
      [self.order addItemsObject:item];
      item.orden = @([self.order.items count]);
    }
    
    [[EQDataAccessLayer sharedInstance] saveContext];

}


- (void)save_NLOVM{
  
    if (!self.newOrder) {
      [self deleteOrderItems];
    }
  
    [self createOrderItems];
    
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

  NSLog(@"before hash [%@]", self.order.hashId);
    [self.order createHash];
  NSLog(@"after hash [%@]", self.order.hashId);
  
    [[EQDataAccessLayer sharedInstance] saveContext];
    
    [[EQSession sharedInstance] updateCache];
    
    [self performSelector:@selector(sendOrderToServer) withObject:nil afterDelay:1.0];
}

- (void) sendOrderToServer {
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
        
        for (LightItem *item in self.lightOrder.orderItems) {
            if ([item.articuloID isEqualToString:self.articleSelected.identifier]) {
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

- (void)AddQuantity:(int)quantity canAdd:(BOOL)canAdd {
    if (canAdd) {
        if (self.itemSelected!=nil) {
            self.itemSelected.cantidad = quantity;
            
            NSArray *allItems = [self items];
            int itemIndex = -1;
            for (int i = 0; i<[allItems count]; i++) {
                if ([((LightItem *) allItems[i]).articuloID isEqualToString:self.itemSelected.articuloID]) {
                    itemIndex = i;
                    break;
                }
            }
            [self.delegate modelDidUpdateItem:itemIndex];
        } else {

            LightItem *item = [[LightItem alloc] init];
            item.articuloID = self.articleSelected.identifier;
            item.cantidad = quantity;
            item.nombre = self.articleSelected.nombre;
            item.codigo = self.articleSelected.codigo;
            
            item.categoryIndex = self.categorySelected;
            item.group1Index = self.group1Selected;
            item.group2Index = self.group2Selected;
            item.articleIndex = self.articleSelectedIndex;

            //NSLog(@"XXXX [%ld][%ld][%ld][%ld]", (long)item.categoryIndex, (long)item.group1Index, (long)item.group2Index, (long)item.articleIndex);

            
            Precio *precio = [self.articleSelected priceForClient:self.order.cliente];
            item.precio = [precio priceForClient:self.order.cliente];

            //NSLog(@"item data[%@][%ld][%@][%f]", item.articuloID, (long)item.cantidad, item.nombre, item.precio);
            self.itemSelected = item;
            NSInteger orden = [self.lightOrder addItem:item] - 1;
            //NSLog(@"orden  [%ld]", (long)orden);
            
            [self.delegate modelDidAddItem:orden];
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
    
    for (LightItem *item in self.lightOrder.orderItems) {
        quantity += item.cantidad;
    }
    
    
    return [NSNumber numberWithInt:quantity];
}

- (NSNumber *)subTotal{
    CGFloat subtotal = 0;
//    for (ItemPedido *item in self.order.items) {
//        subtotal += [item totalConDescuento];
//    }
    for (LightItem *item in [self.lightOrder orderItems]) {
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
    return [self.lightOrder orderItems];
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

- (void)removeItem:(LightItem *)itemToRemove{
    
    [self.delegate modelWillStartDataLoading];
    self.itemSelected = nil;
    NSInteger itemIndex = [self.lightOrder removeItem:itemToRemove];
  
    [self.delegate modelDidRemoveItem:itemIndex];
  
}

- (void)editItem:(LightItem *)item{
  
  if (self.newOrder) {
    if (item.group2Index >=0) {
        [self defineSelectedCategory:item.categoryIndex];
        [self defineSelectedGroup1:item.group1Index];
        [self defineSelectedGroup2:item.group2Index];
        [self defineSelectedArticle:item.articleIndex];
    } else {
        [self defineSelectedCategory:item.categoryIndex];
        [self defineSelectedGroup1:item.group1Index];
        [self defineSelectedArticle:item.articleIndex];
    }
  } else {
    
    ItemPedido *itemPedido;
    
    for (ItemPedido *it in self.order.items) {
      if ([it.articuloID isEqualToString:item.articuloID]) {
        itemPedido = it;
        break;
      }
    }
    
    

    Grupo *g1 = itemPedido.articulo.grupo;
    Grupo *g3 , *g2 = nil;
    
    if (![g1.parentID isEqualToString:@"0"]) {
      g2 = g1.parent;
    }
    
    if (![g2.parentID isEqualToString:@"0"]) {
      g3 = g2.parent;
    }
    
    
    if (g3) {
      NSInteger index = [self.categories indexOfObject:g3];
      item.categoryIndex = index;
      [self defineSelectedCategory:index];
      
      index = [self.group1 indexOfObject:g2];
      item.group1Index = index;
      [self defineSelectedGroup1:index];
      
      index = [self.group2 indexOfObject:g1];
      item.group2Index = index;
      [self defineSelectedGroup2:index];
      
      index = [self.articles indexOfObject:itemPedido.articulo];
      item.articleIndex = index;
      [self defineSelectedArticle:index];
    } else {
      NSInteger index = [self.categories indexOfObject:g2];
      item.categoryIndex = index;
      [self defineSelectedCategory:index];
      
      index = [self.group1 indexOfObject:g1];
      item.group1Index = index;
      [self defineSelectedGroup1:index];
      
      index = [self.articles indexOfObject:itemPedido.articulo];
      item.articleIndex = index;
      [self defineSelectedArticle:index];
    }
    
    
    //NSLog(@"[%@][%d][%@]", item.articuloID, item.cantidad, item.nombre);
    //NSLog(@"[%d][%d][%d][%d]", item.categoryIndex, item.group1Index, item.group2Index, item.articleIndex);


    
    
  }
}

- (NSInteger)quantityOfCurrentArticle{
  
    for (LightItem *item in [self.order items]) {
        if ([self.articleSelected.identifier isEqualToString:item.articuloID]) {
            return item.cantidad;
        }
    }
    
    return 0;
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



- (NSInteger) numberOfItems {
    return [self.lightOrder numberOfItems];
}

@end
