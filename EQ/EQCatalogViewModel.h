//
//  EQCatalogViewModel.h
//  EQ
//
//  Created by Sebastian Borda on 10/26/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewModel.h"

@interface EQCatalogViewModel : EQBaseViewModel

@property (nonatomic, strong) NSArray *catalogs;
@property (nonatomic,assign) id<EQBaseViewModelDelegate> delegate;

@end
