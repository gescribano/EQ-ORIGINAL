//
//  ALTabBarView.m
//  ALCommon
//
//  Created by Andrew Little on 10-08-17.
//  Copyright (c) 2010 Little Apps - www.myroles.ca. All rights reserved.
//

#import "ALTabBarView.h"

#define TAB_ORIGIN_FRAME 974

@implementation ALTabBarView

@synthesize delegate;
@synthesize selectedButton;
@synthesize tabButtons;

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        CGRect frame = self.frame;
        frame.origin.y = TAB_ORIGIN_FRAME;
        self.frame = frame;
    }
    return self;
}

//Let the delegate know that a tab has been touched
-(IBAction) touchButton:(id)sender {
    if(self.delegate) {
        int currentIndex = (int)self.selectedButton.tag;
        //DESACTIVA EL ESTADO EL BOTON ANTERIOR
        [self.selectedButton setSelected:NO];
        self.selectedButton = (UIButton *)sender;
        //ACTIVA EL NUEVO BOTON SELECCIONADO
        [self.selectedButton setSelected:YES];
        
        if (currentIndex != self.selectedButton.tag) {
            [delegate tabWasSelected:self.selectedButton.tag];
        }
    }
}

-(void) selectTabAtIndex:(int)index{
    int lastIndex = (int)NSNotFound;
    for (UIButton *button in self.tabButtons) {
        if ([button isSelected]) {
            lastIndex = (int)button.tag;
            [button setSelected:NO];
        }
        
        if (button.tag == index) {
            [button setSelected:YES];
            self.selectedButton = button;
        }
    }
    
    if (lastIndex != index) {
        [delegate tabWasSelected:index];
    }
}

@end
