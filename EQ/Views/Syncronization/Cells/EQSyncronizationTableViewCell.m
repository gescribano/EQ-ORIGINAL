//
//  EQSyncronizationTableViewCell.m
//  EQ
//
//  Created by Jonathan on 8/21/15.
//  Copyright (c) 2015 Sebastian Borda. All rights reserved.
//

#import "EQSyncronizationTableViewCell.h"

@interface EQSyncronizationTableViewCell ()



@end

@implementation EQSyncronizationTableViewCell

- (void)awakeFromNib {
    // Initialization code
    self.syncButton.hidden = YES;
}

- (void)prepareForReuse
{
    self.syncButton.hidden = YES;
}

- (void)setCurrentRow:(int)currentRow
{
    if (currentRow % 2 == 0)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    else
    {
        self.backgroundColor = [UIColor colorWithRed:240/256 green:240/256 blue:240/256 alpha:1];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setSyncSelected:(EQSyncOptionSelected)syncSelected
{
    _syncSelected = syncSelected;
    self.syncButton.hidden = NO;
}

- (IBAction)syncAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(syncButtonPressedWithSender:)])
    {
        [self.delegate syncButtonPressedWithSender:self];
    }
}


@end
