//
//  EQCustomDateFilterPopover.m
//  EQ
//
//  Created by Sebastian Borda on 6/26/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQCustomDateFilterPopover.h"

@interface EQCustomDateFilterPopover ()

@end

@implementation EQCustomDateFilterPopover

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.customPickerStart reloadAllComponents];
    [self.customPickerStart setSelectedIndexPath];
    [self.customPickerEnd reloadAllComponents];
    [self.customPickerEnd setSelectedIndexPath];
}

- (NSDate *)getPickerStartDate{
    return self.customPickerStart.date;
}

- (NSDate *)getPickerEndDate{
    return [self obtainMonthLastDayForDate:self.customPickerEnd.date];
}

- (void)setPickerStartDate:(NSDate *)startDate{
    self.customPickerStart.date = startDate;
}

- (void)setPickerEndDate:(NSDate *)endDate{
    self.customPickerEnd.date = endDate;
}

@end
