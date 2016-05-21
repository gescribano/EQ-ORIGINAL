//
//  EQSyncronizationTableViewCell.h
//  EQ
//
//  Created by Jonathan on 8/21/15.
//  Copyright (c) 2015 Sebastian Borda. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    EQSyncIncremental               = 0,
    EQSyncCatalogs                  = 1,
    EQSyncProductsImages            = 2,
    EQSyncCatalogImages             = 3
} EQSyncOptionSelected;

@class EQSyncronizationTableViewCell;

@protocol EQSyncDelegate <NSObject>

- (void) syncButtonPressedWithSender:(EQSyncronizationTableViewCell*)sender;

@end

@interface EQSyncronizationTableViewCell : UITableViewCell

@property (nonatomic) EQSyncOptionSelected syncSelected;

@property (nonatomic) int currentRow;

@property (weak, nonatomic) id<EQSyncDelegate>delegate;

@property (weak, nonatomic) IBOutlet UILabel *title;

@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UIButton *syncButton;

@end
