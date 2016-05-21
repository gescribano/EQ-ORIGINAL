//
//  Pedido.h
//  EQ
//
//  Created by Jonathan on 9/2/15.
//  Copyright (c) 2015 Sebastian Borda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Cliente, ItemPedido;

@interface Pedido : NSManagedObject

@property (nonatomic, retain) NSNumber * activo;
@property (nonatomic, retain) NSNumber * actualizado;
@property (nonatomic, retain) NSNumber * descuento;
@property (nonatomic, retain) NSNumber * descuento3;
@property (nonatomic, retain) NSNumber * descuento4;
@property (nonatomic, retain) NSString * estado;
@property (nonatomic, retain) NSDate * fecha;
@property (nonatomic, retain) NSString * hashId;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * latitud;
@property (nonatomic, retain) NSNumber * longitud;
@property (nonatomic, retain) NSString * observaciones;
@property (nonatomic, retain) NSDate * sincronizacion;
@property (nonatomic, retain) NSNumber * subTotal;
@property (nonatomic, retain) NSNumber * total;
@property (nonatomic, retain) NSString * vendedorID;
@property (nonatomic, retain) NSSet *items;
@property (nonatomic, retain) Cliente *cliente;
@end

@interface Pedido (CoreDataGeneratedAccessors)

- (void)addItemsObject:(ItemPedido *)value;
- (void)removeItemsObject:(ItemPedido *)value;
- (void)addItems:(NSSet *)values;
- (void)removeItems:(NSSet *)values;

@end
