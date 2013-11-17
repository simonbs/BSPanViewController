//
//  AppDelegate.h
//  Example
//
//  Created by Simon Støvring on 17/11/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TheAppDelegate ((AppDelegate *)[[UIApplication sharedApplication] delegate])

@class BSPanViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, readonly) BSPanViewController *panController;

@end
