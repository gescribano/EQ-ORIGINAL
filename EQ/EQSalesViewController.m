//
//  EQSalesViewController.m
//  EQ
//
//  Created by Sebastian Borda on 4/20/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQSalesViewController.h"
#import "EQSalesViewModel.h"
#import "EQSalesCell.h"
#import "Venta.h"
#import "Articulo.h"
#import "EQSalesFooter.h"
#import "Venta+extra.h"
#import "NSNumber+EQ.h"
#import "UIColor+EQ.h"
#import "EQDataAccessLayer.h"

#define cellIdentifier @"SalesCell"

@interface EQSalesViewController ()

@property (nonatomic, strong) EQSalesViewModel *viewModel;
@property (nonatomic, assign) BOOL hideDetails;

@end

@implementation EQSalesViewController

- (void)viewDidLoad{
    self.viewModel = [EQSalesViewModel new];
    self.viewModel.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"EQSalesCell" bundle: nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:cellIdentifier];
    self.popoverOwner = self.periodFilterButton;
    [self dateFilter:nil didSelectStartDate:[self modifyMonths:-2] endDate:[self modifyMonths:1]];
    [super viewDidLoad];
}

- (NSDate *)modifyMonths:(int)monthDifference{
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDateComponents *components = [gregorian components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:[NSDate date]];
    [components setDay:1];
    BOOL nextYear = [components month] + monthDifference > 12;
    BOOL previousYear = [components month] + monthDifference < 1;
    
    int yearDifference = 0;
    int mDifference = [components month] + monthDifference;
    if (nextYear || previousYear) {
        yearDifference = nextYear ? 1 : -1;
        mDifference = nextYear ? [components month] + monthDifference - 12 : [components month] + monthDifference + 12;
    }
    [components setMonth:mDifference];
    [components setYear:components.year + yearDifference];
    NSDate* newDate = [gregorian dateFromComponents:components];
    return newDate;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.viewModel initializeData];
    if (self.viewModel.clientName) {
        [self.clientFilterButton setTitle:self.viewModel.clientName forState:UIControlStateNormal];
    }
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.viewModel loadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.tableView = nil;
}

- (IBAction)periodFilterButtonAction:(id)sender {
    EQCustomDateFilterPopover *dateFilter = [[EQCustomDateFilterPopover alloc] initWithStartDate:self.viewModel.periodStart endDate:self.viewModel.periodEnd delegate:self];
    [self presentPopoverInView:sender withContent:dateFilter];
}

