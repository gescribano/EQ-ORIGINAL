//
//  Cliente+extra.m
//  EQ
//
//  Created by Sebastian Borda on 6/28/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Cliente+extra.h"
#import "ItemPedido+extra.h"
#import "Pedido+extra.h"
#import "Articulo+extra.h"
#import "Grupo+extra.h"
#import "EQDataAccessLayer.h"
#import "Vendedor+extra.h"
#import "CondPag.h"
#import "CtaCte+extra.h"
#import "Expreso.h"
#import "TipoIvas.h"
#import "LineaVTA.h"
#import "Precio+extra.h"
#import "Provincia.h"
#import "Venta+extra.h"
#import "ZonaEnvio.h"

@implementation Cliente (extra)

@dynamic ventas;
@dynamic condicionesDePago;
@dynamic expresos;
@dynamic lineasDeVenta;
@dynamic ivas;
@dynamic provincias;
@dynamic zonasEnvio;
@dynamic pedidos;
@dynamic listaDePrecios;
@dynamic cobradores;
@dynamic vendedores;
@dynamic ctaCteList;



- (Provincia *)provincia{
    return [self.provincias lastObject];
}

- (Expreso *)expreso{
    return [self.expresos lastObject];
}

- (LineaVTA *)lineaDeVenta{
    return [self.lineasDeVenta lastObject];
}

- (TipoIvas *)iva{
    return [self.ivas lastObject];
}

- (ZonaEnvio *)zonaEnvio{
    return [self.zonasEnvio lastObject];
}

- (CondPag *)condicionDePago{
    return [self.condicionesDePago lastObject];
}

- (Vendedor *)vendedor{
    return [self.vendedores lastObject];
}

- (Vendedor *)cobrador{
    return [self.cobradores lastObject];
}

- (void)calcularRelevancia{
    for (Pedido *pedido in self.pedidos) {
        for (ItemPedido *item in pedido.items) {
            Grupo *grupo = item.articulo.grupo;
            grupo.relevancia = [NSNumber numberWithInt:[item.cantidad intValue] + [grupo.relevancia intValue]];
            
            if (![grupo.parentID isEqualToString:@"0"]) {
                Grupo *grupo2 = grupo.parent;
                grupo2.relevancia = [NSNumber numberWithInt:[item.cantidad intValue] + [grupo2.relevancia intValue]];
                
                if(![grupo2.parentID isEqualToString:@"0"]){
                    Grupo *grupo3 = grupo2.parent;
                    grupo3.relevancia = [NSNumber numberWithInt:[item.cantidad intValue] + [grupo3.relevancia intValue]];
                    
                }
            }
        }
    }
    [[EQDataAccessLayer sharedInstance] saveContext];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"Cliente id:%@ nombre:%@ desc1-2-3-4:%@-%@-%@-%@ cod1-2:%@-%@",self.identifier,self.nombre,self.descuento1,self.descuento2,self.descuento3,self.descuento4,self.codigo1,self.codigo2];
}

+ (Cliente*) findById:(NSNumber *) clientId
{
    EQDataAccessLayer *dal = [EQDataAccessLayer sharedInstance];
    Cliente* cliente = [dal objectForClass:[Cliente class] withPredicate:[NSPredicate predicateWithFormat:@"SELF.identifier == %@",clientId]];
    return cliente;
}

- (NSArray *)cobradores
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.cobradorID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Vendedor class] filterByPredicate:predicate];
}

- (NSArray *)condicionesDePago
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.condicionDePagoID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[CondPag class] filterByPredicate:predicate];
}

- (NSArray *)ctaCteList
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"clienteID == %@",self.identifier];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[CtaCte class] filterByPredicate:predicate];
}

- (NSArray *)expresos
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.expresoID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Expreso class] filterByPredicate:predicate];
}

- (NSArray *)ivas
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.ivaID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[TipoIvas class] filterByPredicate:predicate];
}

- (NSArray *)lineasDeVenta
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.lineaDeVentaID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[LineaVTA class] filterByPredicate:predicate];
}

- (NSArray *)listaDePrecios
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"numero == %@",self.listaPrecios];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Precio class] filterByPredicate:predicate];
}

- (NSArray *)provincias
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.provinciaID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Provincia class] filterByPredicate:predicate];
}

- (NSArray *)vendedores
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.vendedorID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Vendedor class] filterByPredicate:predicate];
}

- (NSArray *)ventas
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"ClienteID == %@ && activo == 1",self.identifier];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Venta class] filterByPredicate:predicate];
}

- (NSArray *)zonasEnvio
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.zonaEnvioID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[ZonaEnvio class] filterByPredicate:predicate];
}

@end
