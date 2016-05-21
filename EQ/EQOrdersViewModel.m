//
//  EQOrdersViewModel.m
//  EQ
//
//  Created by Sebastian Borda on 5/15/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQOrdersViewModel.h"
#import "Usuario.h"
#import "Vendedor+extra.h"
#import "Cliente.h"
#import "EQDataManager.h"
#import "EQSession.h"
#import "EQDataAccessLayer.h"
#import "ItemFacturado.h"
#import "ItemPedido.h"

@interface EQOrdersViewModel()

@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSSortDescriptor *sortDescriptor;

@end

@implementation EQOrdersViewModel

- (id)init{
    self = [super init];
    if (self) {
        self.sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[self ordersFieldByIndex:0] ascending:YES];
        self.sortFields = [NSArray arrayWithObjects:@"Estado", @"Fecha de creacion", @"Fecha de facturacion", @"Cliente", @"Pedido", @"Importe Bruto", @"Importe Neto", nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeClientChange:) name:ACTIVE_CLIENT_CHANGE_NOTIFICATION object:nil];
        if (self.ActiveClient) {
            self.clientName = self.ActiveClient.nombre;
        }
    }
    return self;
}

- (BOOL)canCreateOrder{
    return self.ActiveClient && [self.ActiveClient.listaPrecios integerValue] > 0;
}

- (void)activeClientChange:(NSNotification *)notification{
    Cliente *activeCliente = notification.userInfo[@"activeClient"];
    self.clientName = activeCliente.nombre;
    if ([APP_DELEGATE tabBarController].selectedIndex == EQTabIndexOrders) {
        [self loadData];
    }
}

- (void)releaseUnusedMemory{
    [super releaseUnusedMemory];
    self.orders = nil;
    self.statusList = nil;
    self.clientsList = nil;
}

- (void)chargeData{
    NSMutableArray *subPredicates = [NSMutableArray new];
    if ([self.clientName length] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.cliente.nombre == %@",self.clientName];
        [subPredicates addObject:predicate];
    }
    
    if ([self.status length] > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.estado == %@",self.status];
        [subPredicates addObject:predicate];
    }
    
    if (self.startBillingDate) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.primerFechaDeFacturacion >= %@",self.startBillingDate];
        [subPredicates addObject:predicate];
    }
    
    if (self.endBillingDate) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.primerFechaDeFacturacion <= %@",self.endBillingDate];
        [subPredicates addObject:predicate];
    }
    
    if (self.startCreationDate) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fecha >= %@",self.startCreationDate];
        [subPredicates addObject:predicate];
    }
    
    if (self.endCreationDate) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fecha <= %@",self.endCreationDate];
        [subPredicates addObject:predicate];
    }
    
    NSPredicate *predicate = [subPredicates count] > 0 ? [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates] : nil;
    NSArray *results = nil;
    if (predicate) {
        results = [self.currentSeller.pedidos filteredArrayUsingPredicate:predicate];
    } else {
        results = [NSArray arrayWithArray:self.currentSeller.pedidos];
    }
    
    self.orders = [results sortedArrayUsingDescriptors:[NSArray arrayWithObject:self.sortDescriptor]];
    self.statusList = [NSMutableArray arrayWithObject:@"Todos"];
    self.clientsList = [NSMutableArray arrayWithObject:@"Todos"];
    for (Pedido *order in self.orders) {
        if ([order.cliente.nombre length] > 0 && ![self.clientsList containsObject:order.cliente.nombre]) {
            [self.clientsList addObject: order.cliente.nombre];
        }
        
        if ([order.estado length] > 0 && ![self.statusList containsObject:order.estado]) {
            [self.statusList addObject:order.estado];
        }
    }
}

- (void)loadDataInBackGround{
    [self chargeData];
    [super loadDataInBackGround];
}

- (NSString *)ordersFieldByIndex:(int)index{
    switch (index) {
        case 0:
            return @"estado";
            break;
        case 1:
            return @"fecha";
            break;
        case 2:
            return @"primerFechaDeFacturacion";
            break;
        case 3:
            return @"cliente.nombre";
            break;
        case 4:
            return @"identifier";
            break;
        case 5:
            return @"subTotal";
            break;
        case 6:
            return @"total";
            break;
        default:
            return @"fecha";
            break;
    }
}

- (float)total {
    float total = 0;
    for (Pedido *order in self.orders) {
        total += [order.total floatValue];
    }
    
    return total;
}

- (void)cancelOrder:(Pedido *)order {
    order.estado = @"anulado";
    [[EQDataAccessLayer sharedInstance] saveContext];
    [[EQDataManager sharedInstance] sendOrder:order success:^
     {
         
     }
                                      failure:^(NSError *error)
     {
         
     }];
}

- (void)changeSortOrder:(int)index{
    [self.delegate modelWillStartDataLoading];
    self.sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[self ordersFieldByIndex:index] ascending:YES];
    self.orders = [self.orders sortedArrayUsingDescriptors:[NSArray arrayWithObject:self.sortDescriptor]];
    [self.delegate modelDidUpdateData];
}

- (void)defineClient:(NSString *)client{
    if ([client isEqualToString:@"Todos"]) {
        self.clientName = nil;
    } else {
        self.clientName = client;
    }
    
    [self loadData];
}

- (void)defineStatus:(NSString *)status{
    if ([status isEqualToString:@"Todos"]) {
        self.status = nil;
    } else {
        self.status = status;
    }
    
    [self loadData];
}


@end
