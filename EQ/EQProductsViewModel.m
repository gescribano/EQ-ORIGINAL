//
//  EQProductsViewModel.m
//  EQ
//
//  Created by Sebastian Borda on 4/25/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQProductsViewModel.h"
#import "Articulo.h"
#import "Grupo+extra.h"
#import "EQDataAccessLayer.h"

@interface EQProductsViewModel()

@property (nonatomic, assign) int category1SelectedIndex;
@property (nonatomic, assign) int category2SelectedIndex;
@property (nonatomic, assign) int category3SelectedIndex;
@property (nonatomic, strong) NSString* searchTerm;
@property (nonatomic, strong) NSMutableArray *initialCategories;

@end

@implementation EQProductsViewModel
@synthesize delegate;

- (id)initWithCategory:(Grupo *)category
{
    self = [super init];
    if (self) {
        self.initialCategories = [NSMutableArray new];
        [self loadCategoryFamily:category];
        [self.initialCategories addObject:category];
        self.searchTerm = nil;
        self.category1SelectedIndex = (int)NSNotFound;
        self.category2SelectedIndex = (int)NSNotFound;
        self.category3SelectedIndex = (int)NSNotFound;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeClientChange:) name:ACTIVE_CLIENT_CHANGE_NOTIFICATION object:nil];
    }
    return self;
}

- (void)loadCategoryFamily:(Grupo *) category {
    Grupo *parent = category.parent;
    if (parent) {
        [self loadCategoryFamily:parent];
        [self.initialCategories addObject:parent];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        self.searchTerm = nil;
        self.category1SelectedIndex = (int)NSNotFound;
        self.category2SelectedIndex = (int)NSNotFound;
        self.category3SelectedIndex = (int)NSNotFound;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeClientChange:) name:ACTIVE_CLIENT_CHANGE_NOTIFICATION object:nil];
    }
    return self;
}

- (void)activeClientChange:(NSNotification *)notification{
    if ([APP_DELEGATE tabBarController].selectedIndex == EQTabIndexProducts) {
        [self loadData];
    }
}

- (void)releaseUnusedMemory{
    [super releaseUnusedMemory];
    self.articles = nil;
}

- (void)loadDataInBackGround{
    EQDataAccessLayer *adl = [EQDataAccessLayer sharedInstance];
    NSMutableArray *subPredicates = [NSMutableArray array];
    if ([self.searchTerm length] > 0) {
        NSString *searchTerm = [self.searchTerm stringByAppendingString:@"*"];
        NSPredicate *searchPredicate = [NSPredicate predicateWithFormat:@"(SELF.nombre like[cd] %@ || SELF.descripcion like[cd] %@ || SELF.codigo like %@)",searchTerm ,[@"*" stringByAppendingString:searchTerm] ,searchTerm];
        [subPredicates addObject:searchPredicate];
    }
    
    NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"SELF.parentID == %i", 0];
    self.category1List = [adl objectListForClass:[Grupo class] filterByPredicate:categoryPredicate sortBy:[NSSortDescriptor sortDescriptorWithKey:@"nombre" ascending:YES] limit:0];
    if ([self.initialCategories count] >= 1) {
        Grupo *category = [self.initialCategories objectAtIndex:0];
        self.category1SelectedIndex = (int)[self.category1List indexOfObject:category];
        [self.delegate changeCategory1Selected:category.nombre];
        [self.delegate changeCategory2Selected:nil];
        [self.delegate changeCategory3Selected:nil];
    }
    
    if (self.category1SelectedIndex != (int)NSNotFound) {
        Grupo *grupo = [self.category1List objectAtIndex:self.category1SelectedIndex];
        self.category2List = [[NSArray arrayWithArray:grupo.subGrupos] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"nombre" ascending:YES]]];
        if ([self.initialCategories count] >= 2) {
            Grupo *category = [self.initialCategories objectAtIndex:1];
            [self.delegate changeCategory2Selected:category.nombre];
            [self.delegate changeCategory3Selected:nil];
            self.category2SelectedIndex = (int)[self.category2List indexOfObject:category];
            self.typeList = typeListGroup;
        }
    }
    
    if (self.category2SelectedIndex != (int)NSNotFound) {
        Grupo *grupo = [self.category2List objectAtIndex:self.category2SelectedIndex];
        self.category3List = [[NSArray arrayWithArray:grupo.subGrupos] sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"nombre" ascending:YES]]];
        if ([self.initialCategories count] >= 3) {
            Grupo *category = [self.initialCategories objectAtIndex:1];
            [self.delegate changeCategory3Selected:category.nombre];
            self.category3SelectedIndex = (int)[self.category3List indexOfObject:category];
            self.typeList = typeListProduct;
        }
    }
    
    if (([self.category3List count] == 0 && self.category2SelectedIndex != (int)NSNotFound) || self.category3SelectedIndex != (int)NSNotFound) {
        Grupo *grupo = [self.category3List count] > 0 ? [self.category3List objectAtIndex:self.category3SelectedIndex] : [self.category2List objectAtIndex:self.category2SelectedIndex];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.grupoID == %@ && SELF.estado = 'publish'",grupo.identifier];
        [subPredicates addObject:predicate];
    }

    NSPredicate *predicate = [subPredicates count] > 0 ? [NSCompoundPredicate andPredicateWithSubpredicates:subPredicates] : nil;
    self.articles = [adl objectListForClass:[Articulo class] filterByPredicate:predicate];
    self.initialCategories = nil;
    [super loadDataInBackGround];
}

- (NSString *)imageForCategory2{
    Grupo *grupo = nil;
    if (self.category2SelectedIndex != (int)NSNotFound) {
        grupo = [self.category2List objectAtIndex:self.category2SelectedIndex];
    }else{
        grupo = [self.category1List objectAtIndex:self.category1SelectedIndex];
    }
    
    return grupo.imagen;
}

- (void)defineSelectedCategory1:(int)categoryIndex{
    self.category1SelectedIndex = categoryIndex;
    self.category2SelectedIndex = (int)NSNotFound;
    self.category3SelectedIndex = (int)NSNotFound;
    self.typeList = typeListNone;
}

- (void)defineSelectedCategory2:(int)categoryIndex{
    self.category2SelectedIndex = categoryIndex;
    self.category3SelectedIndex = (int)NSNotFound;
    self.typeList = typeListGroup;
}

- (void)defineSelectedCategory3:(int)categoryIndex{
    self.category3SelectedIndex = categoryIndex;
    self.typeList = typeListProduct;
}

- (void)defineSearchTerm:(NSString *)term{
    self.searchTerm = term;
}

- (void)resetFilters{
    self.searchTerm = nil;
    self.category1SelectedIndex = (int)NSNotFound;
    self.category2SelectedIndex = (int)NSNotFound;
    self.category3SelectedIndex = (int)NSNotFound;
    self.category1List = nil;
    self.category2List = nil;
    self.category3List = nil;
    self.typeList = typeListNone;
    [self loadData];
}

@end
