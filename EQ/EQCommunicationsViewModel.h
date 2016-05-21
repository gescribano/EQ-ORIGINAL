//
//  EQCommunicationsViewModel.h
//  EQ
//
//  Created by Sebastian Borda on 7/1/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQBaseViewModel.h"
#import "Comunicacion+extra.h"
#import "OrderedDictionary.h"

@interface EQCommunicationsViewModel : EQBaseViewModel

@property (nonatomic, weak) id<EQBaseViewModelDelegate> delegate;
@property (nonatomic, strong) OrderedDictionary *communications;
@property (nonatomic, strong) NSString *communicationType;
@property (nonatomic, strong) Comunicacion *selectedCommunication;
@property (nonatomic, strong) NSString *notificationsTitle;
@property (nonatomic, strong) NSString *clientName;
@property (nonatomic, strong) NSMutableArray *clientsList;

- (void)defineSearchTerm:(NSString *)term;
- (void)finalizeThread;
- (void)didReadCommunication;
- (void)sendResponseWithMessage:(NSString *)message;
@end
