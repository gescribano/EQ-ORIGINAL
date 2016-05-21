//
//  EQBaseViewModel.m
//  EQ
//
//  Created by Sebastian Borda on 4/14/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewModel.h"
#import "EQSession.h"
#import "Usuario+extra.h"
#import "Vendedor+extra.h"
#import "Pedido.h"
#import "Grupo+extra.h"
#import "Comunicacion.h"
#import "EQDataManager.h"

@interface EQBaseViewModel()

@property (nonatomic,strong) NSArray* clientsForSeller;
@property (nonatomic,assign) int pendingOrdersCount;
@property (nonatomic,assign) int unreadGoalsCount;
@property (nonatomic,assign) int unreadOperativesCount;
@property (nonatomic,assign) int unreadCommercialsCount;
@property (nonatomic,assign) id<EQBaseViewModelDelegate> delegate;

@end

@implementation EQBaseViewModel

- (void)loadClients{
    NSArray *results = [EQSession sharedInstance].user.vendedor.clientesVendedor;
    results = [results filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.actualizado == true"]];
    self.clientsForSeller = [results sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"nombre" ascending:YES selector:@selector(caseInsensitiveCompare:)]]];
    self.clientsName = [self clientsNameList];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)releaseUnusedMemory{
    self.clientsForSeller = nil;
    self.clientsName = nil;
}

- (int) pendingOrdersCount
{
    _pendingOrdersCount = 0;
    for (Pedido *order in [NSArray arrayWithArray:self.currentSeller.pedidos]) {
        if ([order.estado isEqualToString:@"pendiente"]) {
            _pendingOrdersCount++;
        }
    }
    return _pendingOrdersCount;
}

- (void)loadTopBarData{
    self.unreadGoalsCount = 0;
    self.unreadOperativesCount = 0;
    self.unreadCommercialsCount = 0;
    NSArray *communications = [NSArray arrayWithArray:[EQSession sharedInstance].user.comunicaciones];
    for (Comunicacion *communication in communications) {
        if (communication.leido == nil) {
            if ([communication.tipo isEqualToString:COMMUNICATION_TYPE_GOAL]) {
                self.unreadGoalsCount++;
            } else if ([communication.tipo isEqualToString:COMMUNICATION_TYPE_OPERATIVE]) {
                self.unreadOperativesCount++;
            } else if ([communication.tipo isEqualToString:COMMUNICATION_TYPE_COMMERCIAL]) {
                self.unreadCommercialsCount++;
            }
        }
    }
}

- (void)loadData{
    [self.delegate modelWillStartDataLoading];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self loadDataInBackGround];
    });
}

- (void)loadDataInBackGround{
    [self dataLaded];
}

- (void)dataLaded{
    [self loadTopBarData];
    [self.delegate modelDidUpdateData];
}

- (NSString *)sellerName{
    return [EQSession sharedInstance].user.vendedor ? [EQSession sharedInstance].user.vendedor.descripcion : [EQSession sharedInstance].user.nombre;
}

- (NSString *)lastUpdateWithFormat{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yy | HH:mm"];
    return  [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:[[EQSession sharedInstance] lastSyncDate]]];
}

- (NSString*) ventanaSincronizacion
{
    return [NSString stringWithFormat:@"%d minutos.",VENTANA_SINCRONIZACION_EN_MINUTOS];
}

- (NSString*) lastUpdateCatalogWithFormat
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yy | HH:mm"];
    NSDate* date =  [[EQDataManager sharedInstance] getLastSyncForCatalog];
    NSString* updateCatalog = [NSString stringWithFormat:@"%@",[dateFormat stringFromDate:date]];
    if (!updateCatalog)
    {
        return [self lastUpdateWithFormat];
    }
    else
    {
        return updateCatalog;
    }
}

-(NSString*) numberOfImagesToDownload
{
    return @"10";
}

- (NSString *)initialDateImportWithFormat {
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yy | HH:mm"];
    NSDate* date = [[NSUserDefaults standardUserDefaults] objectForKey:PEDIDOS_FECHA_INICIO_IMPORTACION_KEY];
    return  [NSString stringWithFormat:@"%@ hs.",[dateFormat stringFromDate:date]];
}

- (NSString *)currentDateWithFormat{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd.MM.yy"];
    return  [dateFormat stringFromDate:[NSDate date]];
}

- (NSString *)activeClientName{
    return [EQSession sharedInstance].selectedClient.nombre;
}

- (NSString *)clientStatus{
    return @"Cliente activo";
}

- (Cliente *)ActiveClient{
    return [EQSession sharedInstance].selectedClient;
}

- (Vendedor *)currentSeller
{
    return [EQSession sharedInstance].user.vendedor;
}

- (void)selectClientAtIndex:(NSUInteger)index{
    Cliente *client = nil;
    if(index > 0) {
        client = [self.clientsForSeller objectAtIndex:index - 1];
    }
    
    [EQSession sharedInstance].selectedClient = client;
}

- (NSArray *)clientsNameList{
    NSMutableArray *names = [NSMutableArray array];
    [names addObject:@"Todos"];
    for (Cliente *client in self.clientsForSeller) {
        [names addObject:client.nombre];
    }
    
    return names;
}

- (int)obtainPendigOrdersCount{
    return self.pendingOrdersCount;
}

- (int)obtainUnreadOperativesCount{
    return self.unreadOperativesCount;
}

- (int)obtainUnreadGoalsCount{
    return self.unreadGoalsCount;
}

- (int)obtainUnreadCommercialsCount{
    return self.unreadCommercialsCount;
}

@end
