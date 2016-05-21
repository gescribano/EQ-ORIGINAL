//
//  Comunicacion+extra.h
//  EQ
//
//  Created by Sebastian Borda on 7/5/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Comunicacion.h"
#import "Cliente+extra.h"
#import "Usuario.h"

@interface Comunicacion (extra)

@property (nonatomic,strong) NSArray *clientes;
@property (nonatomic,strong) NSArray *receivers;
@property (nonatomic,strong) NSArray *senders;

- (Cliente *)cliente;
- (Usuario *)usuario;
- (Usuario *)sender;

@end
