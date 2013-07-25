//
//  CtaCte+extra.m
//  EQ
//
//  Created by Sebastian Borda on 7/3/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "CtaCte+extra.h"

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
    float days = [self.fecha timeIntervalSinceNow] * -1 / 86400; //86400 = 60*60*24
    float module = days / 1;
    return module > 0 ? days + 1 : days;
}

@end
