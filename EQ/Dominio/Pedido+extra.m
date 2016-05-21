//
//  Pedido+extra.m
//  EQ
//
//  Created by Sebastian Borda on 6/29/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Pedido+extra.h"
#import "ItemPedido+extra.h"
#import "EQDataAccessLayer.h"
#import "ItemFacturado.h"
#import "Vendedor.h"
#import "NSString+MD5.h"

@implementation Pedido (extra)

@dynamic clientes;
@dynamic vendedores;


- (Vendedor *)vendedor{
    return [self.vendedores lastObject];
}

- (float)porcentajeDescuento{
    CGFloat descuento = (1 - (1 - ([self.descuento3 floatValue] / 100)) * (1 - ([self.descuento4 floatValue] / 100))) * 100;
    return descuento;
}

- (Pedido *)copy{
    Pedido *order = (Pedido *)[[EQDataAccessLayer sharedInstance] createManagedObject:@"Pedido"];
    order.activo = self.activo;
    order.actualizado = [NSNumber numberWithBool:NO];
    order.descuento = self.descuento;
    order.descuento3 = self.descuento3;
    order.descuento4 = self.descuento4;
    order.latitud = self.latitud;
    order.longitud = self.longitud;
    order.observaciones = self.observaciones;
    order.subTotal = self.subTotal;
    order.total = self.total;
    order.cliente = self.cliente;
    order.vendedorID = self.vendedorID;
    order.hashId = self.hashId;
    for (ItemPedido *item in self.items) {
        [order addItemsObject:[item copy]];
    }
    
    return order;
}

- (NSDate *)ultimaFechaDeFacturacion {
    NSDate *ultimaFecha = nil;
    for (NSDate *date in [self fechasFacturacion]) {
        if(!ultimaFecha || [date compare: ultimaFecha] == NSOrderedDescending) {
            ultimaFecha = date;
        }
    }
    return ultimaFecha;
}

- (NSDate *)primerFechaDeFacturacion {
    NSDate *primerFecha = nil;
    for (NSDate *date in [self fechasFacturacion]) {
        if(!primerFecha || [date compare: primerFecha] == NSOrderedAscending) {
            primerFecha = date;
        }
    }
    return primerFecha;
}

- (NSMutableArray *)fechasFacturacion{
    ItemPedido *item = [self.items anyObject];
    NSMutableArray *fechas = [NSMutableArray array];
    for (ItemFacturado *facturado in item.itemsFacturados) {
        if (facturado.facturado) {
            [fechas addObject:facturado.facturado];
        }
    }
    return fechas;
}

- (NSString *)pedidoHTML {
    NSMutableString *pedido = [NSMutableString stringWithString:@"<div>"];
    [pedido appendFormat:@"<span>Vendedor: %@</span><br>",self.vendedor.descripcion];
    [pedido appendFormat:@"<span>Cliente: %@</span><br>",self.cliente.nombre];
    [pedido appendFormat:@"<span>Estado: %@</span><br>",self.estado];
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"dd/MM/yyyy"];
    [pedido appendFormat:@"<span>Fecha: %@</span><br>",[dateFormat stringFromDate:self.fecha]];
    [pedido appendFormat:@"<span>Importe Bruto: $%.2f</span><br>",[self.subTotal floatValue]];
    [pedido appendFormat:@"<span>Descuento: %.2f%%</span><br>",self.porcentajeDescuento];
    [pedido appendFormat:@"<span>Importe Neto: $%.2f</span><br>",[self.total floatValue]];
    [pedido appendFormat:@"<span>Comentarios: %@</span><br>",self.observaciones];
    [pedido appendString:@"</div><br>"];
    
    [pedido appendString:@"<table border='1'>"];
    [pedido appendString:@"<tr>"];
    [pedido appendString:@"<th align='center'>Articulo</th>"];
    [pedido appendString:@"<th align='center'>Cantidad Pedida</th>"];
    [pedido appendString:@"<th align='center'>Cantidad Facturada</th>"];

    [pedido appendString:@"<th align='center'>Precio</th>"];
    [pedido appendString:@"<th align='center'>Importe</th>"];
    [pedido appendString:@"<th align='center'>Importe con Desc.</th>"];
    [pedido appendString:@"</tr>"];
    NSArray *sortedItems = [self sortedItems];
    for (ItemPedido* item in sortedItems) {
        [pedido appendString:[item itemPedidoHTML]];
    }
    [pedido appendString:@"</table>"];
    
    return pedido;
}

- (NSArray *)sortedItems {
    NSArray *originalItems = [self.items allObjects];
    NSArray *sortedArray = [originalItems sortedArrayUsingComparator: ^(ItemPedido *obj1, ItemPedido *obj2) {
        
        if ([obj1.orden integerValue] > [obj2.orden integerValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1.orden integerValue] < [obj2.orden integerValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    }];
    return  sortedArray;
}

-(NSArray *)vendedores
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.vendedorID];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Vendedor class] filterByPredicate:predicate];
}


-(void)createHash {
  
  NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
  [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
  NSLog(@"date[%@]", [dateFormatter stringFromDate:self.fecha]);
  
  NSString *orderCode = [NSString stringWithFormat:@"%@&%@&%@&%@",[dateFormatter stringFromDate:self.fecha],self.vendedorID, self.cliente.identifier,[self total]];
  NSLog(@"parseOrder hash:[%@]", [orderCode MD5]);
  
  self.hashId = [orderCode MD5];
  
}

@end
