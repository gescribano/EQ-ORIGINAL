//
//  Venta+extra.h
//  EQ
//
//  Created by Sebastian Borda on 6/27/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Venta.h"
@class Cliente;
@class Vendedor;
@class Articulo;

@interface Venta (extra)

@property (nonatomic,strong) NSArray *vendedores;
@property (nonatomic,strong) NSArray *articulos;
@property (nonatomic,strong) NSArray *clientes;

- (Cliente *)cliente;
- (Articulo *)articulo;
- (Vendedor *)vendedor;

@end
