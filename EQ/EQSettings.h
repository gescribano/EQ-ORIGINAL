//
//  EQSettings.h
//  EQ
//
//  Created by Sebastian Borda on 1/11/14.
//  Copyright (c) 2014 Sebastian Borda. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kPriceList @"PriceList"
#define kEnviroment @"Enviroment"

@interface EQSettings : NSObject

@property (nonatomic,strong) NSString *defaultPriceList;
@property (nonatomic,strong) NSString *enviroment;


@end
