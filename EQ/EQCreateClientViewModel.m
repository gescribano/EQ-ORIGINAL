//
//  EQCreateClientViewModel.h
//  EQ
//
//  Created by Sebastian Borda on 5/8/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQCreateClientViewModel.h"
#import "EQDataAccessLayer.h"
#import "EQDataManager.h"
#import "Provincia.h"
#import "ZonaEnvio.h"
#import "Expreso.h"
#import "Vendedor.h"
#import "Vendedor.h"
#import "Provincia.h"
#import "LineaVTA.h"
#import "TipoIvas.h"
#import "CondPag.h"
#import "NSString+Number.h"
#import "EQSession.h"
#import "Usuario.h"
#import "Cliente+extra.h"

@implementation EQCreateClientViewModel

- (id)init
{
    self = [super init];
    if (self) {
        self.selectedTaxAtIndex = -1;
        self.selectedProvinceAtIndex = -1;
        self.selectedPaymentConditionAtIndex = -1;
        self.selectedCollectorAtIndex = -1;
        self.selectedSellerAtIndex = -1;
        self.selectedSalesLineAtIndex = -1;
        self.selectedDeliveryAreaAtIndex = -1;
        self.selectedExpressAtIndex = -1;
    }
    return self;
}

- (void)loadData{
    if (self.client) {
        self.selectedTaxAtIndex = (int)[[self obtainTaxesList] indexOfObject:self.client.iva];
        self.selectedProvinceAtIndex = (int)[[self obtainProvinces] indexOfObject:self.client.provincia];
        self.selectedPaymentConditionAtIndex = (int)[[self obtainPaymentConditionList] indexOfObject:self.client.condicionDePago];
        self.selectedExpressAtIndex = (int)[[self obtainExpressList] indexOfObject:self.client.expreso];
        self.selectedDeliveryAreaAtIndex = (int)[[self obtainDeliveryAreaList] indexOfObject:self.client.zonaEnvio];
        self.selectedSalesLineAtIndex = (int)[[self obtainSalesLineList] indexOfObject:self.client.lineaDeVenta];
        self.hasDiscount = [self.client.conDescuento boolValue];
    }
    
}

- (void)saveClient:(NSDictionary *)clientDictionary{
    if (!self.client)
    {
        self.client = (Cliente *)[[EQDataAccessLayer sharedInstance] createManagedObject:NSStringFromClass([Cliente class])];
    }
    
    self.client.codigoPostal = clientDictionary[@"zipcode"];
    self.client.cuit = clientDictionary[@"cuit"];
    self.client.descuento1 = [clientDictionary[@"discount1"] numberAR];
    self.client.descuento2 = [clientDictionary[@"discount2"] numberAR];
    self.client.descuento3 = [clientDictionary[@"discount3"] numberAR];
    self.client.descuento4 = [clientDictionary[@"discount4"] numberAR];
    self.client.diasDePago = clientDictionary[@"collectionDays"];
    self.client.domicilio = clientDictionary[@"address"];
    self.client.domicilioDeEnvio = clientDictionary[@"deliveryAddress"];
    self.client.encCompras = clientDictionary[@"purchaseManager"];
    self.client.horario = clientDictionary[@"schedule"];
    self.client.latitud = [[EQSession sharedInstance] currentLatitude];
    self.client.localidad = clientDictionary[@"locality"];
    self.client.longitud = [[EQSession sharedInstance] currentLongitude];
    self.client.mail = clientDictionary[@"email"];
    self.client.nombre = clientDictionary[@"name"];
    self.client.nombreDeFantasia = clientDictionary[@"alias"];
    self.client.observaciones = clientDictionary[@"observations"];
    self.client.propietario = clientDictionary[@"owner"];
    self.client.telefono = clientDictionary[@"phone"];
    self.client.web = clientDictionary[@"web"];
    self.client.activo = [NSNumber numberWithBool:YES];
    self.client.conDescuento = [NSNumber numberWithBool:self.hasDiscount];
    
    if (self.selectedCollectorAtIndex != -1 )
        self.client.cobradorID = ((Vendedor *)[self obtainCollectorList][self.selectedCollectorAtIndex]).identifier;
    else
        self.client.cobradorID = [EQSession sharedInstance].user.vendedorID;
    if (self.selectedPaymentConditionAtIndex != -1 )
        self.client.condicionDePagoID = ((CondPag *)[self obtainPaymentConditionList][self.selectedPaymentConditionAtIndex]).identifier;
    if (self.selectedExpressAtIndex != -1  )
        self.client.expresoID = ((Expreso *)[self obtainExpressList][self.selectedExpressAtIndex]).identifier;
    if (self.selectedTaxAtIndex != -1  )
        self.client.ivaID = ((TipoIvas *)[self obtainTaxesList][self.selectedTaxAtIndex]).identifier;
    if (self.selectedSalesLineAtIndex != -1  )
        self.client.lineaDeVentaID = ((LineaVTA *)[self obtainSalesLineList][self.selectedSalesLineAtIndex]).identifier;
    if (self.selectedSellerAtIndex != -1  )
        self.client.vendedorID = ((Vendedor *)[self obtainSellersList][self.selectedSellerAtIndex]).identifier;
    else
        self.client.vendedorID = [EQSession sharedInstance].user.vendedorID;
    if (self.selectedProvinceAtIndex != -1  )
        self.client.provinciaID = ((Provincia *)[self obtainProvinces][self.selectedProvinceAtIndex]).identifier;
    if (self.selectedDeliveryAreaAtIndex != -1  )
        self.client.zonaEnvioID = ((ZonaEnvio *)[self obtainDeliveryAreaList][self.selectedDeliveryAreaAtIndex]).identifier;
    
    self.client.listaPrecios = [EQSession sharedInstance].settings.defaultPriceList;
    
    self.client.actualizado = [NSNumber numberWithBool:NO];
    
    NSError*error;
    [self.client.managedObjectContext save:&error];
    
    if (error)
    {
        NSLog(@"ERROR GUARDANDO CLIENTE %@",error);
    }
    
    [[EQSession sharedInstance] updateCache];
    
    [[EQDataManager sharedInstance] sendClient:self.client
                                       success:^
     {
         
     }
                                       failure:^(NSError *error)
     {
         
     }];
    
    [EQSession sharedInstance].selectedClient = self.client;
}

