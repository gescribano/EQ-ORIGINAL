//
//  Grupo+extra.m
//  EQ
//
//  Created by Sebastian Borda on 6/28/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Grupo+extra.h"
#import "Articulo+extra.h"
#import "EQDataAccessLayer.h"
#import "Grupo+extra.h"

@implementation Grupo (extra)

@dynamic articulos;
@dynamic parents;
@dynamic subGrupos;

- (Grupo *)parent{
    return [self.parents lastObject];
}

+ (void)resetRelevancia{
    //fetch new prices
    NSArray *newObjects = [[EQDataAccessLayer sharedInstance] objectListForClass:[Grupo class]];
    [newObjects setValue:@0 forKey:@"relevancia"];
    
    [[EQDataAccessLayer sharedInstance] saveContext];
}

- (NSString *)description{
    return [NSString stringWithFormat:@"Group id:%@ name:%@ parent:%@",self.identifier,self.nombre,self.parentID];
}

- (NSArray *)articulos
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"grupoID == %@ && (estado == 'publish' || estado == 'private')",self.identifier];
    NSArray* articles = [[EQDataAccessLayer sharedInstance] objectListForClass:[Articulo class] filterByPredicate:predicate];
    return articles;
}

- (NSArray *)parents
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"identifier == %@",self.parentID];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Grupo class] filterByPredicate:predicate];
}

- (NSArray *)subGrupos
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"parentID == %@",self.identifier];
    return [[EQDataAccessLayer sharedInstance] objectListForClass:[Grupo class] filterByPredicate:predicate];
}

@end
