//
//  LightOrder.m
//  EQ
//
//  Created by Pablo Suarez on 12/14/15.
//  Copyright © 2015 Sebastian Borda. All rights reserved.
//

#import "LightOrder.h"


@interface LightOrder()

@property (nonatomic, retain) NSMutableArray  *items;

@end

@implementation LightOrder


- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.items = [NSMutableArray array];
    
    return self;
}


- (NSArray*)orderItems {
    return self.items;
}

- (NSInteger)numberOfItems {
    return [self.items count];
}


- (NSInteger)addItem:(LightItem *)value {
    [self.items addObject:value];
    return [self.items count];
}

- (NSInteger)removeItem:(LightItem *)value {
    NSInteger itemIndex = [self.items indexOfObject:value];
    [self.items removeObjectAtIndex:itemIndex];
    return itemIndex;
}

@end
