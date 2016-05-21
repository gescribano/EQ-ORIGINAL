//
//  EQProductCell.m
//  EQ
//
//  Created by Sebastian Borda on 4/25/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQProductCell.h"
#import "Disponibilidad+extra.h"
#import "Precio+extra.h"
#import "NSNumber+EQ.h"
#import "Articulo+extra.h"

@implementation EQProductCell

- (void)prepareForReuse
{
    self.productImage.image = [UIImage imageNamed:@"catalogoFotoProductoInexistente"];
    self.productNameLabel.text = @"";
    self.productStatusLabel.text = @"";
    self.productCodeLabel.text = @"";
    self.productCostLabel.text = @"";
    self.agotadoImage.image = nil;
}

- (void)loadArticle:(Articulo *)art {
    self.productNameLabel.text = art.nombre;
    self.productStatusLabel.text = art.disponibilidad.descripcion;
    [self.productImage loadURL:art.imagenURL];
    CGFloat precioFloat = [art priceForActiveClient].importe ? [[art priceForActiveClient] priceForActiveClient] : 0;
    self.productCostLabel.text = [NSString stringWithFormat:@"%@", [[NSNumber numberWithFloat:precioFloat] currencyString]];
    self.productCodeLabel.text = art.codigo;
    if([art.disponibilidad isAvailable]){
        self.productStatusLabel.hidden = YES;
        self.agotadoImage.hidden = YES;
    } else {
        self.productStatusLabel.hidden = NO;
        self.agotadoImage.hidden = NO;
        self.productStatusLabel.text = art.disponibilidad.descripcion;
    }
}

@end
