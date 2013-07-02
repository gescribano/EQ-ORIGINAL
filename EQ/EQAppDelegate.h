//
//  EQAppDelegate.h
//  EQ
//
//  Created by Sebastian Borda on 3/24/13.
//  Copyright (c) 2013 Sebastian Borda. All rights reserved.
//

#import "ALTabBarController.h"

@interface EQAppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate>{
    
}

@property (strong, nonatomic) IBOutlet UIWindow *window;
@property (strong, nonatomic) IBOutlet ALTabBarController *tabBarController;
@property (strong, nonatomic) UINavigationController *navigationController;

- (void)pushTabBarAtIndex:(int)index;
- (void)selectTabAtIndex:(int)index;
- (void)reStartNavigation;
- (void)showLoadingViewWithMessage:(NSString *)message;
- (void)showLoadingView;
- (void)hideLoadingView;
@end
