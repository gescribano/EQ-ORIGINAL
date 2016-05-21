//
//  EQSession.h
//  EQ
//
//  Created by Sebastian Borda on 4/25/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import "Vendedor.h"
#import "Cliente+extra.h"
#import "Usuario+extra.h"
#import "EQSettings.h"

#define kMaxNumberOfDaysWithoutUpdate 3

@interface EQSession : NSObject <CLLocationManagerDelegate>

+ (EQSession *)sharedInstance;
- (NSDate *)lastSyncDate;
- (void)regiteredUser:(Usuario *)user;
- (void)endSession;
- (void)dataUpdated;
- (BOOL)isUserLogged;
- (void)updateCache;
- (NSNumber *)currentLongitude;
- (NSNumber *)currentLatitude;
- (void)startMonitoring;
- (void)stopMonitoring;
- (BOOL) isFirstSync;

- (BOOL) checkIfIncrementalSyncIsNeeded;
- (void)forceSynchronization;

@property (nonatomic,strong) Cliente *selectedClient;
@property (nonatomic,strong) Usuario *user;
@property (nonatomic,strong) EQSettings *settings;




@end
