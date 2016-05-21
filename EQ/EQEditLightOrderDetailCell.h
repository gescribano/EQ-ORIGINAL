//
//  EQEditLightOrderDetailCell.h
//  EQ
//
//  Created by Pablo Suarez
//  Copyright (c) 2015 . All rights reserved.
//

#import "LightItem.h"


@protocol EQEditLightOrderDetailCellDelegate;

@interface EQEditLightOrderDetailCell : UITableViewCell

@property (assign, nonatomic) id<EQEditLightOrderDetailCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantitySold;

- (IBAction)editButtonAction:(id)sender;
- (IBAction)deleteButtonAction:(id)sender;
- (void)loadItem:(LightItem *)item;


@end

@protocol EQEditLightOrderDetailCellDelegate <NSObject>

- (void)editItem:(LightItem *)item;
- (void)removeItem:(LightItem *)item;

@end