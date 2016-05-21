//
//  EQProductsViewController.m
//  EQ
//
//  Created by Sebastian Borda on 4/20/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQProductsViewController.h"
#import "Articulo+extra.h"
#import "Articulo.h"
#import "Disponibilidad.h"
#import "EQDataManager.h"
#import "EQGroupCell.h"
#import "EQImagesManager.h"
#import "EQProductCell.h"
#import "EQSession.h"
#import "EQTablePopover.h"
#import "Grupo.h"
#import "Precio+extra.h"
#import "Precio.h"

@interface EQProductsViewController ()

@property (nonatomic,strong) EQProductsViewModel *viewModel;
@property (nonatomic,strong) EQTablePopover *popoverGroup1;
@property (nonatomic,strong) EQTablePopover *popoverGroup2;
@property (nonatomic,strong) EQTablePopover *popoverGroup3;
@end

@implementation EQProductsViewController

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(categorySelectedNotification:) name:@"startWithCategory" object:nil];
    }
    return self;
}

- (void)categorySelectedNotification:(NSNotification *)notification {
    Grupo *category = [notification.userInfo objectForKey:@"category"];
    self.viewModel = [[EQProductsViewModel alloc] initWithCategory:category];
    self.viewModel.delegate = self;
    [self.productsCollectionView reloadData];
}

- (void)viewDidLoad{
    if (self.viewModel == nil) {
        self.viewModel = [EQProductsViewModel new];
        self.viewModel.delegate = self;
    }
    
    UINib *nib = [UINib nibWithNibName:@"EQProductCell" bundle: nil];
    [self.productsCollectionView registerNib:nib forCellWithReuseIdentifier:@"ProductCell"];
    
    UINib *groupNib = [UINib nibWithNibName:@"EQGroupCell" bundle: nil];
    [self.productsCollectionView registerNib:groupNib forCellWithReuseIdentifier:@"GroupCell"];
    self.productDetailView.delegate = self;
    [super viewDidLoad];

}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self.viewModel loadData];
    [[EQDataManager sharedInstance] downloadAllProductImages];
}

- (void) viewWillAppear:(BOOL)animated
{
    //TESTPOL
    [super viewWillAppear:animated];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateProgress:) name:IMAGE_DOWNLOAD_PROGRESS object:nil];
}

- (void) updateProgress:(NSNotification*)notification
{
    self.productDownloadProgressBar.hidden = NO;
    self.productDownloadProgressBar.hidden = NO;
    NSDictionary* progressDictionary = [notification userInfo];
    float total = [[progressDictionary objectForKey:@"total"] floatValue];
    float progress = [[progressDictionary objectForKey:@"progress"] floatValue];
    [self.productDownloadProgressBar setProgress:(progress / total)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.productsCollectionView = nil;
    self.productDetailView = nil;
}

- (NSMutableArray *)obtainGroupNames:(NSArray *)group{
    NSMutableArray *names = [NSMutableArray new];
    for (Grupo *groupItem in group) {
        [names addObject:groupItem.nombre];
    }
    
    return names;
}

- (IBAction)groupOneAction:(id)sender {
    self.popoverGroup1 = [[EQTablePopover alloc] initWithData:[self obtainGroupNames:[self.viewModel category1List]] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:self.popoverGroup1];
}

- (IBAction)groupTwoAction:(id)sender {
    self.popoverGroup2 = [[EQTablePopover alloc] initWithData:[self obtainGroupNames:[self.viewModel category2List]] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:self.popoverGroup2];
}

- (IBAction)groupThreeAction:(id)sender {
    self.popoverGroup3 = [[EQTablePopover alloc] initWithData:[self obtainGroupNames:[self.viewModel category3List]] delegate:self];
    UIButton *button = (UIButton *)sender;
    [self presentPopoverInView:button withContent:self.popoverGroup3];
}

- (IBAction)reloadAction:(id)sender {
    [self.viewModel resetFilters];
    [self.groupOneButton setTitle:@"  Todas" forState:UIControlStateNormal];
    [self.groupTwoButton setTitle:@"  Todas" forState:UIControlStateNormal];
    [self.groupThreeButton setTitle:@"  Todas" forState:UIControlStateNormal];
    self.searchBar.text = @"";
}

- (IBAction)goToCatalogAction:(id)sender {
    [APP_DELEGATE selectTabAtIndex:EQTabIndexCatalogs];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    if (self.viewModel.typeList == typeListProduct) {
        return [self.viewModel.articles count];
    } else if (self.viewModel.typeList == typeListGroup) {
        return 1;
    }
    
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.typeList == typeListProduct) {
        EQProductCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductCell" forIndexPath:indexPath];
        Articulo *art = [self.viewModel.articles objectAtIndex:indexPath.item];
        [cell loadArticle:art];
        return cell;
    } else if (self.viewModel.typeList == typeListGroup) {
        EQGroupCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"GroupCell" forIndexPath:indexPath];
        [cell.groupImage loadURL:[self.viewModel imageForCategory2]];
        return cell;
    }
    
    return nil;
}

