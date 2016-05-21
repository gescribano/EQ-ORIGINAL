//
//  EQDataAccessLayer.h
//  EQ
//
//  Created by Sebastian Borda on 3/24/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface EQDataAccessLayer : NSObject
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (strong, nonatomic) NSManagedObjectContext *mainManagedObjectContext;

+ (EQDataAccessLayer *)sharedInstance;
- (void)saveContext;
- (NSArray *)objectListForClass:(Class)objectClass;
- (NSArray *)objectListForClass:(Class)objectClass filterByPredicate:(NSPredicate *)predicate;
- (NSArray *)objectListForClass:(Class)objectClass filterByPredicate:(NSPredicate *)predicate sortBy:(NSSortDescriptor *)sortDescriptor limit:(int)limit ;
- (id)objectForClass:(Class)objectClass withId:(NSString *)idValue;
- (id)objectForClass:(Class)objectClass withPredicate:(NSPredicate *)predicate;
- (id)createManagedObject:(NSString*)kind;
- (id)createManagedObjectWithEntity:(NSEntityDescription*)entityDescription;
- (NSManagedObjectContext *)managedObjectContext;
- (void) resetUserDatabase;

@end
