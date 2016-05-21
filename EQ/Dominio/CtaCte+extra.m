//
//  CtaCte+extra.m
//  EQ
//
//  Created by Sebastian Borda on 7/3/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "CtaCte+extra.h"
#import "EQDataAccessLayer.h"
#import "Vendedor+extra.h"
#import "Cliente+extra.h"

#define ONE_DAY_IN_SECONDS 86400 //86400 = 60*60*24

@implementation CtaCte (extra)

@dynamic vendedores;
@dynamic clientes;

- (Vendedor *)vendedor{
    return [self.vendedores lastObject];
}

- (Cliente *)cliente{
    return [self.clientes lastObject];
}

- (int)diasDeAtraso{
    float days = [self.fecha timeIntervalSinceNow] * -1 / ONE_DAY_IN_SECONDS; 
    float module = days / 1;
    return module > 0 ? days + 1 : days;
}

- (NSString *)description{
    return [NSString stringWithFormat:@"CTA. CTE. %@ %@ %@", self.identifier, self.comprobante, self.activo];
}

- (NSArray *)vendedores
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.vendedorID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Vendedor class] filterByPredicate:predicate];
}

- (NSArray *)clientes
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.clienteID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Cliente class] filterByPredicate:predicate];
}

@end
