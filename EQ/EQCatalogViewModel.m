//
//  EQCatalogViewModel.m
//  EQ
//
//  Created by Sebastian Borda on 10/26/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQCatalogViewModel.h"
#import "EQDataAccessLayer.h"
#import "Catalogo+extra.h"

@implementation EQCatalogViewModel

- (void)loadDataInBackGround{
    EQDataAccessLayer *adl = [EQDataAccessLayer sharedInstance];
    self.catalogs = [adl objectListForClass:[Catalogo class] filterByPredicate:nil sortBy:[NSSortDescriptor sortDescriptorWithKey:@"posicion" ascending:YES] limit:0];
    [super loadDataInBackGround];
}

@end
