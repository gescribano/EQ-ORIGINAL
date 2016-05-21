//
//  EQCustomDateFilterPopover.h
//  EQ
//
//  Created by Sebastian Borda on 6/26/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQDateFilterPopover.h"
#import "CDatePickerViewEx.h"

@interface EQCustomDateFilterPopover : EQDateFilterPopover
@property (strong, nonatomic) IBOutlet CDatePickerViewEx *customPickerStart;

@property (strong, nonatomic) IBOutlet CDatePickerViewEx *customPickerEnd;
@end
