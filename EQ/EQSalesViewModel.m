//
//  EQSalesViewModel.m
//  EQ
//
//  Created by Sebastian Borda on 6/22/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQSalesViewModel.h"
#import "Venta.h"
#import "Grupo.h"
#import "Articulo+extra.h"
#import "Precio+extra.h"
#import "Venta+extra.h"
#import "Vendedor+extra.h"
#import "EQDataAccessLayer.h"

@interface EQSalesViewModel()

@property (nonatomic, strong) NSSortDescriptor *sortDescriptor;
@property (nonatomic, strong) Grupo *group;
@property (nonatomic, strong) NSArray *groupsList;
@property (nonatomic, strong) NSArray *originalSalesList;
@end

@implementation EQSalesViewModel

- (id)init
{
    self = [super init];
    if (self) {
        self.sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[self salesFieldByIndex:1] ascending:YES];
        self.sortFields = [NSArray arrayWithObjects:@"  Periodo", @"  Cliente", @"  Articulo/Grupo", @"  Cantidad", @"  Importe", nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeClientChange:) name:ACTIVE_CLIENT_CHANGE_NOTIFICATION object:nil];
        if (self.ActiveClient) {
            self.clientName = self.ActiveClient.nombre;
        }
    }
    return self;
}

- (void)releaseUnusedMemory{
    [super releaseUnusedMemory];
    self.salesList = nil;
}

- (void)activeClientChange:(NSNotification *)notification{
    Cliente *activeCliente = notification.userInfo[@"activeClient"];
    self.clientName = activeCliente.nombre;
    if ([APP_DELEGATE tabBarController].selectedIndex == EQTabIndexSales) {
        [self loadData];
    }
}

- (void)initializeData{
    self.groupsList = [[EQDataAccessLayer sharedInstance] objectListForClass:[Grupo class]];
}

- (NSString *)salesFieldByIndex:(int)index{
    switch (index) {
        case 0:
            return @"fecha";
            break;
        case 1:
            return @"cliente.nombre";
            break;
        case 2:
            return @"articulo.grupo.nombre";
            break;
        case 3:
            return @"cantidad";
            break;
        case 4:
            return @"importe";
            break;
        default:
            return @"cliente.nombre";
            break;
    }
}

- (BOOL)isSortingByClient {
    return [self.sortDescriptor.key isEqualToString:@"cliente.nombre"];
}

- (BOOL)isSortingByPeriod {
    return [self.sortDescriptor.key isEqualToString:@"fecha"];
}

- (BOOL)isSortingByGroup{
    return [self.sortDescriptor.key isEqualToString:@"articulo.grupo.nombre"];
}

- (void)chargeData{
    self.salesList = [NSArray arrayWithArray:self.currentSeller.ventas];
    NSMutableArray *subPredicates = [NSMutableArray new];
    
    if (self.clientName) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.cliente.nombre == %@",self.clientName];
        [subPredicates addObject:predicate];
    }
    
    if (self.group) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.articulo.grupoID == %@",self.group.identifier];
        [subPredicates addObject:predicate];
    }
    
    if (self.periodStart) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fecha >= %@",self.periodStart];
        [subPredicates addObject:predicate];
    }
    
    if (self.periodEnd) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.fecha <= %@",self.periodEnd];
        [subPredicates addObject:predicate];
    }
    
    if ([subPredicates count] > 0) {
        NSPredicate *predicate = [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates];
        self.salesList = [self.salesList filteredArrayUsingPredicate:predicate];
    }
    
    NSArray *result = [self.salesList sortedArrayUsingDescriptors:[NSArray arrayWithObject:self.sortDescriptor]];
    NSMutableArray *sales = [NSMutableArray new];
    self.onlySubTotalAvailable = ([self isSortingByClient] && !self.ActiveClient) || [self isSortingByPeriod] || [self isSortingByGroup];
    if([self isSortingByClient] && !self.ActiveClient){
        Cliente *lastClient = nil;
        NSMutableArray *currentArray = nil;
        for (Venta *sale in result) {
            if (![lastClient.identifier isEqualToString:sale.cliente.identifier] || [sales count] == 0) {
                currentArray = [NSMutableArray new];
                [sales addObject:currentArray];
            } else {
                currentArray = [sales lastObject];
            }
            
            lastClient = sale.cliente;
            [currentArray addObject:sale];
        }
    } else if ([self isSortingByPeriod]){
        NSString *lastPeriod = nil;
        NSMutableArray *currentArray = nil;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM"];
        for (Venta *sale in result) {
            NSString *period = [dateFormatter stringFromDate:sale.fecha];
            if (![lastPeriod isEqualToString:period] || [sales count] == 0) {
                currentArray = [NSMutableArray new];
                [sales addObject:currentArray];
            } else {
                currentArray = [sales lastObject];
            }
            
            lastPeriod = period;
            [currentArray addObject:sale];
        }
    } else if([self isSortingByGroup]){
        Grupo *lastGroup = nil;
        NSMutableArray *currentArray = nil;
        for (Venta *sale in result) {
            if (!lastGroup || [sales count] == 0 || ![sale.articulo.grupoID isEqualToString:lastGroup.identifier]) {
                currentArray = [NSMutableArray new];
                [sales addObject:currentArray];
            } else {
                currentArray = [sales lastObject];
            }
            
            lastGroup = sale.articulo.grupo;
            [currentArray addObject:sale];
        }
    } else {
        [sales addObject:result];
    }
    
    self.salesList = sales;
}

