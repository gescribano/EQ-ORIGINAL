//
//  CatalogoImagen+CoreDataProperties.h
//  EQ
//
//  Created by Jonathan on 9/20/15.
//  Copyright © 2015 Sebastian Borda. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "CatalogoImagen.h"

NS_ASSUME_NONNULL_BEGIN

@interface CatalogoImagen (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *catalogoID;
@property (nullable, nonatomic, retain) NSString *nombre;
@property (nullable, nonatomic, retain) NSNumber *pagina;
@property (nullable, nonatomic, retain) NSString *photoPath;

@end

NS_ASSUME_NONNULL_END
