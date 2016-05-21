//
//  EQEditOrderDetailCell.h
//  EQ
//
//  Created by Sebastian Borda on 5/19/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "ItemPedido+extra.h"
#import "LightItem.h"


@protocol EQEditOrderDetailCellDelegate;

@interface EQEditOrderDetailCell : UITableViewCell

@property (assign, nonatomic) id<EQEditOrderDetailCellDelegate> delegate;
@property (strong, nonatomic) IBOutlet UILabel *codeLabel;
@property (strong, nonatomic) IBOutlet UILabel *productNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantitySold;

- (IBAction)editButtonAction:(id)sender;
- (IBAction)deleteButtonAction:(id)sender;
- (void)loadItem:(ItemPedido *)item;

@end

@protocol EQEditOrderDetailCellDelegate <NSObject>

- (void)editItem:(ItemPedido *)item;
- (void)removeItem:(ItemPedido *)item;

@end