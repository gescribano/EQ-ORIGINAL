//
//  ItemPedido+extra.m
//  EQ
//
//  Created by Sebastian Borda on 5/20/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "ItemPedido+extra.h"
#import "Articulo.h"
#import "Precio.h"
#import "Precio+extra.h"
#import "Articulo+extra.h"
#import "EQDataAccessLayer.h"
#import "Pedido+extra.h"
#import "ItemFacturado.h"

@implementation ItemPedido (extra)

@dynamic articulos;
@dynamic itemsFacturados;

- (CGFloat)totalConDescuento{
    CGFloat total = [[self.articulo priceForClient:self.pedido.cliente] priceForClient:self.pedido.cliente] * [self.cantidad intValue];
    return total;
}

- (CGFloat)totalSinDescuento{
    CGFloat total = [[self.articulo priceForClient:self.pedido.cliente].importe floatValue] * [self.cantidad intValue];
    return total;
}

- (Articulo *)articulo
{
    return [self.articulos firstObject];
}

- (ItemPedido *)copy{
    ItemPedido *item = (ItemPedido *)[[EQDataAccessLayer sharedInstance] createManagedObject:@"ItemPedido"];
    item.articuloID = self.articuloID;
    item.descuento1 = self.descuento1;
    item.descuento2 = self.descuento2;
    item.cantidad = self.cantidad;
    item.descuentoMonto = self.descuentoMonto;
    item.importeConDescuento = self.importeConDescuento;
    item.importeFinal = self.importeFinal;
    item.orden = self.orden;
    item.precioUnitario = self.precioUnitario;
    
    return item;
}


- (NSString *)itemPedidoHTML{
    NSMutableString *item = [NSMutableString stringWithString:@"<tr>"];
    [item appendFormat:@"<td align='center'>%@</td>",self.articulo.nombre];
    [item appendFormat:@"<td align='center'>%@</td>",self.cantidad];
    [item appendFormat:@"<td align='center'>%@</td>",self.cantidadFacturada];
    [item appendFormat:@"<td align='right'>$%.2f</td>",[self.precioUnitario floatValue]];
    [item appendFormat:@"<td align='right'>$%.2f</td>",[self totalSinDescuento]];
    [item appendFormat:@"<td align='right'>$%.2f</td>",[self totalConDescuento]];
    [item appendString:@"</tr>"];
    
    return item;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Pedido:%@ Articulo:%@ Cantidad:%@ Orden:%@",self.pedido.identifier, self.articuloID, self.cantidad, self.orden];
}

- (NSArray *)articulos
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.articuloID];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Articulo class] filterByPredicate:predicate];
}

- (NSArray *)itemsFacturados
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"itemId == %@",self.identifier];
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"itemId" ascending:NO];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[ItemFacturado class] filterByPredicate:predicate sortBy:sort limit:0];
}

@end
