//
//  EQCreateClientViewController.m
//  EQ
//
//  Created by Sebastian Borda on 5/8/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQCreateClientViewController.h"
#import "NSMutableDictionary+EQ.h"
#import "Provincia.h"
#import "ZonaEnvio.h"
#import "Expreso.h"
#import "Vendedor.h"
#import "Vendedor.h"
#import "Provincia.h"
#import "LineaVTA.h"
#import "TipoIvas.h"
#import "CondPag.h"
#import "EQSession.h"

@interface EQCreateClientViewController ()

@property (nonatomic,strong) NSMutableString *ErrorMessage;
@property (nonatomic,strong) EQCreateClientViewModel *viewModel;

@end

@implementation EQCreateClientViewController

- (id)init
{
    self = [super init];
    if (self) {
        self.viewModel = [EQCreateClientViewModel new];
        self.viewModel.delegate = self;
        [self.viewModel loadData];
    }
    return self;
}

- (id)initWithClient:(Cliente*)client
{
    self = [super init];
    if (self) {
        self.viewModel = [EQCreateClientViewModel new];
        self.viewModel.delegate = self;
        self.viewModel.client = client;
        [self.viewModel loadData];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    Cliente *client = self.viewModel.client;
    self.createClientTitleLabel.text = @"Nuevo cliente";
    if (client) {
        self.clientNameTextField.text = client.nombre;
        self.clientAliasTextField.text = client.nombreDeFantasia;
        self.clientPhoneTextField.text = client.telefono;
        self.clientWebTextField.text = client.web;
        self.clientZipCodeTextField.text = client.codigoPostal;
        self.CUITTextField.text = [client.cuit stringByReplacingOccurrencesOfString:@"-" withString:@""];
        self.clientEmailTextField.text = client.mail;
        self.clientAddressTextField.text = client.domicilio;
        self.deliveryAddressTextField.text = client.domicilioDeEnvio;
        self.clientLocalityTextField.text = client.localidad;
        self.ownerNameTextField.text = client.propietario;
        self.purchaseManagerTextField.text = client.encCompras;
        self.scheduleTextField.text = client.horario;
        self.collectionDaysTextField.text = client.diasDePago;
        NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
        [formatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"es_AR"]];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
        self.discount1TextField.text = [formatter stringFromNumber:client.descuento1];
        self.discount2TextField.text = [formatter stringFromNumber:client.descuento2];
        self.discount3TextField.text = [formatter stringFromNumber:client.descuento3];
        self.discount4TextField.text = [formatter stringFromNumber:client.descuento4];
        self.observationsTextField.text = client.observaciones;
        self.createClientTitleLabel.text = @"Modificar cliente";
    }
    
    [self.provinceButton setTitle:[self.viewModel obtainSelectedProvince] forState:UIControlStateNormal];
    [self.paymentConditionButton setTitle:[self.viewModel obtainSelectedPaymentCondition] forState:UIControlStateNormal];
    [self.sellerButton setTitle:[self.viewModel obtainSelectedSeller] forState:UIControlStateNormal];
    [self.collectorButton setTitle:[self.viewModel obtainSelectedCollector] forState:UIControlStateNormal];
    [self.expressButton setTitle:[self.viewModel obtainSelectedExpress] forState:UIControlStateNormal];
    [self.taxesButton setTitle:[self.viewModel obtainSelectedTaxes] forState:UIControlStateNormal];
    [self.salesLineButton setTitle:[self.viewModel obtainSelectedSalesLine] forState:UIControlStateNormal];
    [self.deliveryAreaButton setTitle:[self.viewModel obtainSelectedDeliveryArea] forState:UIControlStateNormal];
    [self.discountButton setTitle:[self.viewModel hasDiscount] ? @"Si" : @"No" forState:UIControlStateNormal];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[EQSession sharedInstance] startMonitoring];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[EQSession sharedInstance] stopMonitoring];
}

- (void)addMessageError:(NSString *)messageError {
    if ([self.ErrorMessage length] > 0) {
        [self.ErrorMessage appendString:@"\n"];
        [self.ErrorMessage appendString:messageError];
    } else{
        self.ErrorMessage = [NSMutableString stringWithString:messageError];
    }
}

- (NSString *)validateNonEmptyTextField:(UITextField *)textField withName:(NSString *)name{
    if ([textField.text length] == 0) {
        [self addMessageError:[NSMutableString stringWithFormat:@"%@ no puede estar vacio.", name]];
        return @"";
    }
    
    return textField.text;
}

- (void)validateValue:(int)selectedIndex forRelation:(NSString *)relation{
    if (selectedIndex == -1) {
        [self addMessageError:[NSMutableString stringWithFormat:@"Debe seleccionar un valor para %@.", relation]];
    }
}