- (NSArray *)obtainProvinces{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Provincia class] filterByPredicate:nil sortBy:[NSSortDescriptor sortDescriptorWithKey:@"descripcion" ascending:YES] limit:0];
}

- (NSArray *)obtainDeliveryAreaList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[ZonaEnvio class] filterByPredicate:nil sortBy:[NSSortDescriptor sortDescriptorWithKey:@"descripcion" ascending:YES] limit:0];
}

- (NSArray *)obtainExpressList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Expreso class] filterByPredicate:nil sortBy:[NSSortDescriptor sortDescriptorWithKey:@"descripcion" ascending:YES] limit:0];
}

- (NSArray *)obtainSellersList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Vendedor class]];
}

- (NSArray *)obtainCollectorList{
    return [self obtainSellersList];
}

- (NSArray *)obtainSalesLineList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[LineaVTA class] filterByPredicate:nil sortBy:[NSSortDescriptor sortDescriptorWithKey:@"descripcion" ascending:YES] limit:0];
}

- (NSArray *)obtainPaymentConditionList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[CondPag class] filterByPredicate:nil sortBy:[NSSortDescriptor sortDescriptorWithKey:@"descripcion" ascending:YES] limit:0];
}

- (NSArray *)obtainTaxesList{
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[TipoIvas class] filterByPredicate:nil sortBy:[NSSortDescriptor sortDescriptorWithKey:@"descripcion" ascending:YES] limit:0];
}

- (void)selectedDiscountAtIndex:(int)index{
    self.hasDiscount = index == 1;
}

- (void)selectedTaxAtIndex:(int)index{
    self.selectedTaxAtIndex = index;
}

- (void)selectedProvinceAtIndex:(int)index{
    self.selectedProvinceAtIndex = index;
}

- (void)selectedPaymentConditionAtIndex:(int)index{
    self.selectedPaymentConditionAtIndex = index;
}

- (void)selectedCollectorAtIndex:(int)index
{
    self.selectedCollectorAtIndex = index;
}

- (void)selectedSellerAtIndex:(int)index{
    self.selectedSellerAtIndex = index;
}

- (void)selectedSalesLineAtIndex:(int)index{
    self.selectedSalesLineAtIndex = index;
}

- (void)selectedDeliveryAreaAtIndex:(int)index{
    self.selectedDeliveryAreaAtIndex = index;
}

- (void)selectedExpressAtIndex:(int)index{
    self.selectedExpressAtIndex = index;
}

- (NSString *)obtainSelectedSeller{
    return [self.client.vendedor.descripcion length] > 0 ? self.client.vendedor.descripcion : [self sellerName];
}

- (NSString *)obtainSelectedCollector{
    return [self.client.cobrador.descripcion length] > 0 ? self.client.cobrador.descripcion : [self sellerName];
}

- (NSString *)obtainSelectedProvince{
    return [self.client.provincia.descripcion length] > 0 ? self.client.provincia.descripcion : @"Seleccione una zona";
}

- (NSString *)obtainSelectedDeliveryArea{
    return [self.client.zonaEnvio.descripcion length] > 0 ? self.client.zonaEnvio.descripcion : @"Seleccione una zona de envio";
}

- (NSString *)obtainSelectedPaymentCondition{
    return [self.client.condicionDePago.descripcion length] > 0 ? self.client.condicionDePago.descripcion : @"seleccione una condición de pago";
}

- (NSString *)obtainSelectedExpress{
    return [self.client.expreso.descripcion length] > 0 ? self.client.expreso.descripcion : @"Seleccione un expreso";
}

- (NSString *)obtainSelectedTaxes{
    return [self.client.iva.descripcion length] > 0 ? self.client.iva.descripcion : @"Seleccione un tipo de IVA";
}

- (NSString *)obtainSelectedSalesLine{
    return [self.client.lineaDeVenta.descripcion length] > 0 ? self.client.lineaDeVenta.descripcion : @"Seleccione una línea de venta";
}

@end