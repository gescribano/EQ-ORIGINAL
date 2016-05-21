//
//  LightItem.h
//  EQ
//
//  Created by Pablo Suarez on 12/14/15.
//  Copyright © 2015. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LightItem : NSObject

@property (nonatomic, assign) NSInteger categoryIndex;
@property (nonatomic, assign) NSInteger group1Index;
@property (nonatomic, assign) NSInteger group2Index;
@property (nonatomic, assign) NSInteger articleIndex;

@property (nonatomic, retain) NSString * articuloID;
@property (nonatomic, retain) NSString * codigo;

@property (nonatomic, assign) NSInteger cantidad;
@property (nonatomic, assign) NSInteger cantidadFacturada;

@property (nonatomic, retain) NSString * nombre;
@property (nonatomic, assign) CGFloat precio;



//@property (nonatomic, retain) NSNumber * cantidadFacturada;
//@property (nonatomic, retain) NSNumber * descuento1;
//@property (nonatomic, retain) NSNumber * descuento2;
//@property (nonatomic, retain) NSNumber * descuentoMonto;
//@property (nonatomic, retain) NSString * identifier;
//@property (nonatomic, retain) NSNumber * importeConDescuento;
//@property (nonatomic, retain) NSNumber * importeFinal;
//@property (nonatomic, retain) NSNumber * precioUnitario;
//@property (nonatomic, retain) NSNumber * orden;



- (CGFloat)totalConDescuento;


@end