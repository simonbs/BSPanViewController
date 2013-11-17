//
//  AppDelegate.m
//  Example
//
//  Created by Simon Støvring on 17/11/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "AppDelegate.h"
#import "BSPanViewController.h"
#import "MainViewController.h"
#import "LeftViewController.h"
#import "RightViewController.h"

@implementation AppDelegate

#pragma mark -
#pragma mark Lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self applyAppearance];
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:[MainViewController new]];
        
    _panController = [BSPanViewController new];
    _panController.leftPanEnabled = YES;
    _panController.rightPanEnabled = YES;
    _panController.mainController = navigationController;
    _panController.leftController = [LeftViewController new];
    _panController.rightController = [RightViewController new];
    _panController.openingLeftMovesStatusBar = YES;
    _panController.openingRightMovesStatusBar = NO;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = _panController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)dealloc
{
    _panController = nil;
}

#pragma mark -
#pragma mark Private Methods

- (void)applyAppearance
{
    UIColor *barTintColor = [UIColor colorWithRed:0.413 green:0.502 blue:0.539 alpha:1.000];
    UIColor *tintColor = [UIColor whiteColor];
    UIColor *navigationBarTextColor = [UIColor whiteColor];
    
    [[UINavigationBar appearance] setBarTintColor:barTintColor];
    [[UINavigationBar appearance] setTintColor:tintColor];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName : navigationBarTextColor }];
    
    [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

@end
