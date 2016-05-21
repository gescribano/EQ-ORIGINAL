//
//  Articulo+extra.m
//  EQ
//
//  Created by Sebastian Borda on 6/27/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Articulo+extra.h"
#import "Precio+extra.h"
#import "Cliente+extra.h"
#import "EQSession.h"
#import "EQDataAccessLayer.h"
#import "Disponibilidad+extra.h"
#import "Precio+extra.h"
#import "Grupo+extra.h"
#import "Venta+extra.h"

@implementation Articulo (extra)

@dynamic disponibilidades;
@dynamic grupos;
@dynamic precios;
@dynamic ventas;

- (Disponibilidad *)disponibilidad{
    return [self.disponibilidades lastObject];
}

- (NSArray *)disponibilidades
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.disponibilidadID];
   return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Disponibilidad class] filterByPredicate:predicate];
}

- (NSArray *)grupos
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.grupoID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Grupo class] filterByPredicate:predicate];
}

- (NSArray *)precios
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"articuloID == %@ && activo == 1",self.identifier];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Precio class] filterByPredicate:predicate];
}

- (NSArray *)ventas
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"articuloID == %@ && activo == 1",self.identifier];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Venta class] filterByPredicate:predicate];
}

- (Precio *)priceForActiveClient{
    return [self priceForClient:[EQSession sharedInstance].selectedClient];
}

- (Precio *)priceForClient:(Cliente *)client{
    Precio *price = nil;
    for (Precio *p in client.listaDePrecios) {
        if([p.articuloID isEqualToString:self.identifier]){
            price = p;
            break;
        }
    }
    return price;
}

- (Grupo *)grupo{
    return [self.grupos lastObject];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"article id:%@ name:%@ description:%@ availability:%@",self.identifier,self.nombre,self.descripcion, self.disponibilidad];
}

@end
