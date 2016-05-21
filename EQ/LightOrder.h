//
//  LightOrder.h
//  EQ
//
//  Created by Pablo Suarez on 12/14/15.
//

#import <Foundation/Foundation.h>
#import "LightItem.h"


//modela en memoria un array de items de una orden

@interface LightOrder : NSObject

- (NSInteger)addItem:(LightItem *)value;
- (NSInteger)removeItem:(LightItem *)value;
- (NSArray*)orderItems;
- (NSInteger)numberOfItems;

@end
