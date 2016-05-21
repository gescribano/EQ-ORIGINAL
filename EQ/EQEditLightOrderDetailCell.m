//
//  EQEditLightOrderDetailCell.m
//  EQ
//
//  Created by Pablo Suarez
//  Copyright (c) 2015. All rights reserved.
//

#import "EQEditLightOrderDetailCell.h"
#import "Articulo.h"
#import "NSNumber+EQ.h"

@interface EQEditLightOrderDetailCell()

@property (nonatomic,strong) LightItem *lightItem;

@end

@implementation EQEditLightOrderDetailCell


- (void)loadItem:(LightItem *)item{
    self.lightItem = item;
    self.codeLabel.text = item.codigo;
    self.productNameLabel.text = item.nombre;
    self.quantityLabel.text = [NSString stringWithFormat:@"%ld", (long)item.cantidad ];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:[item totalConDescuento]] currencyString]];
    self.quantitySold.text =  [NSString stringWithFormat:@"%ld", (long)item.cantidadFacturada ];
}



- (IBAction)editButtonAction:(id)sender {
    [self.delegate editItem:self.lightItem];
}

- (IBAction)deleteButtonAction:(id)sender {
    [self.delegate removeItem:self.lightItem];
}
@end
