//
//  EQCommunicationHeaderView.m
//  EQ
//
//  Created by Sebastian Borda on 7/5/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "EQCommunicationHeaderView.h"

@interface EQCommunicationHeaderView()

@end

@implementation EQCommunicationHeaderView

- (void)loadCommunications:(NSArray *)communications{
    self.communications = communications;
    Comunicacion *communication = [communications lastObject];
    self.titleLabel.text = communication.titulo;
    self.bodyLabel.text = communication.descripcion;
    self.unreadMessageImage.hidden = YES;
    for (Comunicacion *comm in communications) {
        if (comm.leido == nil) {
            self.unreadMessageImage.hidden = NO;
            break;
        }
    }
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"dd.MM.yyyy"];
    self.dateLabel.text = [dateFormatter stringFromDate:communication.creado];
    self.endedImage.hidden = [communication.activo boolValue];
    self.communicationsQuantity.hidden = YES;
    int quantity = (int)[communications count];
    if (quantity > 1) {
        self.communicationsQuantity.text = [NSString stringWithFormat:@"%i",quantity];
        self.communicationsQuantity.hidden = NO;
    }
}

- (IBAction)selectedAction:(id)sender {
    [self.delegate communicationHeaderSelecter:self];
}

- (void)finalizeThread{
    self.endedImage.hidden = NO;
}

- (void)markAsRead{
    self.unreadMessageImage.hidden = YES;
    for (Comunicacion *comm in self.communications) {
        if (comm.leido == nil) {
            self.unreadMessageImage.hidden = NO;
            break;
        }
    }
}

- (Comunicacion *)mainCommunication{
    return [self.communications lastObject];
}

@end