-(NSString *)validateOnlyNumbers:(NSString*)inputString withName:(NSString *)name{
    NSCharacterSet *alphaNumbersSet = [NSCharacterSet decimalDigitCharacterSet];
    NSCharacterSet *stringSet = [NSCharacterSet characterSetWithCharactersInString:inputString];
    if([alphaNumbersSet isSupersetOfSet:stringSet]){
        return inputString;
    } else {
        [self addMessageError:[NSMutableString stringWithFormat:@"%@ solo acepta numeros.", name]];
         return @"";
    }
}

-(BOOL) validEmail:(NSString*) emailString {
    if (emailString) {
        NSString *regExPattern = @"^[A-Z0-9._%+-]+@[A-Z0-9.-]+\\.[A-Z]{2,4}$";
        NSRegularExpression *regEx = [[NSRegularExpression alloc] initWithPattern:regExPattern options:NSRegularExpressionCaseInsensitive error:nil];
        NSUInteger regExMatches = [regEx numberOfMatchesInString:emailString options:0 range:NSMakeRange(0, [emailString length])];
        if (regExMatches == 0) {
            [self addMessageError:[NSMutableString stringWithString:@"Email invalido"]];
            return NO;
        }
    }

    return YES;
}

-(NSString *)validateCUIT:(NSString*)cuit{
    cuit = [self validateOnlyNumbers:cuit withName:@"CUIT"];
    if ([cuit length] == 11) {
        NSArray *numbers = @[@5,@4,@3,@2,@7,@6,@5,@4,@3,@2];
        int total = 0;
        for (int i = 0; i < [numbers count]; i++) {
            int part = [[cuit substringWithRange:NSMakeRange(i, 1)] intValue] ;
            total += part * [numbers[i] integerValue];
        }
        
        int resto = total % 11;
        int validationNumber = resto == 0 ? 0 : resto == 1 ? 9 : 11 - resto;
        
        
        int digito = [[cuit substringWithRange:NSMakeRange(10, 1)] intValue];
        if(validationNumber == digito){
            return cuit;
        }
    }

    [self addMessageError:@"CUIT invalido"];
    return @"";
    
}

- (NSArray *)descriptions:(NSArray *)values{
    NSMutableArray *descriptions = [NSMutableArray new];
    for (id value in values) {
        [descriptions addObject:[value performSelector:@selector(descripcion)]];
    }
    
    return descriptions;
}

