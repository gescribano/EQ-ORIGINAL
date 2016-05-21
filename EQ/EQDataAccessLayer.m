//
//  EQDataAccessLayer.m
//  EQ
//
//  Created by Sebastian Borda on 3/24/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQDataAccessLayer.h"

static NSString const * kManagedObjectContextKey = @"EQ_NSManagedObjectContextForThreadKey";

@interface EQDataAccessLayer ()

@property (strong, nonatomic) NSPersistentStoreCoordinator *storeCoordinator;
@property (nonatomic,strong) NSPredicate *objectIDPredicate;

- (NSURL *)applicationDocumentsDirectory;

@end

@implementation EQDataAccessLayer
@synthesize storeCoordinator;
@synthesize managedObjectModel;
@synthesize mainManagedObjectContext;

+ (EQDataAccessLayer *)sharedInstance {
    __strong static EQDataAccessLayer *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EQDataAccessLayer alloc] init];
        sharedInstance.objectIDPredicate = [NSPredicate predicateWithFormat:@"identifier == $OBJECT_ID"];
    });
    return sharedInstance;
}

#pragma mark - Core Data

- (void)saveContext {
    
    NSError *error = nil;
    NSManagedObjectContext *context = [self managedObjectContext];
    if (context != nil)
    {
        if ([context hasChanges]) {
            if (![context save:&error]) {
                NSLog(@"error: %@", error.userInfo);
            /*
             Replace this implementation with code to handle the error appropriately.
             
             abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. If it is not possible to recover from the error, display an alert panel that instructs the user to quit the application by pressing the Home button.
             */
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            abort();
            }
        }
    }
}


- (NSArray *)objectListForClass:(Class)objectClass
{
    return [self objectListForClass:objectClass filterByPredicate:nil sortBy:nil limit:0];
}

- (NSArray *)objectListForClass:(Class)objectClass filterByPredicate:(NSPredicate *)predicate
{
    return [self objectListForClass:objectClass filterByPredicate:predicate sortBy:nil limit:0];
}

- (NSArray *)objectListForClass:(Class)objectClass
              filterByPredicate:(NSPredicate *)predicate
                         sortBy:(NSSortDescriptor *)sortDescriptor
                          limit:(int)limit
{
    NSString *className = NSStringFromClass(objectClass);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:className];
    [fetchRequest setFetchLimit:limit];
    if (fetchRequest) {
        fetchRequest.predicate = predicate;
    }
    
    if (sortDescriptor) {
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sortDescriptor]];
    } else {
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"identifier" ascending:YES];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    }
    NSArray *managedObjectList = [[self managedObjectContext] executeFetchRequest:fetchRequest error:nil];
    return managedObjectList;
}

- (id)objectForClass:(Class)objectClass withId:(NSString *)idValue{
  
    if (idValue) {
        NSPredicate* localPredicate = [self.objectIDPredicate predicateWithSubstitutionVariables:@{@"OBJECT_ID":idValue}];
        NSManagedObject *object = [self objectForClass:objectClass withPredicate:localPredicate];
        if (object) {
            return object;
        }
    }
    
    NSString *className = NSStringFromClass(objectClass);
    return [self createManagedObject:className];
}

- (id)objectForClass:(Class)objectClass withPredicate:(NSPredicate *)predicate{
    NSString *className = NSStringFromClass(objectClass);
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] initWithEntityName:className];
    fetchRequest.predicate = predicate;
    
    NSError *error = nil;
    NSArray *managedObjectList = [[self managedObjectContext] executeFetchRequest:fetchRequest error:&error];
    if([managedObjectList count] > 0){
        return [managedObjectList lastObject];
    }
    
    return nil;
}

- (id)createManagedObject:(NSString*)kind{
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:kind
                                   inManagedObjectContext:[self managedObjectContext]];
    
    NSManagedObject *newEntity = [[NSManagedObject alloc]
                                  initWithEntity:entity
                                  insertIntoManagedObjectContext:[self managedObjectContext]];
    
    return newEntity;
}

- (id)createManagedObjectWithEntity:(NSEntityDescription*)entityDescription{
    
    NSManagedObject *newEntity = [[NSManagedObject alloc]
                                  initWithEntity:entityDescription
                                  insertIntoManagedObjectContext:[self managedObjectContext]];
    
    return newEntity;
}

#pragma mark Core Data stack

/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContext {
    return self.mainManagedObjectContext;
}

- (NSManagedObjectContext *)mainManagedObjectContext
{
    if (!mainManagedObjectContext)
    {
        NSManagedObjectContext* context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];
        [context setPersistentStoreCoordinator:[self persistentStoreCoordinator]];
        [context setMergePolicy:NSMergeByPropertyObjectTrumpMergePolicy];
        mainManagedObjectContext = context;
    }
    return mainManagedObjectContext;
}

/**
 Returns the managed object model for the application.
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModel {
    if (managedObjectModel != nil)
    {
        return managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"EQModel" withExtension:@"momd"];
    self.managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return managedObjectModel;
}

/**
 *
 */

 
/**
 Returns the persistent store coordinator for the application.
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    if (storeCoordinator != nil)
    {
        return storeCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"model.sqlite"];
    
    NSLog(@"DB LINK %@",storeURL);
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    
    NSError *error = nil;
    self.storeCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error])
    {
        //REMOVE USER PREFERENCES
        NSError *error;
        for (NSPersistentStore *store in storeCoordinator.persistentStores) {
            BOOL removed = [storeCoordinator removePersistentStore:store error:&error];
            if (!removed) {
                NSLog(@"Unable to remove persistent store: %@", error);
            }
        }
        [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:nil];
        if (![storeCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:@{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES} error:&error]) {
            // Report any error we got.
            NSMutableDictionary *dict = [NSMutableDictionary dictionary];
            dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
            dict[NSLocalizedFailureReasonErrorKey] = failureReason;
            dict[NSUnderlyingErrorKey] = error;
            error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
            // Replace this with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            
            abort();
        }
    }
    
    return storeCoordinator;
}

- (void) resetUserDatabase
{
    NSError *error;
    for (NSPersistentStore *store in storeCoordinator.persistentStores) {
        BOOL removed = [storeCoordinator removePersistentStore:store error:&error];
        if (!removed) {
            NSLog(@"Unable to remove persistent store: %@", error);
        }
    }
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"model.sqlite"];
    [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:nil];
    storeCoordinator = nil;
    self.managedObjectModel = nil;
    self.mainManagedObjectContext = nil;
}

#pragma mark Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end