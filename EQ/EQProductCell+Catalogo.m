//
//  EQProductCell+Catalogo.m
//  EQ
//
//  Created by Sebastian Borda on 10/26/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQProductCell+Catalogo.h"
#import "EQImagesManager.h"
#import "CatalogoImagen.h"

@implementation EQProductCell (Catalogo)

- (void)loadCatalog:(Catalogo *)catalog {
    self.productNameLabel.text = catalog.titulo;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pagina" ascending:YES];
    NSArray *photos = [catalog.imagenes sortedArrayUsingDescriptors:@[sortDescriptor]];
    if ([photos count] > 0) {
        CatalogoImagen *imagenCatalog = [photos objectAtIndex:0];
        UIImage *image = [[EQImagesManager sharedInstance] imageNamed:imagenCatalog.nombre];
        self.productImage.image = image;
    } else {
       self.productImage.image = [UIImage imageNamed:@"catalogoFotoProductoInexistente.png"];
    }
    
    self.productStatusLabel.hidden = YES;
    self.agotadoImage.hidden = YES;
    self.codigoIcon.hidden = YES;
    self.productCodeLabel.hidden = YES;
    self.productCostLabel.hidden = YES;
}

@end
