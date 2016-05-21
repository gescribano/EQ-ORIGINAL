//
//  Venta+extra.m
//  EQ
//
//  Created by Sebastian Borda on 6/27/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Venta+extra.h"
#import "EQDataAccessLayer.h"
#import "Venta+extra.h"
#import "Cliente+extra.h"
#import "Articulo+extra.h"

@implementation Venta (extra)

@dynamic vendedores;
@dynamic articulos;
@dynamic clientes;

- (Cliente *)cliente{
    return [self.clientes lastObject];
}
- (Articulo *)articulo{
    return [self.articulos lastObject];
}
- (Vendedor *)vendedor{
    return [self.vendedores lastObject];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"art:%@ cant:%@ cliente:%@ comp:%@ id:%@ imp:%@ vend:%@",self.articuloID,self.cantidad,self.clienteID,self.comprobante,self.identifier, self.importe,self.vendedorID];
}

-(NSArray *)vendedores
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.vendedorID];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Venta class] filterByPredicate:predicate];
}

-(NSArray *)clientes
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.clienteID];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Cliente class] filterByPredicate:predicate];
}

-(NSArray *)articulos
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.articuloID];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Articulo class] filterByPredicate:predicate];
}

@end
