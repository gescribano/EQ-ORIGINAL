//
//  EQSettings.m
//  EQ
//
//  Created by Sebastian Borda on 1/11/14.
//  Copyright (c) 2014 Sebastian Borda. All rights reserved.
//

#import "EQSettings.h"

@implementation EQSettings

- (void)setDefaultPriceList:(NSString *)defaultPriceList
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:defaultPriceList forKey:kPriceList];
    [defaults synchronize];
}

- (NSString*) defaultPriceList
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kPriceList];
}

- (void)setEnviroment:(NSString *)enviroment
{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:enviroment forKey:kEnviroment];
    [defaults synchronize];
}

- (NSString *)enviroment
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:kEnviroment];
}

@end
