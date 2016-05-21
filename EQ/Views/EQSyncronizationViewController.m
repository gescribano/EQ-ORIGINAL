//
//  EQSyncronizationViewController.m
//  EQ
//
//  Created by Jonathan on 8/10/15.
//  Copyright (c) 2015 Sebastian Borda. All rights reserved.
//

#import "EQSyncronizationViewController.h"
#import "EQClientsViewModel.h"
#import "EQDataManager.h"
#import "EQSyncronizationTableViewCell.h"
#import "EQSession.h"
#import "EQDataManager.h"
#import "UIColor+EQ.h"
#import "EQImagesManager.h"

@interface EQSyncronizationViewController() <EQSyncDelegate>

@property (nonatomic,strong) EQClientsViewModel *viewModel;
@property (nonatomic, strong) NSArray* tableData;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSString* imageDownloadProgressMessage;
@property (nonatomic, strong) NSString* catalogDownloadProgressMessage;

@end

@implementation EQSyncronizationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dataUpdated:) name:DATA_UPDATED_NOTIFICATION object:nil];
    
    self.viewModel = [EQClientsViewModel new];
    self.viewModel.delegate = self;
    [self.viewModel loadData];
    
    UINib *nib = [UINib nibWithNibName:@"EQSyncronizationTableViewCell" bundle: nil];
    [self.tableView registerNib:nib forCellReuseIdentifier:@"EQSyncronizationTableViewCell"];
    
    [self loadTopBarInfo];
    
    // Do any additional setup after loading the view.
}


- (void) updateProgress:(NSNotification*) notification
{
    int total = [[notification.userInfo objectForKey:@"total"] intValue];
    int progress = [[notification.userInfo objectForKey:@"progress"] intValue];
    NSString* message;
    if (total == progress)
        message = nil;
    else
        message = [NSString stringWithFormat:@"Descargando %i de %i.",progress,total];
    if ([notification.name isEqualToString:IMAGE_DOWNLOAD_PROGRESS])
    {
        self.imageDownloadProgressMessage = message;
    }
    else if ([notification.name isEqualToString:CATALOG_DOWNLOAD_PROGRESS])
    {
        self.catalogDownloadProgressMessage = message;
    }
    [self.tableView reloadData];
}

- (NSString *)imageDownloadProgressMessage
{
    if (!_imageDownloadProgressMessage)
    {
        NSArray* imagesToDownload = [[EQDataManager sharedInstance] getProductsThatNeedToBeDownload];
        _imageDownloadProgressMessage = [NSString stringWithFormat:@"%lu pendientes.",(unsigned long)imagesToDownload.count];
    }
    return _imageDownloadProgressMessage;
}

- (NSString *)catalogDownloadProgressMessage
{
    if (!_catalogDownloadProgressMessage)
    {
        NSArray* imagesToDownload = [[EQDataManager sharedInstance] getCatalogsImagesThatNeedToBeDownload];
        _catalogDownloadProgressMessage = [NSString stringWithFormat:@"%lu pendientes.",(unsigned long)imagesToDownload.count];
    }
    return _catalogDownloadProgressMessage;
}


- (NSArray *)tableData
{
    NSString* pendingOrdersCount =[NSString stringWithFormat:@"%i",[[EQDataManager sharedInstance] getPendingOrders]];
    return @[
             @{
                 @"title":@"Ventana de actualización minínima",
                 @"message":self.viewModel.ventanaSincronizacion
                 },
             @{
                 @"title":@"Pedidos sin sincronizar:",
                 @"message":pendingOrdersCount
                 },
             @{
                 @"title":@"Fecha inicial de importación de pedidos:",
                 @"message":self.viewModel.initialDateImportWithFormat
                 },
             @{
                 @"title":@"Fecha de la última sincronización incremental de datos:",
                 @"message":self.viewModel.lastUpdateWithFormat
                 },
             @{
                 @"title":@"Fecha de la última sincronización de catálogos:",
                 @"message":self.viewModel.lastUpdateCatalogWithFormat
                 },
             @{
                 @"title":@"Descarga de imágenes de catalogos:",
                 @"message":self.catalogDownloadProgressMessage
                 },
             @{
                 @"title":@"Descarga de imágenes de productos:",
                 @"message":self.imageDownloadProgressMessage
                 }
             ];
}

-(void) dataUpdated:(NSNotification *)notification
{
    [super dataUpdated:notification];
    [self reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:IMAGE_DOWNLOAD_PROGRESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:CATALOG_DOWNLOAD_PROGRESS object:nil];
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void) reloadData
{
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.tableData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EQSyncronizationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"EQSyncronizationTableViewCell"];
    NSDictionary* option = [self.tableData objectAtIndex:indexPath.row];
    cell.title.text = [option objectForKey:@"title"];
    cell.message.text = [option objectForKey:@"message"];
    cell.delegate = self;
    cell.contentView.backgroundColor = indexPath.row % 2 == 0 ? [UIColor whiteColor] : [UIColor grayForCell];
    if (indexPath.row == 1)
    {
        cell.syncSelected = EQSyncIncremental;
    }
    else if (indexPath.row == 3)
    {
        cell.syncSelected = EQSyncIncremental;
    }
    else if (indexPath.row == 4)
    {
        cell.syncSelected = EQSyncCatalogs;
    }
    else if (indexPath.row == 5)
    {
        cell.syncSelected = EQSyncCatalogImages;
    }
    else if (indexPath.row == 6)
    {
        cell.syncSelected = EQSyncProductsImages;
    }
    return cell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

- (void) syncCatalog
{
//    [APP_DELEGATE showLoadingViewWithMessage:@"Preparando descarga de imagenes.."];
    [[EQDataManager sharedInstance] updateCatalogSuccess:^
     {
         [self reloadData];
     }
                                                 failure:^(NSError *error)
     {
         [self reloadData];
     }];
}

- (void) syncIncremental
{
    [[EQSession sharedInstance] forceSynchronization];
}

- (void) syncProductImages
{
    [APP_DELEGATE showLoadingViewWithMessage:@"Preparando descarga de imagenes.."];
    self.imageDownloadProgressMessage = @"Preparando Descarga";
    [self.tableView reloadData];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[EQDataManager sharedInstance] downloadAllProductImages];
        self.imageDownloadProgressMessage = nil;
        [self.tableView reloadData];
        [APP_DELEGATE hideLoadingView];
    });
    
}

- (void) syncCatalogImages
{
    [APP_DELEGATE showLoadingViewWithMessage:@"Preparando descarga de imagenes.."];
    self.catalogDownloadProgressMessage = @"Preparando Descarga";
    [self.tableView reloadData];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [[EQDataManager sharedInstance] downloadAllCatalogImages];
        self.catalogDownloadProgressMessage = nil;
        [self.tableView reloadData];
        [APP_DELEGATE hideLoadingView];
    });
    
}

#pragma mark - Sync Cell Delegate
- (void)syncButtonPressedWithSender:(EQSyncronizationTableViewCell *)sender
{
    switch (sender.syncSelected) {
        case EQSyncCatalogs:
            [self syncCatalog];
            break;
        case EQSyncIncremental:
            [self syncIncremental];
            break;
        case EQSyncCatalogImages:
            [self syncCatalogImages];
            break;
        case EQSyncProductsImages:
            [self syncProductImages];
    }
}

@end
