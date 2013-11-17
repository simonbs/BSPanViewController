//
//  SideViewController.m
//  Example
//
//  Created by Simon Støvring on 17/11/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "SideViewController.h"

@implementation SideViewController

#pragma mark 
#pragma mark Lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    _backgroundImageView = [UIImageView new];
    _backgroundImageView.frame = self.view.bounds;
    _backgroundImageView.contentMode = UIViewContentModeCenter;
    [self.view addSubview:_backgroundImageView];
}

- (void)dealloc
{
    _backgroundImageView = nil;
}

@end
