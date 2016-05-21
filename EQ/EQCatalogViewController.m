//
//  EQCatalogViewController.m
//  EQ
//
//  Created by Sebastian Borda on 10/26/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQCatalogViewController.h"
#import "EQCatalogViewModel.h"
#import "EQProductCell+Catalogo.h"
#import "Catalogo.h"
#import "Grupo+extra.h"
#import "EQImagesManager.h"
#import "CatalogoImagen.h"

@interface EQCatalogViewController ()

@property (nonatomic,strong) EQCatalogViewModel *viewModel;
@property (nonatomic,strong) Catalogo *currentCatalog;
@property (nonatomic,strong) NSArray *categoriesList;

@end

@implementation EQCatalogViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.catalogDetailView.alpha = 0;
    [self.viewModel loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(displayProgress:)
                                                 name:CATALOG_DOWNLOAD_PROGRESS
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //TESTPOL
    [super viewWillDisappear:animated];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.viewModel = [EQCatalogViewModel new];
    self.viewModel.delegate = self;
    UINib *nib = [UINib nibWithNibName:@"EQProductCell" bundle: nil];
    [self.catalogsCollectionView registerNib:nib forCellWithReuseIdentifier:@"ProductCell"];
    [self.catalogScrollView setPagingEnabled:YES];
    
    
}

-(void) displayProgress:(NSNotification*)notification
{
    self.catalogDownloadProgressBar.hidden = NO;
    NSDictionary* progressDictionary = [notification userInfo];
    float total = [[progressDictionary objectForKey:@"total"] floatValue];
    float progress = [[progressDictionary objectForKey:@"progress"] floatValue];
    [self.catalogDownloadProgressBar setProgress:(progress / total)];
    [self.catalogsCollectionView reloadData];
}

#pragma mark - UICollectionView Datasource

- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section {
    return [self.viewModel.catalogs count];
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView {
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EQProductCell *cell = [cv dequeueReusableCellWithReuseIdentifier:@"ProductCell" forIndexPath:indexPath];
    Catalogo *catalog = [self.viewModel.catalogs objectAtIndex:indexPath.item];
    [cell loadCatalog:catalog];
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Catalogo *catalog = [self.viewModel.catalogs objectAtIndex:indexPath.item];
    [self loadCatalog:catalog];
}

#pragma mark – UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(183, 218);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(5, 3, 5, 3);
}

- (void)loadCatalog:(Catalogo *)catalog {
    self.currentCatalog = catalog;
    self.catalogTitleLabel.text = [NSString stringWithFormat:@"Catálogo de %@", catalog.titulo];
    int categoriesCount = (int)[catalog.categorias count];
    [[self.catalogScrollView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    CGRect scrollFrame = self.catalogScrollView.frame;
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"pagina" ascending:YES];
    NSArray *images = [catalog.imagenes sortedArrayUsingDescriptors:@[sortDescriptor]];
    self.catalogScrollView.contentSize = CGSizeMake(scrollFrame.size.width * [images count], scrollFrame.size.height);
    int page = 0;
    for (CatalogoImagen *catalogImage in images) {
        CGRect frame = CGRectMake(scrollFrame.size.width * page, 0, scrollFrame.size.width, scrollFrame.size.height);
        UIImage *image = [[EQImagesManager sharedInstance] imageNamed:catalogImage.nombre];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.image = image;
        [self.catalogScrollView addSubview:imageView];
        page++;
    }
    
    CGRect frame = self.catalogScrollView.frame;
    frame.origin = CGPointZero;
    [self.catalogScrollView scrollRectToVisible:frame animated:NO];
    
    
    self.categoriesList = [catalog.categorias allObjects];
    for (UIButton *button in self.categoryButtonsList) {
        if (categoriesCount > button.tag) {
            Grupo *grupo = [self.categoriesList objectAtIndex:button.tag];
            [button setTitle:[grupo.nombre uppercaseString] forState:UIControlStateNormal];
            button.hidden = NO;
        } else {
            button.hidden = YES;
        }
        
    }
    
    self.catalogDetailView.transform = CGAffineTransformMakeScale(0.9, 0.9);
    [UIView animateWithDuration:0.5 animations:^{
        self.catalogDetailView.alpha = 1;
        self.catalogDetailView.transform = CGAffineTransformIdentity;
    }];
}

- (void)modelDidUpdateData{
    [self.catalogsCollectionView reloadData];
    [super modelDidUpdateData];
}

- (IBAction)closeCatalogAction:(id)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.catalogDetailView.alpha = 0;
    } completion:^(BOOL finished) {
        self.currentCatalog= nil;
        self.categoriesList = nil;
        self.catalogScrollView.contentOffset = CGPointMake(0, 0);
    }];
}
- (IBAction)categoryOneButtonAction:(id)sender {
    NSDictionary *userInfo = @{@"category":[self.categoriesList objectAtIndex:0]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startWithCategory" object:nil userInfo:userInfo];
    [APP_DELEGATE selectTabAtIndex:EQTabIndexProducts];
    
}
- (IBAction)categoryTwoButtonAction:(id)sender {
    NSDictionary *userInfo = @{@"category":[self.categoriesList objectAtIndex:1]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startWithCategory" object:nil userInfo:userInfo];
    [APP_DELEGATE selectTabAtIndex:EQTabIndexProducts];
}

- (IBAction)categoryThreeButtonAction:(id)sender {
    NSDictionary *userInfo = @{@"category":[self.categoriesList objectAtIndex:2]};
    [[NSNotificationCenter defaultCenter] postNotificationName:@"startWithCategory" object:nil userInfo:userInfo];
    [APP_DELEGATE selectTabAtIndex:EQTabIndexProducts];
}

@end