- (void)loadDataInBackGround{
    [self chargeData];
    [super loadDataInBackGround];
}

- (void)changeSortOrder:(int)index{
    BOOL ascending = true;
    self.sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[self salesFieldByIndex:index] ascending:ascending];
    [self loadData];
}

- (NSArray *)clients{
    NSMutableArray *array = [NSMutableArray array];
    if(self.ActiveClient.nombre){
        [array addObject:@"Todos"];
        [array addObject:self.ActiveClient.nombre];
    } else {
        for (NSArray *list in self.salesList) {
            for (Venta *sale in list) {
                if (![array containsObject:sale.cliente.nombre] && sale.cliente.nombre) {
                    [array addObject:sale.cliente.nombre];
                }
            }
        }
        array = [NSMutableArray arrayWithArray:[array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        [array insertObject:[self.salesList count] > 0 ? @"Todos" : @"No hay datos" atIndex:0];
    }
    
    return array;
}

- (NSArray *)groupsName{
    NSMutableArray *array = [NSMutableArray array];
    for (Grupo *group in self.groupsList) {
        [array addObject:group.nombre];
    }
    
    array = [NSMutableArray arrayWithArray:[array sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
    [array insertObject:[array count] > 0 ? @"Todas" : @"No hay datos" atIndex:0];
    
    return array;
}

- (NSArray *)totals{
    return [NSArray arrayWithObjects:@"Todo", @"Subtotal", nil];
}

- (void)filterByClient:(NSString *)client{
    if (![client isEqualToString:@"Todos"] && ![client isEqual:@"No hay datos"]) {
        self.clientName = client;
    } else {
        self.clientName = nil;
    }
    [self loadData];
}

- (void)filterByGroup:(NSString *)Group{
    if (![Group isEqualToString:@"Todas"] && ![Group isEqual:@"No hay datos"]) {
        self.group = [[self.groupsList filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.nombre == %@",Group]] lastObject];
    } else {
        self.group = nil;
    }
    [self loadData];
}

- (int)articlesQuantity{
    int quantity = 0;
    if ([[self.salesList lastObject] isKindOfClass:[Venta class]]){
        for (Venta *venta in self.salesList) {
            quantity += [venta.cantidad intValue];
        }
    } else {
        for (NSArray *array in self.salesList) {
            for (Venta *venta in array) {
                quantity += [venta.cantidad intValue];
            }
        }
    }
    
    return quantity;
}

- (float)articlesPrice{
    float price = 0;
    if ([[self.salesList lastObject] isKindOfClass:[Venta class]]){
        for (Venta *venta in self.salesList) {
            price += [venta.importe floatValue];
        }
    } else {
        for (NSArray *array in self.salesList) {
            for (Venta *venta in array) {
                price += [venta.importe floatValue];
            }
        }
    }
    
    return price;
}

@end
