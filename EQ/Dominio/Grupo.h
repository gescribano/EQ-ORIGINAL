//
//  Grupo.h
//  EQ
//
//  Created by Sebastian Borda on 9/2/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Grupo : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSString * descripcion;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, retain) NSString * parentID;
@property (nonatomic, retain) NSNumber * relevancia;
@property (nonatomic, retain) NSString * imagen;

@end
