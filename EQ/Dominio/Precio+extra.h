//
//  Precio+extra.h
//  EQ
//
//  Created by Sebastian Borda on 6/27/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Precio.h"
#import "Cliente.h"

@interface Precio (extra)

@property (nonatomic,strong) NSArray *articulo;

- (CGFloat)priceForActiveClient;
- (CGFloat)priceForClient:(Cliente *)client;

@end
