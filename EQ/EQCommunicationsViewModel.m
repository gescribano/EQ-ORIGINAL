//
//  EQCommunicationsViewModel.m
//  EQ
//
//  Created by Sebastian Borda on 7/1/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQCommunicationsViewModel.h"
#import "EQDataAccessLayer.h"
#import "EQSession.h"
#import "Usuario+extra.h"
#import "EQDataManager.h"

@interface EQCommunicationsViewModel()

@property (nonatomic, strong) NSString *searchTerm;

@end

@implementation EQCommunicationsViewModel

- (void)releaseUnusedMemory{
    [super releaseUnusedMemory];
    self.clientsList = nil;
    self.communications = nil;
}

-(void)loadDataInBackGround
{

    
    NSArray *result = [NSArray arrayWithArray:[EQSession sharedInstance].user.comunicaciones];
    result = [result filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"SELF.tipo == %@", self.communicationType]];
    result = [result sortedArrayUsingDescriptors:@[[NSSortDescriptor sortDescriptorWithKey:@"creado" ascending:NO]]];
    
    NSMutableArray *subPredicates = [NSMutableArray array];
    if ([self.searchTerm length] > 0)
    {
        [subPredicates addObject:[NSPredicate predicateWithFormat:@"SELF.titulo beginswith[cd] %@ || SELF.descripcion beginswith[cd] %@ || SELF.descripcion CONTAINS[cd] %@ || SELF.titulo CONTAINS[cd] %@",self.searchTerm,self.searchTerm,self.searchTerm,self.searchTerm]];
    }
    
    if ([self.clientName length] > 0)
    {
        [subPredicates addObject:[NSPredicate predicateWithFormat:@"SELF.cliente.nombre == %@",self.clientName]];
    }
    
    if ([subPredicates count] > 0)
    {
        result = [result filteredArrayUsingPredicate:[NSCompoundPredicate andPredicateWithSubpredicates:subPredicates]];
    }
    
    self.clientsList = [NSMutableArray arrayWithObject:@"Todos"];
    for (Comunicacion *communication in result)
    {
        if ([communication.cliente.nombre length] > 0 && ![self.clientsList containsObject:communication.cliente.nombre])
        {
            [self.clientsList addObject: communication.cliente.nombre];
        }
    }
    
    int count = 0;
    OrderedDictionary *threads = [[OrderedDictionary alloc] init];
    for (Comunicacion *comm in result)
    {
        if (comm.leido == nil)
        {
            count++;
        }
        NSMutableArray *commucations = threads[comm.threadID];
        if (commucations)
        {
            [commucations addObject:comm];
        }
        else
        {
            commucations = [NSMutableArray arrayWithObject:comm];
            [threads setObject:commucations forKey:comm.threadID];
        }
    }
    
    self.communications = threads;
    
    if ([self.communicationType isEqualToString:COMMUNICATION_TYPE_OPERATIVE])
    {
        self.notificationsTitle = [NSString stringWithFormat:@"Operativas (%i)",count];
    }
    else if ([self.communicationType isEqualToString:COMMUNICATION_TYPE_COMMERCIAL])
    {
        self.notificationsTitle = [NSString stringWithFormat:@"Oportunidades (%i)",count];
    }
    else if ([self.communicationType isEqualToString:COMMUNICATION_TYPE_GOAL])
    {
        self.notificationsTitle = [NSString stringWithFormat:@"Objetivos (%i)",count];
    }
    
    [super loadDataInBackGround];
}

- (void)defineSearchTerm:(NSString *)term{
    self.searchTerm = term;
}

- (void)finalizeThread{
    NSArray *communications = [self.communications objectForKey:self.selectedCommunication.threadID];
    for (Comunicacion *communication in communications)
    {
        if ([communication.activo boolValue])
        {
            communication.activo = @0;
            [[EQDataAccessLayer sharedInstance] saveContext];
            [[EQDataManager sharedInstance] sendCommunication:communication];
        }
    }
}

- (void)didReadCommunication{
    if (self.selectedCommunication.leido == nil)
    {
        self.selectedCommunication.leido = [NSDate date];
        [[EQDataAccessLayer sharedInstance] saveContext];
        [[EQDataManager sharedInstance] sendCommunication:self.selectedCommunication];
    }
}

- (void)sendResponseWithMessage:(NSString *)message
{
    Comunicacion *communication = (Comunicacion *)[[EQDataAccessLayer sharedInstance] createManagedObject:@"Comunicacion"];
    communication.titulo = self.selectedCommunication.titulo;
    communication.descripcion = message;
    communication.threadID = self.selectedCommunication.threadID;
    communication.tipo = self.selectedCommunication.tipo;
    communication.senderID = [EQSession sharedInstance].user.identifier;
    communication.receiverID = [communication.senderID isEqualToString:self.selectedCommunication.senderID] ? self.selectedCommunication.receiverID : self.selectedCommunication.senderID;
    communication.activo = [NSNumber numberWithBool:YES];
    communication.actualizado = [NSNumber numberWithBool:NO];
    communication.creado = [NSDate date];
    communication.leido = nil;
    communication.codigoSerial = self.selectedCommunication.codigoSerial;
    [[EQDataAccessLayer sharedInstance] saveContext];
    
    NSMutableArray *communications = self.communications[communication.threadID];
    [communications insertObject:communication atIndex:0];
    
    [[EQDataManager sharedInstance] sendCommunication:communication];
}

@end
