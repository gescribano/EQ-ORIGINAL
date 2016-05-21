//
//  Catalogo.h
//  EQ
//
//  Created by Sebastian Borda on 11/1/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Grupo;

@interface Catalogo : NSManagedObject

@property (nonatomic, retain) NSData * fotos;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSNumber * posicion;
@property (nonatomic, retain) NSSet *categorias;
@end

@interface Catalogo (CoreDataGeneratedAccessors)

- (void)addCategoriasObject:(Grupo *)value;
- (void)removeCategoriasObject:(Grupo *)value;
- (void)addCategorias:(NSSet *)values;
- (void)removeCategorias:(NSSet *)values;

@end
