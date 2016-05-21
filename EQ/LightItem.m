//
//  LightItem.m
//  EQ
//
//  Created by Pablo Suarez on 12/14/15.
//  Copyright © 2015. All rights reserved.
//

#import "LightItem.h"

@implementation LightItem

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.articuloID = @"";
    self.cantidad = 0;
    self.cantidadFacturada = 0;
    self.nombre = @"";
    self.precio = 0;
    
    self.categoryIndex = -1;
    self.group1Index = -1;
    self.group2Index = -1;
    self.articleIndex = -1;

    return self;
}


- (CGFloat)totalConDescuento {
    CGFloat total =self.precio * self.cantidad;
    return total;
}



@end
