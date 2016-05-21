//
//  Catalogo+extra.h
//  EQ
//
//  Created by Sebastian Borda on 10/25/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Catalogo.h"

@interface Catalogo (extra)

@property (nonatomic,strong) NSArray* imagenes;

-(void)setPhotosList:(NSArray*)list;

-(NSArray *)getPhotosList;

@end
