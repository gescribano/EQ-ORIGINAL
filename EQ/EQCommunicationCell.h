//
//  EQCommunicationCell.h
//  EQ
//
//  Created by Sebastian Borda on 7/7/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Comunicacion.h"

@interface EQCommunicationCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *senderNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (nonatomic, strong) Comunicacion* communication;

@end
