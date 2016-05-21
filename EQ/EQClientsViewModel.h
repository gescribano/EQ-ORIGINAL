//
//  EQClientsViewModel.h
//  EQ
//
//  Created by Sebastian Borda on 4/29/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewModel.h"
#import "Cliente+extra.h"

@interface EQClientsViewModel : EQBaseViewModel

@property (nonatomic,strong) NSArray *clients;
@property (nonatomic,strong) NSArray *sortFields;
@property (nonatomic,weak) id<EQBaseViewModelDelegate> delegate;

- (void)changeSortOrder:(int)index;
- (void)defineSearchTerm:(NSString *)term;

//- (Cliente *)clientById:(NSString *)clientId;

@end
