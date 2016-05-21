//
//  EQSession.m
//  EQ
//
//  Created by Sebastian Borda on 4/25/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQSession.h"
#import "EQDataManager.h"
#import "EQDataAccessLayer.h"
#import "Grupo+extra.h"

@interface EQSession()

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *currentLocation;

@end

@implementation EQSession

+ (EQSession *)sharedInstance
{
    static EQSession *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[EQSession alloc] init];
        sharedInstance.locationManager = [[CLLocationManager alloc] init];
        sharedInstance.locationManager.delegate = sharedInstance;
        sharedInstance.settings = [EQSettings new];
    });
    return sharedInstance;
}

- (void)startMonitoring{
    [self.locationManager startMonitoringSignificantLocationChanges];
}

- (void)stopMonitoring{
    [self.locationManager stopMonitoringSignificantLocationChanges];
}

// Delegate method from the CLLocationManagerDelegate protocol.
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations {
    // If it's a relatively recent event, turn off updates to save power
    CLLocation* location = [locations lastObject];
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    if (fabs(howRecent) < 45.0) {
        // If the event is recent, do something with it.
        self.currentLocation = location;
    }
}

- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error{
    NSLog(@"locationManager error[%@]", error.localizedDescription);
}

- (void)updateData{
    [[EQDataManager sharedInstance] updateDataShowLoading:YES];
}

- (NSNumber *)currentLongitude{
    return [NSNumber numberWithDouble:self.currentLocation.coordinate.longitude];
}

- (NSNumber *)currentLatitude{
    return [NSNumber numberWithDouble:self.currentLocation.coordinate.latitude];
}

- (void)regiteredUser:(Usuario *)user
{
    [self setUser:user];
    
    if ([self checkIfIncrementalSyncIsNeeded])
    {
        [self initializeDataSynchronization];
    };
}



- (BOOL) isFirstSync
{
    return ![EQSession sharedInstance].lastSyncDate;
}

- (BOOL) checkIfIncrementalSyncIsNeeded
{
    
    BOOL isAlreadySyncing = [EQDataManager sharedInstance].running;
    BOOL isTheFirstSync = [self isFirstSync];
    BOOL dataExpired = [[NSDate date] timeIntervalSinceDate:[EQSession sharedInstance].lastSyncDate] > kMaxNumberOfDaysWithoutUpdate*24*60*60;
    BOOL isLoggedIn = [self isUserLogged];
    
    //El usuario esta loggeado, a aplicacion no esta siendo sincronizanada, es la primera vez o los datos han expirado
    return (isLoggedIn && !isAlreadySyncing &&(isTheFirstSync || dataExpired));
}

- (void)initializeDataSynchronization{
    [self forceSynchronization];
}

- (void)forceSynchronization
{
    [[EQDataManager sharedInstance] updateDataShowLoading:YES];
}

- (void)endSession{
    self.user = nil;
    _selectedClient = nil;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"loggedUser"];
    [defaults synchronize];
}

- (NSDate *)lastSyncDate{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:@"lastSyncDate"];
}

- (void)dataUpdated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[NSDate date] forKey:@"lastSyncDate"];
    [defaults synchronize];
    [[EQDataManager sharedInstance] sendPendingData];
}

- (BOOL)isUserLogged
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"loggedUser"];
    if (userID && !self.user) {
        EQDataAccessLayer *adl = [EQDataAccessLayer sharedInstance];
        [adl.mainManagedObjectContext performBlock:^{
            [self regiteredUser:(Usuario *)[adl objectForClass:[Usuario class] withId:userID]];
        }];
    }
    return userID != nil;
}

- (Usuario *)user
{
    EQDataAccessLayer *adl = [EQDataAccessLayer sharedInstance];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *userID = [defaults objectForKey:@"loggedUser"];
    Usuario* usuario;
    if (userID)
    {
        usuario = (Usuario *)[adl objectForClass:[Usuario class] withId:userID];
    }
    return usuario;
}

- (void)setUser:(Usuario *)user
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:user.identifier forKey:@"loggedUser"];
    [defaults synchronize];
}

- (void)setSelectedClient:(Cliente *)selectedClient
{
    
    dispatch_async(dispatch_get_main_queue(), ^
                   {
                       [Grupo resetRelevancia];
                       NSMutableDictionary *userInfo = [NSMutableDictionary dictionary];
                       if (selectedClient) {
                           [selectedClient calcularRelevancia];
                           [userInfo setObject:selectedClient forKey:@"activeClient"];
                           EQDataAccessLayer *adl = [EQDataAccessLayer sharedInstance];
                           _selectedClient = (Cliente *)[adl.mainManagedObjectContext objectWithID:selectedClient.objectID];
                       }
                       else
                       {
                           _selectedClient = nil;
                       }
                       
                       [[NSNotificationCenter defaultCenter] postNotificationName:ACTIVE_CLIENT_CHANGE_NOTIFICATION object:nil userInfo:userInfo];
                   });
}

- (void)updateCache{
    if ([NSThread isMainThread]) {
        //        [[EQDataAccessLayer sharedInstance].managedObjectContext refreshObject:self.selectedClient mergeChanges:YES];
        //        [[EQDataAccessLayer sharedInstance].managedObjectContext refreshObject:self.user mergeChanges:YES];
        //        [[EQDataAccessLayer sharedInstance].managedObjectContext refreshObject:self.user.vendedor mergeChanges:YES];
        [[NSNotificationCenter defaultCenter] postNotificationName:DATA_UPDATED_NOTIFICATION object:nil];
    } else {
        [self performSelectorOnMainThread:@selector(updateCache) withObject:nil waitUntilDone:NO];
    }
}

@end
