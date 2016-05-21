//
//  Vendedor+extra.h
//  EQ
//
//  Created by Sebastian Borda on 6/28/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Vendedor.h"
#import "Usuario.h"

@interface Vendedor (extra)

@property (nonatomic,strong) NSArray *ventas;
@property (nonatomic,strong) NSArray *pedidos;
@property (nonatomic,strong) NSArray *ctacteList;
@property (nonatomic,strong) NSArray *comunicaciones;
@property (nonatomic,strong) NSArray *clientesVendedor;
@property (nonatomic,strong) NSArray *clientesCobrador;

@end
