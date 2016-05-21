//
//  EQGoalsViewModel.m
//  EQ
//
//  Created by Sebastian Borda on 7/1/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQGoalsViewModel.h"

@implementation EQGoalsViewModel

- (id)init{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(activeClientChange:) name:ACTIVE_CLIENT_CHANGE_NOTIFICATION object:nil];
        if (self.ActiveClient) {
            self.clientName = self.ActiveClient.nombre;
        }
    }
    return self;
}

- (void)activeClientChange:(NSNotification *)notification{
    Cliente *activeCliente = notification.userInfo[@"activeClient"];
    self.clientName = activeCliente.nombre;
    if ([APP_DELEGATE tabBarController].selectedIndex == EQTabIndexGoals) {
        [self loadData];
    }
}

- (void)defineClient:(NSString *)client{
    if ([client isEqualToString:@"Todos"]) {
        self.clientName = nil;
    } else {
        self.clientName = client;
    }
    
    [self loadData];
}

@end
