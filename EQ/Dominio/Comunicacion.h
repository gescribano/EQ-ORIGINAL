//
//  Comunicacion.h
//  EQ
//
//  Created by Sebastian Borda on 8/25/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Comunicacion : NSManagedObject

@property (nonatomic, retain) NSNumber * activo;
@property (nonatomic, retain) NSNumber * actualizado;
@property (nonatomic, retain) NSString * clienteID;
@property (nonatomic, retain) NSNumber * codigoSerial;
@property (nonatomic, retain) NSDate * creado;
@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSDate * leido;
@property (nonatomic, retain) NSString * receiverID;
@property (nonatomic, retain) NSString * senderID;
@property (nonatomic, retain) NSString * threadID;
@property (nonatomic, retain) NSString * tipo;
@property (nonatomic, retain) NSString * titulo;

@end
