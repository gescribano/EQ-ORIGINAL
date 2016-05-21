//
//  ALTabBarController.h
//  ALCommon
//
//  Created by Andrew Little on 10-08-17.
//  Copyright (c) 2010 Little Apps - www.myroles.ca. All rights reserved.
//
//  Custom TabBarController that hides the iOS TabBar view and displays a custom
//  UI defined in TabBarView.xib.  By customizing TabBarView.xib, you can
//  create a tab bar that is unique to your application, but still has the tab
//  switching functionality you've come to expect out of UITabBarController.


#import <Foundation/Foundation.h>
#import "ALTabBarView.h"

@interface ALTabBarController : UITabBarController <ALTabBarDelegate> {
    ALTabBarView *customTabBarView;
}

@property (nonatomic, strong) ALTabBarView *customTabBarView;
@property (nonatomic) NSInteger customSelectedIndex;

-(void) hideExistingTabBar;
-(void) selectTabAtIndex:(int)index;
-(void) reloadControllers;

@end
