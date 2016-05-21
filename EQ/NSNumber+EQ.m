//
//  NSNumber+EQ.m
//  EQ
//
//  Created by Sebastian Borda on 8/6/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "NSNumber+EQ.h"

@implementation NSNumber (EQ)

- (NSString *)currencyString {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSLocale *argLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_AR"];
    [numberFormatter setLocale:argLocale];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
    return [numberFormatter stringFromNumber:self];
}

- (NSString *)decimalString {
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    NSLocale *argLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"es_AR"];
    [numberFormatter setLocale:argLocale];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    return [numberFormatter stringFromNumber:self];
}

@end
