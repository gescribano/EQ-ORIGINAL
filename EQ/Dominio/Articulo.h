//
//  Articulo.h
//  EQ
//
//  Created by Jonathan on 9/23/15.
//  Copyright (c) 2015 Sebastian Borda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Articulo : NSManagedObject

@property (nonatomic, retain) NSNumber * activo;
@property (nonatomic, retain) NSNumber * cantidadPredeterminada;
@property (nonatomic, retain) NSString * codigo;
@property (nonatomic, retain) NSDate * creado;
@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSString * disponibilidadID;
@property (nonatomic, retain) NSString * grupoID;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * imagenURL;
@property (nonatomic, retain) NSNumber * minimoPedido;
@property (nonatomic, retain) NSDate * modificado;
@property (nonatomic, retain) NSNumber * multiploPedido;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * tipo;
@property (nonatomic, retain) NSString * estado;

@end
