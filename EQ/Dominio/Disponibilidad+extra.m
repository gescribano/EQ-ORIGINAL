//
//  Disponibilidad+extra.m
//  EQ
//
//  Created by Sebastian Borda on 8/14/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Disponibilidad+extra.h"

@implementation Disponibilidad (extra)

- (BOOL)isAvailable {
    return [self.identifier integerValue] >= 1;
}

@end
