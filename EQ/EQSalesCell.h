//
//  EQSalesCell.h
//  EQ
//
//  Created by Sebastian Borda on 6/23/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EQSalesCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *periodLabel;
@property (strong, nonatomic) IBOutlet UILabel *clientLabel;
@property (strong, nonatomic) IBOutlet UILabel *articleLabel;
@property (strong, nonatomic) IBOutlet UILabel *quantityLabel;
@property (strong, nonatomic) IBOutlet UILabel *priceLabel;

@end