- (IBAction)clientFilterButtonAction:(id)sender {
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:[self.viewModel clients] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)groupFilterButtonAction:(id)sender {
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:[self.viewModel groupsName] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)modeButtonAction:(id)sender {
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:[self.viewModel totals] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

- (IBAction)sortButtonAction:(id)sender {
    EQTablePopover *popover = [[EQTablePopover alloc] initWithData:self.viewModel.sortFields delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:popover];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (self.viewModel.onlySubTotalAvailable && self.hideDetails) {
        return 1;
    }
    
    return [[self.viewModel salesList] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (self.viewModel.onlySubTotalAvailable && self.hideDetails) {
        return [self.viewModel.salesList count];
    }
    
    return [[self.viewModel.salesList objectAtIndex:section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    EQSalesCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    if (self.viewModel.onlySubTotalAvailable && self.hideDetails) {
        NSArray *sales = [self.viewModel.salesList objectAtIndex:indexPath.row];
        float gross = 0;
        int quantity = 0;
        for (Venta *sale in sales) {
            gross += [sale.importe floatValue];
            quantity += [sale.cantidad integerValue];
        }
        Venta *sale = [sales lastObject];
        if ([self.viewModel isSortingByClient]) {
            cell.clientLabel.text = sale.cliente.nombre ? sale.cliente.nombre : sale.clienteID;
            cell.periodLabel.text = @"";
            cell.articleLabel.text = @"";
        } else if ([self.viewModel isSortingByPeriod]){
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"yyyy.MM"];
            cell.clientLabel.text = @"";
            cell.articleLabel.text = @"";
            cell.periodLabel.text = [dateFormatter stringFromDate:sale.fecha];
        } else if ([self.viewModel isSortingByGroup]) {
            cell.clientLabel.text = @"";
            cell.periodLabel.text = @"";
            cell.articleLabel.text = sale.articulo.nombre;
        }
        cell.priceLabel.text = [NSString stringWithFormat:@"%@", [[NSNumber numberWithFloat:gross] currencyString]];
        cell.quantityLabel.text = [NSString stringWithFormat:@"%i", quantity];
    } else {
        Venta *sale = [[self.viewModel.salesList objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
        cell.clientLabel.text = sale.cliente.nombre ? sale.cliente.nombre : sale.clienteID;        
        cell.articleLabel.text = sale.articulo.nombre;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM"];
        cell.periodLabel.text = [dateFormatter stringFromDate:sale.fecha];
        cell.quantityLabel.text = [NSString stringWithFormat:@"%li",(long)[sale.cantidad integerValue]];
        cell.priceLabel.text = [NSString stringWithFormat:@"%@", sale.importe ? [sale.importe currencyString] : @"$0.00"];
    }
    
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor grayForCell] : [UIColor whiteColor];
    return cell;
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if ((self.viewModel.onlySubTotalAvailable && self.hideDetails) || !([self.viewModel isSortingByClient] || [self.viewModel isSortingByPeriod] || [self.viewModel isSortingByGroup])) {
        return 0;
    }
    
    return 50;
}

- (void)tablePopover:(EQTablePopover *)sender selectedRow:(int)rowNumber selectedData:(NSString *)selectedData{
    if ([self.popoverOwner isEqual:self.sortButton]) {
        [self.viewModel changeSortOrder:rowNumber];
    } else if ([self.popoverOwner isEqual:self.clientFilterButton]) {
        [self.viewModel filterByClient:selectedData];
    } else if ([self.popoverOwner isEqual:self.groupFilterButton]) {
        [self.viewModel filterByGroup:selectedData];
    } else if ([self.popoverOwner isEqual:self.modeButton]) {
        self.hideDetails = [selectedData isEqualToString:@"Subtotal"];
        [self.tableView reloadData];
    }
    
    NSString *buttonText = [NSString stringWithFormat:@"  %@", selectedData];
    [self.popoverOwner setTitle:buttonText forState:UIControlStateNormal];
    [self closePopover];
    [super tablePopover:sender selectedRow:rowNumber selectedData:selectedData];
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    if ((self.viewModel.onlySubTotalAvailable && self.hideDetails) || !([self.viewModel isSortingByClient] || [self.viewModel isSortingByPeriod] || [self.viewModel isSortingByGroup])) {
        return nil;
    }
    
    NSArray *sales = [self.viewModel.salesList objectAtIndex:section];
    NSArray *nibObjects = [[NSBundle mainBundle] loadNibNamed:@"EQSalesFooter" owner:nil options:nil];
    EQSalesFooter *footer = (EQSalesFooter *)[nibObjects objectAtIndex:0];
    Venta *sale = [sales lastObject];
    if ([self.viewModel isSortingByClient]) {
        footer.groupedFieldLabel.text = sale.cliente.nombre;
    } else {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM"];
        footer.groupedFieldLabel.text = [dateFormatter stringFromDate:sale.fecha];
    }
    
    float gross = 0;
    int quantity = 0;
    for (Venta *sale in sales) {
        gross += [sale.importe floatValue];
        quantity += [sale.cantidad integerValue];
    }
    footer.priceLabel.text = [NSString stringWithFormat:@"%@",[[NSNumber numberWithFloat:gross] currencyString]];
    footer.quantityLabel.text = [NSString stringWithFormat:@"%i",quantity];
    
    return footer;
}


-(void)modelDidUpdateData{
    [super modelDidUpdateData];
    [self.tableView reloadData];
    self.modeButton.enabled = self.viewModel.onlySubTotalAvailable;
    self.articlesLabel.text = [NSString stringWithFormat:@"%i",self.viewModel.articlesQuantity];
    self.totalLabel.text =  [NSString stringWithFormat:@"%@", [[NSNumber numberWithFloat:self.viewModel.articlesPrice] currencyString]];
    NSString *clientName = @"  Todos";
    if (self.viewModel.clientName) {
        clientName = [@"  " stringByAppendingString:self.viewModel.clientName];
    }
    
    [self.clientFilterButton setTitle:clientName forState:UIControlStateNormal];
}

- (void)dateFilter:(EQDateFilterPopover *)sender didSelectStartDate:(NSDate *)startDate endDate:(NSDate *)endDate{
    if ([self.popoverOwner isEqual:self.periodFilterButton]) {
        self.viewModel.periodStart = startDate;
        self.viewModel.periodEnd = endDate;
    }
    
    if (startDate == nil && endDate == nil) {
        [self.popoverOwner setTitle:@"  Todas" forState:UIControlStateNormal];
    } else {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"MM.yyyy"];
        NSString *title = [NSString stringWithFormat:@" %@ a %@",[dateFormat stringFromDate:startDate],[dateFormat stringFromDate:endDate]];
        [self.popoverOwner setTitle:title forState:UIControlStateNormal];
    }
    
    if (sender) {
        [self closePopover];
        [self.viewModel loadData];
    }
}

@end
