//
//  EQCommunicationHeaderView.h
//  EQ
//
//  Created by Sebastian Borda on 7/5/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "Comunicacion+extra.h"

@class EQCommunicationHeaderView;

@protocol EQCommunicationHeaderViewDelegate <NSObject>

- (void)communicationHeaderSelecter:(EQCommunicationHeaderView *)sender;

@end

@interface EQCommunicationHeaderView : UIView
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *bodyLabel;
@property (strong, nonatomic) IBOutlet UIImageView *unreadMessageImage;
@property (strong, nonatomic) IBOutlet UILabel *dateLabel;
@property (strong, nonatomic) IBOutlet UIImageView *endedImage;
@property (strong, nonatomic) IBOutlet UILabel *communicationsQuantity;
@property (weak, nonatomic) id<EQCommunicationHeaderViewDelegate> delegate;
@property (nonatomic, strong) NSArray* communications;
@property (assign, nonatomic) NSInteger section;

- (void)loadCommunications:(NSArray *)communications;
- (IBAction)selectedAction:(id)sender;
- (void)finalizeThread;
- (void)markAsRead;
- (Comunicacion *)mainCommunication;

@end
