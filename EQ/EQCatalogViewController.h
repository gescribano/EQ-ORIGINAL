//
//  EQCatalogViewController.h
//  EQ
//
//  Created by Sebastian Borda on 10/26/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewController.h"

@interface EQCatalogViewController : EQBaseViewController <UICollectionViewDelegate, UICollectionViewDataSource, UIScrollViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *catalogsCollectionView;
@property (strong, nonatomic) IBOutlet UILabel *catalogTitleLabel;
@property (strong, nonatomic) IBOutlet UIView *catalogDetailView;
@property (strong, nonatomic) IBOutlet UIScrollView *catalogScrollView;
@property (strong, nonatomic) IBOutlet UIButton *categoryOneButton;
@property (strong, nonatomic) IBOutlet UIButton *categoryTwoButton;
@property (strong, nonatomic) IBOutlet UIButton *categoryThreeButton;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *categoryButtonsList;

@property (weak, nonatomic) IBOutlet UIProgressView *catalogDownloadProgressBar;

- (IBAction)closeCatalogAction:(id)sender;
- (IBAction)categoryOneButtonAction:(id)sender;
- (IBAction)categoryTwoButtonAction:(id)sender;
- (IBAction)categoryThreeButtonAction:(id)sender;

@end
