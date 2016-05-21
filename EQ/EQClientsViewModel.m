//
//  EQClientsViewModel.m
//  EQ
//
//  Created by Sebastian Borda on 4/29/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQClientsViewModel.h"
#import "EQSession.h"
#import "Usuario.h"
#import "NSString+Number.h"

@interface EQClientsViewModel()

@property (nonatomic, strong) NSString* searchTerm;
@property (nonatomic, strong) NSSortDescriptor *sortDescriptor;

@end

@implementation EQClientsViewModel

- (id)init
{
    self = [super init];
    if (self) {
        self.sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[self clientFieldByIndex:0] ascending:YES selector:@selector(caseInsensitiveCompare:)];
        self.sortFields = [NSArray arrayWithObjects:@"Razon Social", @"Domicilio", @"Localidad", nil];
    }
    return self;
}

- (NSString *)clientFieldByIndex:(int)index{
    switch (index) {
        case 0:
            return @"nombre";
            break;
        case 1:
            return @"domicilio";
            break;
        case 2:
            return @"localidad";
            break;
        default:
            return @"nombre";
            break;
    }
}

- (void)releaseUnusedMemory{
    [super releaseUnusedMemory];
    self.clients = nil;
}

- (void)loadDataInBackGround{
    NSArray *results = [NSArray arrayWithArray:[EQSession sharedInstance].user.vendedor.clientesVendedor];
    NSPredicate *predicate = nil;
    if ([self.searchTerm length] > 0) {
        
        NSString *searchTerm = [self.searchTerm stringByAppendingString:@"*"];
        searchTerm = [@"*" stringByAppendingString:searchTerm];
        predicate = [NSPredicate predicateWithFormat:@"SELF.nombre like[cd] %@ || SELF.nombreDeFantasia like[cd] %@ || SELF.propietario like[cd] %@ || SELF.domicilio like[cd] %@ || SELF.localidad like[cd] %@",searchTerm , searchTerm, searchTerm, searchTerm, searchTerm];
    }
    
    if (predicate) {
        results = [results filteredArrayUsingPredicate:predicate];
    }
    
    self.clients = [results sortedArrayUsingDescriptors:[NSArray arrayWithObject:self.sortDescriptor]];
    [super loadDataInBackGround];
}

- (void)changeSortOrder:(int)index{
    [self.delegate modelWillStartDataLoading];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:[self clientFieldByIndex:index] ascending:YES];
        self.clients = [self.clients sortedArrayUsingDescriptors:[NSArray arrayWithObject:self.sortDescriptor]];
        [self.delegate modelDidUpdateData];
    });
}

- (void)defineSearchTerm:(NSString *)term{
    self.searchTerm = term;
}

//- (Cliente *)clientById:(NSString*)clientId{
//    for (Cliente *cliente in self.clients) {
//        if ([cliente.identifier isEqualToString:clientId]) {
//            return cliente;
//        }
//    }
//    return nil;
//}

@end
