//
//  CtaCte.h
//  EQ
//
//  Created by Sebastian Borda on 1/27/14.
//  Copyright (c) 2014 Sebastian Borda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CtaCte : NSManagedObject

@property (nonatomic, retain) NSString * clienteID;
@property (nonatomic, retain) NSString * comprobante;
@property (nonatomic, retain) NSString * condicionDeVenta;
@property (nonatomic, retain) NSString * empresa;
@property (nonatomic, retain) NSDate * fecha;
@property (nonatomic, retain) NSString * identifier;
@property (nonatomic, retain) NSNumber * importe;
@property (nonatomic, retain) NSNumber * importeConDescuento;
@property (nonatomic, retain) NSNumber * importePercepcion;
@property (nonatomic, retain) NSString * vendedorID;
@property (nonatomic, retain) NSNumber * activo;

@end
