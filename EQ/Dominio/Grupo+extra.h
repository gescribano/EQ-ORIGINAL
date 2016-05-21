//
//  Grupo+extra.h
//  EQ
//
//  Created by Sebastian Borda on 6/28/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Grupo.h"

@interface Grupo (extra)

@property (nonatomic,strong) NSArray *articulos;
@property (nonatomic,strong) NSArray *parents;
@property (nonatomic,strong) NSArray *subGrupos;

- (Grupo *)parent;
+ (void)resetRelevancia;

@end
