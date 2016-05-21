//
//  EQEditOrderDetailCell.m
//  EQ
//
//  Created by Sebastian Borda on 5/19/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQEditOrderDetailCell.h"
#import "Articulo.h"
#import "NSNumber+EQ.h"

@interface EQEditOrderDetailCell()

@property (nonatomic,strong) ItemPedido *item;

@end

@implementation EQEditOrderDetailCell


- (void)loadItem:(ItemPedido *)item{
    self.item = item;
    self.codeLabel.text = item.articulo.codigo;
    self.productNameLabel.text = item.articulo.nombre;
    self.quantityLabel.text = [item.cantidad stringValue];
    self.priceLabel.text = [NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:[item totalConDescuento]] currencyString]];
    self.quantitySold.text =  [item.cantidadFacturada stringValue];
}

- (IBAction)editButtonAction:(id)sender {
    [self.delegate editItem:self.item];
}

- (IBAction)deleteButtonAction:(id)sender {
    [self.delegate removeItem:self.item];
}
@end
