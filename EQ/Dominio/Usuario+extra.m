//
//  Usuario+extra.m
//  EQ
//
//  Created by Sebastian Borda on 7/7/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Usuario+extra.h"
#import "EQDataAccessLayer.h"
#import "Comunicacion+extra.h"

@implementation Usuario (extra)

- (NSArray*) comunicaciones
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"receiverID == %@ OR senderID == %@",self.identifier,self.identifier];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Comunicacion class] filterByPredicate:predicate];
}

@end
