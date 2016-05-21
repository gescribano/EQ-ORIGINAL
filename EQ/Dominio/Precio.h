//
//  Precio.h
//  EQ
//
//  Created by Sebastian Borda on 8/25/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Precio : NSManagedObject

@property (nonatomic, retain) NSNumber * activo;
@property (nonatomic, retain) NSString * articuloID;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * importe;
@property (nonatomic, retain) NSString * numero;

@end
