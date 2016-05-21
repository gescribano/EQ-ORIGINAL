//
//  Vendedor.h
//  EQ
//
//  Created by Sebastian Borda on 8/25/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Usuario;

@interface Vendedor : NSManagedObject

@property (nonatomic, retain) NSNumber * activo;
@property (nonatomic, retain) NSString * codigo;
@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * usuarioID;
@property (nonatomic, retain) Usuario *usuario;

@end
