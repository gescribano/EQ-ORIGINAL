//
//  Vendedor+extra.m
//  EQ
//
//  Created by Sebastian Borda on 6/28/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Vendedor+extra.h"
#import "Venta+extra.h"
#import "Pedido+extra.h"
#import "CtaCte+extra.h"
#import "Comunicacion+extra.h"
#import "Cliente+extra.h"
#import "Vendedor+extra.h"
#import "EQDataAccessLayer.h"

@implementation Vendedor (extra)

@dynamic ventas;
@dynamic pedidos;
@dynamic ctacteList;
@dynamic comunicaciones;
@dynamic clientesCobrador;
@dynamic clientesVendedor;

- (NSArray *)ventas
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"vendedorID == %@ && activo == 1",self.identifier];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Venta class] filterByPredicate:predicate];
}

- (NSArray *)pedidos
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"vendedorID == %@",self.identifier];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Pedido class] filterByPredicate:predicate];
}

-(NSArray *)ctacteList
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"vendedorID == %@",self.identifier];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[CtaCte class] filterByPredicate:predicate];
}

- (NSArray *)comunicaciones
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"vendedorID == %@",self.identifier];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Comunicacion class] filterByPredicate:predicate];
}

-(NSArray *)clientesVendedor
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"vendedorID == %@",self.identifier];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Cliente class] filterByPredicate:predicate];
}

-(NSArray *)clientesCobrador
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"vendedorID == %@",self.identifier];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Cliente class] filterByPredicate:predicate];
}

@end
