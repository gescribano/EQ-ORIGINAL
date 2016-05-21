//
//  Precio+extra.m
//  EQ
//
//  Created by Sebastian Borda on 6/27/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Precio+extra.h"
#import "EQSession.h"
#import "Articulo+extra.h"
#import "EQDataAccessLayer.h"

@implementation Precio (extra)

@dynamic articulo;

- (CGFloat)priceForActiveClient {
    Cliente *cliente = [EQSession sharedInstance].selectedClient;
    return [self priceForClient:cliente];
}

- (CGFloat)priceForClient:(Cliente *)client {
    CGFloat descuento = (1 - (1 - ([client.descuento1 floatValue] / 100)) * (1 - ([client.descuento2 floatValue] / 100)));
    if (descuento > 0) {
        
        return [self.importe floatValue] * (1 - descuento);
    }
    
    return [self.importe floatValue];
}

- (NSArray *)articulo
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.articuloID];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Articulo class] filterByPredicate:predicate];
}

@end