- (IBAction)deliveryAreaButtonAction:(id)sender {
    [self.textFieldList makeObjectsPerformSelector:@selector(resignFirstResponder)];
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:[self descriptions:[self.viewModel obtainDeliveryAreaList]] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)provinceButtonAction:(id)sender {
    [self.textFieldList makeObjectsPerformSelector:@selector(resignFirstResponder)];
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:[self descriptions:[self.viewModel obtainProvinces]] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)expressButonAction:(id)sender {
    [self.textFieldList makeObjectsPerformSelector:@selector(resignFirstResponder)];
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:[self descriptions:[self.viewModel obtainExpressList]] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)sellerButtonAction:(id)sender {
    [self.textFieldList makeObjectsPerformSelector:@selector(resignFirstResponder)];
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:[self descriptions:[self.viewModel obtainSellersList]] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)collectorButtonAction:(id)sender {
    [self.textFieldList makeObjectsPerformSelector:@selector(resignFirstResponder)];
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:[self descriptions:[self.viewModel obtainCollectorList]] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)salesLineButtonAction:(id)sender {
    [self.textFieldList makeObjectsPerformSelector:@selector(resignFirstResponder)];
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:[self descriptions:[self.viewModel obtainSalesLineList]] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)paymentConditionButtonAction:(id)sender {
    [self.textFieldList makeObjectsPerformSelector:@selector(resignFirstResponder)];
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:[self descriptions:[self.viewModel obtainPaymentConditionList]] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)taxesButtonAction:(id)sender {
    [self.textFieldList makeObjectsPerformSelector:@selector(resignFirstResponder)];
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:[self descriptions:[self.viewModel obtainTaxesList]] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)saveButtonAction:(id)sender
{
    
    NSMutableDictionary *clientDictionary = [NSMutableDictionary new];
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.clientNameTextField withName:@"Nombre"] forKey:@"name"];
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.clientAliasTextField withName:@"Nombre de fantasia"] forKey:@"alias"];
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.clientAddressTextField withName:@"Domicilio Fiscal"] forKey:@"address"];
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.clientZipCodeTextField withName:@"Codigo postal"] forKey:@"zipcode"];
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.clientLocalityTextField withName:@"Localidad"] forKey:@"locality"];
    if ([self validEmail:self.clientEmailTextField.text]) {
        [clientDictionary setNotEmptyString:self.clientEmailTextField.text forKey:@"email"];
    }
    
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.ownerNameTextField withName:@"Dueño"] forKey:@"owner"];
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.clientPhoneTextField withName:@"Telefono"] forKey:@"phone"];
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.clientWebTextField withName:@"Web"] forKey:@"web"];
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.purchaseManagerTextField withName:@"Enc. Compras"] forKey:@"purchaseManager"];
    
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.deliveryAddressTextField withName:@"Domicilio de entrega"] forKey:@"deliveryAddress"];
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.scheduleTextField withName:@"Horario"] forKey:@"schedule"];
    [clientDictionary setNotEmptyString:[self validateCUIT:self.CUITTextField.text] forKey:@"cuit"];
    [clientDictionary setNotEmptyString:[self validateNonEmptyTextField:self.collectionDaysTextField withName:@"Dias de pago"] forKey:@"collectionDays"];
    [clientDictionary setValue:[self.discount1TextField.text length] == 0 ? @"0" : self.discount1TextField.text forKey:@"discount1"];
    [clientDictionary setValue:[self.discount2TextField.text length] == 0 ? @"0" : self.discount2TextField.text forKey:@"discount2"];
    [clientDictionary setValue:[self.discount3TextField.text length] == 0 ? @"0" : self.discount3TextField.text forKey:@"discount3"];
    [clientDictionary setValue:[self.discount4TextField.text length] == 0 ? @"0" : self.discount4TextField.text forKey:@"discount4"];
    [clientDictionary setNotEmptyString:self.observationsTextField.text forKey:@"observations"];
    
    [self validateValue:self.viewModel.selectedPaymentConditionAtIndex forRelation:@"Condicion de pago"];
    [self validateValue:self.viewModel.selectedProvinceAtIndex forRelation:@"Provincia"];
    [self validateValue:self.viewModel.selectedDeliveryAreaAtIndex forRelation:@"Zona de envio"];
    [self validateValue:self.viewModel.selectedExpressAtIndex forRelation:@"Expreso"];
    [self validateValue:self.viewModel.selectedSalesLineAtIndex forRelation:@"Linea de ventas"];
    [self validateValue:self.viewModel.selectedTaxAtIndex forRelation:@"Tipo ivas"];
    
    if ([self.ErrorMessage length] == 0) {
        [self startLoading];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
            [self.viewModel saveClient:clientDictionary];
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self stopLoading];
                [self.delegate clientSaved];
            });
        });
        
        
    } else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Solucione los siguientes errores"
                                                        message:self.ErrorMessage
                                                       delegate:self
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
        [alert show];
    }
}

- (IBAction)cancelButtonAction:(id)sender {
    [self.delegate createClientCancelled];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    self.ErrorMessage = nil;
}

- (void)tablePopover:(EQTablePopover *)sender selectedRow:(int)rowNumber selectedData:(NSString *)selectedData{
    if (selectedData) {
        if ([self isButtonPopoverOwner:self.provinceButton]) {
            [self.viewModel setSelectedProvinceAtIndex:rowNumber];
        } else if ([self isButtonPopoverOwner:self.deliveryAreaButton]) {
            [self.viewModel setSelectedDeliveryAreaAtIndex:rowNumber];
        } else if ([self isButtonPopoverOwner:self.expressButton]) {
            [self.viewModel setSelectedExpressAtIndex:rowNumber];
        } else if ([self isButtonPopoverOwner:self.sellerButton]) {
            [self.viewModel setSelectedSellerAtIndex:rowNumber];
        } else if ([self isButtonPopoverOwner:self.collectorButton]) {
            [self.viewModel setSelectedCollectorAtIndex:rowNumber];
        } else if ([self isButtonPopoverOwner:self.salesLineButton]) {
            [self.viewModel setSelectedSalesLineAtIndex:rowNumber];
        } else if ([self isButtonPopoverOwner:self.paymentConditionButton]) {
            [self.viewModel setSelectedPaymentConditionAtIndex:rowNumber];
        } else if ([self isButtonPopoverOwner:self.taxesButton]) {
            [self.viewModel setSelectedTaxAtIndex:rowNumber];
        } else if ([self isButtonPopoverOwner:self.discountButton]) {
            [self.viewModel selectedDiscountAtIndex:rowNumber];
        }
        
        [self.popoverOwner setTitle:selectedData forState:UIControlStateNormal];
    }

    [self closePopover];
}

- (IBAction)addressChanged:(id)sender {
    if([self.clientAddressTextField.text length] > 0 && [self.clientLocalityTextField.text length] > 0) {
        self.deliveryAddressTextField.text = [self.clientAddressTextField.text stringByAppendingFormat:@" %@",self.clientLocalityTextField.text];
    }
}

- (IBAction)discountButtonAction:(id)sender {
    [self.textFieldList makeObjectsPerformSelector:@selector(resignFirstResponder)];
    
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:@[@"No",@"Si"] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

@end