- (void)modelDidUpdateData{
    [self.productsCollectionView reloadData];
    [self.searchBar resignFirstResponder];
    [super modelDidUpdateData];
}

- (void)productDetailClose{
    if (!self.productDetailView.isHidden) {
        [UIView animateWithDuration:0.4 animations:^{
            self.productDetailView.hidden = YES;
        }];
    }
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.viewModel.typeList == typeListProduct) {
        [self.productDetailView loadArticle:[self.viewModel.articles objectAtIndex:indexPath.item] client:[EQSession sharedInstance].selectedClient];
        if (self.productDetailView.isHidden) {
            [UIView animateWithDuration:0.4 animations:^{
                self.productDetailView.hidden = NO;
            }];
        }
    }
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.viewModel.typeList == typeListProduct) {
        return CGSizeMake(183, 218);
    } else if (self.viewModel.typeList == typeListGroup) {
        return CGSizeMake(748, 766);
    }
    return CGSizeZero;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    if (self.viewModel.typeList == typeListProduct) {
        return UIEdgeInsetsMake(5, 3, 5, 3);
    }
    
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

#pragma mark - search bar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    [self.viewModel defineSearchTerm:searchText];
    [NSObject cancelPreviousPerformRequestsWithTarget:self.viewModel selector:@selector(loadData) object:nil];
    [self.viewModel performSelector:@selector(loadData) withObject:nil afterDelay:.8];
}

#pragma mark - Table Popover delegate

- (void)tablePopover:(EQTablePopover *)sender selectedRow:(int)rowNumber selectedData:(NSString *)selectedData{
    if (selectedData) {
        NSString *title = [NSString stringWithFormat:@"  %@",selectedData];
        if (sender == self.popoverGroup1) {
            [self.viewModel defineSelectedCategory1:rowNumber];
            [self.groupOneButton setTitle:title forState:UIControlStateNormal];
            [self.groupTwoButton setTitle:@"  Todas" forState:UIControlStateNormal];
            [self.groupThreeButton setTitle:@"  Todas" forState:UIControlStateNormal];
            [self.viewModel loadData];
        } else if (sender == self.popoverGroup2) {
            [self.viewModel defineSelectedCategory2:rowNumber];
            [self.groupTwoButton setTitle:title forState:UIControlStateNormal];
            [self.groupThreeButton setTitle:@"  Todas" forState:UIControlStateNormal];
            [self.viewModel loadData];
        } else if (sender == self.popoverGroup3) {
            [self.viewModel defineSelectedCategory3:rowNumber];
            [self.groupThreeButton setTitle:title forState:UIControlStateNormal];
            [self.viewModel loadData];
        }
    }
    [self closePopover];
    [super tablePopover:sender selectedRow:rowNumber selectedData:selectedData];
}

- (void)changeCategory1Selected:(NSString *)category {
    category = category ? category : @"Todas";
    [self.groupOneButton setTitle:[NSString stringWithFormat:@"  %@",category] forState:UIControlStateNormal];
}

- (void)changeCategory2Selected:(NSString *)category {
    category = category ? category : @"Todas";
    [self.groupTwoButton setTitle:[NSString stringWithFormat:@"  %@",category] forState:UIControlStateNormal];
}

- (void)changeCategory3Selected:(NSString *)category {
    category = category ? category : @"Todas";
    [self.groupThreeButton setTitle:[NSString stringWithFormat:@"  %@",category] forState:UIControlStateNormal];
}

@end
