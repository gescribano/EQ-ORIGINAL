//
//  CtaCte+extra.h
//  EQ
//
//  Created by Sebastian Borda on 7/3/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "CtaCte.h"
@class Vendedor;
@class Cliente;

@interface CtaCte (extra)

@property (nonatomic,strong) NSArray *vendedores;
@property (nonatomic,strong) NSArray *clientes;

- (Vendedor *)vendedor;
- (Cliente *)cliente;
- (int)diasDeAtraso;

@end
