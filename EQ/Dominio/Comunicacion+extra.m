//
//  Comunicacion+extra.m
//  EQ
//
//  Created by Sebastian Borda on 7/5/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Comunicacion+extra.h"
#import "EQDataAccessLayer.h"
#import "Usuario+extra.h"
#import "Cliente+extra.h"

@implementation Comunicacion (extra)

@dynamic clientes;
@dynamic receivers;
@dynamic senders;

- (Cliente *)cliente{
    return [self.clientes lastObject];
}

- (Usuario *)usuario{
    return [self.receivers lastObject];
}

- (Usuario *)sender{
    return [self.senders lastObject];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"Comunicacion receiverID:%@ senderID:%@ clienteID:%@",self.receiverID, self.senderID, self.clienteID];
}

- (NSArray *)clientes
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.senderID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Usuario class] filterByPredicate:predicate];
}

- (NSArray *)receivers
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.receiverID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Usuario class] filterByPredicate:predicate];
}

- (NSArray *)senders
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.clienteID];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[Cliente class] filterByPredicate:predicate];
}

@end
