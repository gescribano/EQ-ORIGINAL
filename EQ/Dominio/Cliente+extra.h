//
//  Cliente+extra.h
//  EQ
//
//  Created by Sebastian Borda on 6/28/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Cliente.h"
@class Provincia;
@class Expreso;
@class LineaVTA;
@class TipoIvas;
@class ZonaEnvio;
@class CondPag;
@class Vendedor;

@interface Cliente (extra)

+ (Cliente*) findById:(NSNumber *) clientId;

@property (nonatomic,strong) NSArray *ventas;
@property (nonatomic,strong) NSArray *condicionesDePago;
@property (nonatomic,strong) NSArray *ctaCteList;
@property (nonatomic,strong) NSArray *expresos;
@property (nonatomic,strong) NSArray *lineasDeVenta;
@property (nonatomic,strong) NSArray *ivas;
@property (nonatomic,strong) NSArray *provincias;
@property (nonatomic,strong) NSArray *zonasEnvio;
@property (nonatomic,strong) NSArray *pedidos;
@property (nonatomic,strong) NSArray *listaDePrecios;
@property (nonatomic,strong) NSArray *cobradores;
@property (nonatomic,strong) NSArray *vendedores;

- (Provincia *)provincia;
- (Expreso *)expreso;
- (LineaVTA *)lineaDeVenta;
- (TipoIvas *)iva;
- (ZonaEnvio *)zonaEnvio;
- (CondPag *)condicionDePago;
- (Vendedor *)vendedor;
- (Vendedor *)cobrador;
- (void)calcularRelevancia;

@end
