//
//  EQDefines.h
//  EQ
//
//  Created by Sebastian Borda on 4/27/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//
#import "EQAppDelegate.h"

typedef enum{
    EQTABIndexInit = -1,
    EQTabIndexOrders = 0,
    EQTabIndexCurrentAccount = 1,
    EQTabIndexSales = 2,
    EQTabIndexCommunications = 3,
    EQTabIndexGoals = 4,
    EQTabIndexProducts = 5,
    EQTabIndexClients = 6,
    EQTabIndexCatalogs = 7
}EQTabIndex;

#define APP_DELEGATE (EQAppDelegate *)[[UIApplication sharedApplication]delegate]
#ifdef TEST_VERSION
    #define MAXIMUM_MINUTES_TO_UPDATE 2
    #define HOST @"stg.eqarte.com.ar"
    #define BASE_URL @"http://stg.eqarte.com.ar/"
    #define IMAGES_BASE_URL @"http://www.eqarte.com.ar/wp-content/uploads/"
    #define API_URL "http://stg.eqarte.com.ar/wp-admin/admin-ajax.php"
#else
    #define MAXIMUM_MINUTES_TO_UPDATE 10
    #define HOST @"www.eqarte.com.ar"
    #define BASE_URL @"https://www.eqarte.com.ar/"
    #define IMAGES_BASE_URL @"https://www.eqarte.com.ar/wp-content/uploads/"
    #define API_URL "https://www.eqarte.com.ar/wp-admin/admin-ajax.php"
#endif

#define DATA_UPDATED_NOTIFICATION @"dataUpdatedNotification"
#define ACTIVE_CLIENT_CHANGE_NOTIFICATION @"activeClientChangeNotification"

#define COMMUNICATION_TYPE_OPERATIVE @"op"
#define COMMUNICATION_TYPE_COMMERCIAL @"com"
#define COMMUNICATION_TYPE_GOAL @"cli"