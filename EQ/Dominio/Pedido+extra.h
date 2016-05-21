//
//  Pedido+extra.h
//  EQ
//
//  Created by Sebastian Borda on 6/29/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Pedido.h"
#import "Cliente.h"
@class Vendedor;

@interface Pedido (extra)

@property (nonatomic,strong) NSArray *clientes;
@property (nonatomic,strong) NSArray *vendedores;

- (Vendedor *)vendedor;
- (float)porcentajeDescuento;
- (NSMutableArray *)fechasFacturacion;
- (NSDate *)ultimaFechaDeFacturacion;
- (NSDate *)primerFechaDeFacturacion;

- (NSString *)pedidoHTML;
- (NSArray *)sortedItems;

-(void)createHash;

@end
