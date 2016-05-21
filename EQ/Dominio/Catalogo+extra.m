//
//  Catalogo+extra.m
//  EQ
//
//  Created by Sebastian Borda on 10/25/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Catalogo+extra.h"
#import "EQDataAccesslayer.h"
#import "CatalogoImagen+CoreDataProperties.h"

@class CatalogoImagen;

@implementation Catalogo (extra)

@dynamic imagenes;

-(void)setPhotosList:(NSArray*)list{
    self.fotos = [NSKeyedArchiver archivedDataWithRootObject:list];
}

-(NSArray*)getPhotosList{
    return [NSKeyedUnarchiver unarchiveObjectWithData:self.fotos];
}

- (NSArray *)imagenes
{
    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"catalogoID == %@",self.identifier];
    NSSortDescriptor* sort = [NSSortDescriptor sortDescriptorWithKey:@"catalogoID" ascending:YES];
    return  [[EQDataAccessLayer sharedInstance] objectListForClass:[CatalogoImagen class] filterByPredicate:predicate sortBy:sort limit:0];
}

@end
