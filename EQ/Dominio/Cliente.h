//
//  Cliente.h
//  EQ
//
//  Created by Jonathan on 9/2/15.
//  Copyright (c) 2015 Sebastian Borda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Pedido;

@interface Cliente : NSManagedObject

@property (nonatomic, retain) NSNumber * activo;
@property (nonatomic, retain) NSNumber * actualizado;
@property (nonatomic, retain) NSString * cobradorID;
@property (nonatomic, retain) NSString * codigo1;
@property (nonatomic, retain) NSString * codigo2;
@property (nonatomic, retain) NSString * codigoPostal;
@property (nonatomic, retain) NSNumber * conDescuento;
@property (nonatomic, retain) NSString * condicionDePagoID;
@property (nonatomic, retain) NSString * cuit;
@property (nonatomic, retain) NSNumber * descuento1;
@property (nonatomic, retain) NSNumber * descuento2;
@property (nonatomic, retain) NSNumber * descuento3;
@property (nonatomic, retain) NSNumber * descuento4;
@property (nonatomic, retain) NSString * diasDePago;
@property (nonatomic, retain) NSString * domicilio;
@property (nonatomic, retain) NSString * domicilioDeEnvio;
@property (nonatomic, retain) NSString * encCompras;
@property (nonatomic, retain) NSString * expresoID;
@property (nonatomic, retain) NSString * horario;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * ivaID;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSString * lineaDeVentaID;
@property (nonatomic, retain) NSString * listaPrecios;
@property (nonatomic, retain) NSString * localidad;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * mail;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * nombreDeFantasia;
@property (nonatomic, retain) NSString * observaciones;
@property (nonatomic, retain) NSString * propietario;
@property (nonatomic, retain) NSString * provinciaID;
@property (nonatomic, retain) NSNumber * sucursal;
@property (nonatomic, retain) NSString * telefono;
@property (nonatomic, retain) NSString * vendedorID;
@property (nonatomic, retain) NSString * web;
@property (nonatomic, retain) NSString * zonaEnvioID;
@property (nonatomic, retain) NSSet *pedidos;
@end

@interface Cliente (CoreDataGeneratedAccessors)

- (void)addPedidosObject:(Pedido *)value;
- (void)removePedidosObject:(Pedido *)value;
- (void)addPedidos:(NSSet *)values;
- (void)removePedidos:(NSSet *)values;

@end
