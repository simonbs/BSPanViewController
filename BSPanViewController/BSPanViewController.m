//
//  BSPanViewController.m
//  Example
//
//  Created by Simon Støvring on 17/11/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import "BSPanViewController.h"

#define BSDefaultLeftPanSize 30.0f
#define BSDefaultLeftOpenAmount 270.0f
#define BSDefaultLeftOpenAnimationDuration 0.35f
#define BSDefaultLeftOpenSpringDamping 0.50f
#define BSDefaultLeftOpenSpringVelocity 0.50f
#define BSDefaultLeftCloseAnimationDuration 0.25f
#define BSDefaultLeftCloseSpringDamping 1.0f
#define BSDefaultLeftCloseSpringVelocity 0.0f
#define BSDefaultLeftParallaxAmount 0.35f
#define BSDefaultOpeningLeftMovesStatusBar YES
#define BSDefaultLeftShadowColor [UIColor blackColor]
#define BSDefaultLeftShadowOpacity 1.0f
#define BSDefaultLeftShadowRadius 10.0f
#define BSDefaultLeftShadowOffset CGSizeMake(-3.0f, 0.0f)
#define BSDefaultLeftTapToCloseEnabled YES

#define BSDefaultRightPanSize 30.0f
#define BSDefaultRightOpenAmount 270.0f
#define BSDefaultRightOpenAnimationDuration 0.35f
#define BSDefaultRightOpenSpringDamping 0.50f
#define BSDefaultRightOpenSpringVelocity 0.50f
#define BSDefaultRightCloseAnimationDuration 0.25f
#define BSDefaultRightCloseSpringDamping 1.0f
#define BSDefaultRightCloseSpringVelocity 0.0f
#define BSDefaultRightParallaxAmount 0.35f
#define BSDefaultOpeningRightMovesStatusBar YES
#define BSDefaultRightShadowColor [UIColor blackColor]
#define BSDefaultRightShadowOpacity 1.0f
#define BSDefaultRightShadowRadius 10.0f
#define BSDefaultRightShadowOffset CGSizeMake(3.0f, 0.0f)
#define BSDefaultRightTapToCloseEnabled YES

@interface BSPanViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, assign) CGPoint panPreviousLocation;
@property (nonatomic, assign) BSPanIntention panIntention;
@property (nonatomic, assign) BSSide side;
@property (nonatomic, assign, getter = isOpened) BOOL opened;
@property (nonatomic, strong) UIView *statusBarContainer;
@property (nonatomic, assign) CGRect initialMainControllerFrame;
@property (nonatomic, assign, getter = isStatusBarFaked) BOOL statusBarFaked;
@property (nonatomic, assign) BOOL hideStatusBar; // Used when UIViewControllerBasedStatusBarAppearance is true
@end

@implementation BSPanViewController

#pragma mark -
#pragma mark Lifecycle

- (id)init
{
    if (self = [super init])
    {
        self.side = BSSideUnknown;
        self.panIntention = BSPanIntentionUnknown;
        
        self.leftPanSize = BSDefaultLeftPanSize;
        self.leftOpenAmount = BSDefaultLeftOpenAmount;
        self.leftOpenAnimationDuration = BSDefaultLeftOpenAnimationDuration;
        self.leftOpenSpringDamping = BSDefaultLeftOpenSpringDamping;
        self.leftOpenSpringVelocity = BSDefaultLeftOpenSpringVelocity;
        self.leftCloseAnimationDuration = BSDefaultLeftCloseAnimationDuration;
        self.leftCloseSpringDamping = BSDefaultLeftCloseSpringDamping;
        self.leftCloseSpringVelocity = BSDefaultLeftCloseSpringVelocity;
        self.leftParallaxAmount = BSDefaultLeftParallaxAmount;
        self.openingLeftMovesStatusBar = BSDefaultOpeningLeftMovesStatusBar;
        self.leftShadowColor = BSDefaultLeftShadowColor;
        self.leftShadowOpacity = BSDefaultLeftShadowOpacity;
        self.leftShadowRadius = BSDefaultLeftShadowRadius;
        self.leftShadowOffset = BSDefaultLeftShadowOffset;
        self.leftTapToCloseEnabled = BSDefaultLeftTapToCloseEnabled;
        
        self.rightPanSize = BSDefaultRightPanSize;
        self.rightOpenAmount = BSDefaultRightOpenAmount;
        self.rightOpenAnimationDuration = BSDefaultRightOpenAnimationDuration;
        self.rightOpenSpringDamping = BSDefaultRightOpenSpringDamping;
        self.rightOpenSpringVelocity = BSDefaultRightOpenSpringVelocity;
        self.rightCloseAnimationDuration = BSDefaultRightCloseAnimationDuration;
        self.rightCloseSpringDamping = BSDefaultRightCloseSpringDamping;
        self.rightCloseSpringVelocity = BSDefaultRightCloseSpringVelocity;
        self.rightParallaxAmount = BSDefaultRightParallaxAmount;
        self.openingRightMovesStatusBar = BSDefaultOpeningRightMovesStatusBar;
        self.rightShadowColor = BSDefaultRightShadowColor;
        self.rightShadowOpacity = BSDefaultRightShadowOpacity;
        self.rightShadowRadius = BSDefaultRightShadowRadius;
        self.rightShadowOffset = BSDefaultRightShadowOffset;
        self.rightTapToCloseEnabled = BSDefaultRightTapToCloseEnabled;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    panGesture.delegate = self;
    [self.view addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapGesture:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
}

- (void)dealloc
{
    _delegate = nil;
    _mainController = nil;
    _leftController = nil;
    _rightController = nil;
    _statusBarContainer = nil;
    _leftShadowColor = nil;
    _rightShadowColor = nil;
}

- (BOOL)prefersStatusBarHidden
{
    return self.hideStatusBar;
}

#pragma mark -
#pragma mark Public Accessors

- (void)setMainController:(UIViewController *)mainController
{
    if (mainController != _mainController)
    {
        if (_mainController)
        {
            [_mainController removeFromParentViewController];
            [_mainController.view removeFromSuperview];
        }
        
        if (mainController)
        {
            [self addChildViewController:mainController];
            [self.view addSubview:mainController.view];
            [self.view bringSubviewToFront:mainController.view];
        }
        
        _mainController = mainController;
    }
}

- (void)setLeftController:(UIViewController *)leftController
{
    if (leftController != _leftController)
    {
        if (_leftController)
        {
            [_leftController removeFromParentViewController];
            [_leftController.view removeFromSuperview];
        }
        
        if (leftController)
        {
            [self addChildViewController:leftController];
            [self.view addSubview:leftController.view];
            [self.view bringSubviewToFront:_mainController.view];
        }
        
        _leftController = leftController;
    }
}

- (void)setRightController:(UIViewController *)rightController
{
    if (rightController != _rightController)
    {
        if (_rightController)
        {
            [_rightController removeFromParentViewController];
            [_rightController.view removeFromSuperview];
        }
        
        if (rightController)
        {
            [self addChildViewController:rightController];
            [self.view addSubview:rightController.view];
            [self.view bringSubviewToFront:_mainController.view];
        }
        
        _rightController = rightController;
    }
}

#pragma mark -
#pragma mark Public Methods

- (void)toggleLeft
{
    if (self.isOpened && self.side == BSSideLeft)
    {
        [self closeLeft];
    }
    else
    {
        [self openLeft];
    }
}

- (void)toggleRight
{
    if (self.isOpened && self.side == BSSideRight)
    {
        [self closeRight];
    }
    else
    {
        [self openRight];
    }
}

- (void)openLeft
{
    if (!self.isOpened || (self.isOpened && self.side == BSSideRight))
    {
        [self prepareToShowLeftController];
        [self openLeftController];
        self.side = BSSideLeft;
    }
}

- (void)closeLeft
{
    if (self.isOpened && self.side == BSSideLeft)
    {
        [self closeLeftController];
        self.side = BSSideUnknown;
    }
}

- (void)openRight
{
    if (!self.isOpened || (self.isOpened && self.side == BSSideLeft))
    {
        [self prepareToShowRightController];
        [self openRightController];
        self.side = BSSideRight;
    }
}

- (void)closeRight
{
    if (self.isOpened && self.side == BSSideRight)
    {
        [self closeRightController];
        self.side = BSSideUnknown;
    }
}

#pragma mark -
#pragma mark Private Methods

- (void)setMainControllerPosition:(CGPoint)position animationDuration:(NSTimeInterval)animationDuration springDamping:(CGFloat)springDamping springVelocity:(CGFloat)springVelocity completion:(void(^)(void))completion
{
    [UIView animateWithDuration:animationDuration delay:0.0f usingSpringWithDamping:springDamping initialSpringVelocity:springVelocity options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect = self.mainController.view.frame;
        rect.origin = position;
        self.mainController.view.frame = rect;
    } completion:^(BOOL finished) {
        if (finished && completion)
        {
            completion();
        }
    }];
}

- (void)openBySettingMainControllerPosition:(CGPoint)position animationDuration:(NSTimeInterval)animationDuration springDamping:(CGFloat)springDamping springVelocity:(CGFloat)springVelocity completion:(void(^)(void))completion
{
    __weak typeof(self) weakSelf = self;
    [self setMainControllerPosition:position animationDuration:animationDuration springDamping:springDamping springVelocity:springVelocity completion:^{
        weakSelf.opened = YES;
        
        if (completion)
        {
            completion();
        }
        
        if ([weakSelf.delegate respondsToSelector:@selector(panViewController:didOpenSide:)])
        {
            [weakSelf.delegate panViewController:weakSelf didOpenSide:weakSelf.side];
        }
    }];
}

- (void)closeBySettingMainControllerPosition:(CGPoint)position animationDuration:(NSTimeInterval)animationDuration springDamping:(CGFloat)springDamping springVelocity:(CGFloat)springVelocity completion:(void(^)(void))completion
{
    __weak typeof(self) weakSelf = self;
    [self setMainControllerPosition:position animationDuration:animationDuration springDamping:springDamping springVelocity:springVelocity completion:^{
        BSSide tempSide = weakSelf.side;
        
        weakSelf.opened = NO;
        weakSelf.side = BSSideUnknown;
        
        if (weakSelf.isStatusBarFaked)
        {
            [weakSelf hideFakeStatusBar];
        }
        
        if (completion)
        {
            completion();
        }
        
        if ([weakSelf.delegate respondsToSelector:@selector(panViewController:didCloseSide:)])
        {
            [weakSelf.delegate panViewController:weakSelf didCloseSide:tempSide];
        }
    }];
}

- (void)showFakeStatusBar
{
    CGRect statusBarFrame = [UIApplication sharedApplication].statusBarFrame;
    CGFloat statusBarHeight = CGRectGetHeight(statusBarFrame);
    
    CGRect statusBarContainerRect = CGRectZero;
    statusBarContainerRect.origin.y = -statusBarHeight;
    statusBarContainerRect.size = CGSizeMake(CGRectGetWidth(statusBarFrame), statusBarHeight);
    
    UIView *screenshot = [[UIScreen mainScreen] snapshotViewAfterScreenUpdates:NO];
    self.statusBarContainer = [UIView new];
    self.statusBarContainer.frame = statusBarContainerRect;
    self.statusBarContainer.clipsToBounds = YES;
    self.statusBarContainer.backgroundColor = [UIColor blackColor];
    [self.statusBarContainer addSubview:screenshot];
    [self.mainController.view addSubview:self.statusBarContainer];
    
    [self setStatusBarHidden:YES];
    
    self.initialMainControllerFrame = self.mainController.view.frame;
    
    CGRect rect = self.mainController.view.frame;
    rect.origin.y += statusBarHeight;
    rect.size.height -= statusBarHeight;
    self.mainController.view.frame = rect;
    
    self.statusBarFaked = YES;
}

- (void)hideFakeStatusBar
{
    [self.statusBarContainer removeFromSuperview];
    self.statusBarContainer = nil;
    
    self.mainController.view.frame = self.initialMainControllerFrame;
    
    [self setStatusBarHidden:NO];
    
    self.statusBarFaked = NO;
}

- (void)setStatusBarHidden:(BOOL)hidden
{
    BOOL UIViewControllerBasedStatusBarAppearance = [[[NSBundle mainBundle] objectForInfoDictionaryKey:@"UIViewControllerBasedStatusBarAppearance"] boolValue];
    if (UIViewControllerBasedStatusBarAppearance)
    {
        self.hideStatusBar = hidden;
        [self setNeedsStatusBarAppearanceUpdate];
    }
    else
    {
        [UIApplication sharedApplication].statusBarHidden = hidden;
    }
}

#pragma mark -
#pragma mark Gestures

- (void)handlePanGesture:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        switch (self.side) {
            case BSSideLeft:
                [self handleLeftPanBegan:gestureRecognizer];
                break;
            case BSSideRight:
                [self handleRightPanBegan:gestureRecognizer];
                break;
            default:
                break;
        }
        
        self.panPreviousLocation = location;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateChanged)
    {
        switch (self.side) {
            case BSSideLeft:
                [self handleLeftPanChanged:gestureRecognizer];
                break;
            case BSSideRight:
                [self handleRightPanChanged:gestureRecognizer];
                break;
            default:
                break;
        }
        
        self.panPreviousLocation = location;
    }
    else if (gestureRecognizer.state == UIGestureRecognizerStateEnded ||
             gestureRecognizer.state == UIGestureRecognizerStateCancelled ||
             gestureRecognizer.state == UIGestureRecognizerStateFailed)
    {
        switch (self.side) {
            case BSSideLeft:
                [self handleLeftPanStopped:gestureRecognizer];
                break;
            case BSSideRight:
                [self handleRightPanStopped:gestureRecognizer];
                break;
            default:
                break;
        }
        
        self.panPreviousLocation = CGPointZero;
        self.panIntention = BSPanIntentionUnknown;
    }
}

- (void)handleTapGesture:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded)
    {
        if (self.isOpened)
        {
            switch (self.side) {
                case BSSideLeft:
                    if (self.leftTapToCloseEnabled)
                    {
                        [self closeLeftController];
                    }
                    break;
                case BSSideRight:
                    if (self.rightTapToCloseEnabled)
                    {
                        [self closeRightController];
                    }
                    break;
                default:
                    break;
            }
        }
    }
}

#pragma mark -
#pragma mark Left Controller

- (void)handleLeftPanBegan:(UIGestureRecognizer *)gestureRecognizer
{
    [self prepareToShowLeftController];
}

- (void)handleLeftPanChanged:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    
    CGPoint diffLocation = CGPointZero;
    diffLocation.x = location.x - self.panPreviousLocation.x;
    diffLocation.y = location.y - self.panPreviousLocation.y;
    
    CGRect rect = self.mainController.view.frame;
    CGFloat newX = rect.origin.x + diffLocation.x;
    newX = MAX(0.0f, MIN(newX, self.leftOpenAmount));
    rect.origin.x = newX;
    self.mainController.view.frame = rect;
    
    self.panIntention = (diffLocation.x > 0) ? BSPanIntentionOpening : BSPanIntentionClosing;
    
    CGFloat percentage = newX / self.leftOpenAmount;
    CGRect leftRect = self.leftController.view.frame;
    leftRect.origin.x = -(self.leftOpenAmount * self.leftParallaxAmount) + (self.leftOpenAmount * self.leftParallaxAmount) * percentage;
    self.leftController.view.frame = leftRect;
    
    if ([self.delegate respondsToSelector:@selector(panViewController:didDragSide:toPercentage:withIntention:)])
    {
        [self.delegate panViewController:self didDragSide:BSSideLeft toPercentage:percentage withIntention:self.panIntention];
    }
}

- (void)handleLeftPanStopped:(UIGestureRecognizer *)gestureRecognizer
{
    switch (self.panIntention) {
        case BSPanIntentionOpening:
            [self openLeftController];
            break;
        case BSPanIntentionClosing:
            [self closeLeftController];
            break;
        default:
            break;
    }
}

- (void)prepareToShowLeftController
{
    self.leftController.view.hidden = NO;
    self.rightController.view.hidden = YES;
    
    [self.view bringSubviewToFront:self.leftController.view];
    [self.view bringSubviewToFront:self.mainController.view];
    
    self.mainController.view.layer.shadowColor = self.leftShadowColor.CGColor;
    self.mainController.view.layer.shadowOpacity = self.leftShadowOpacity;
    self.mainController.view.layer.shadowRadius = self.leftShadowRadius;
    self.mainController.view.layer.shadowOffset = self.leftShadowOffset;
    
    if (!self.isOpened && self.openingLeftMovesStatusBar)
    {
        [self showFakeStatusBar];
    }
}

- (void)openLeftController
{
    CGPoint pos = CGPointMake(self.leftOpenAmount, self.mainController.view.frame.origin.y);
    [self openBySettingMainControllerPosition:pos animationDuration:self.leftOpenAnimationDuration springDamping:self.leftOpenSpringDamping springVelocity:self.leftOpenSpringVelocity completion:nil];
    
    [self animateLeftParallaxIn];
}

- (void)closeLeftController
{
    CGPoint pos = CGPointMake(0.0f, self.mainController.view.frame.origin.y);
    [self closeBySettingMainControllerPosition:pos animationDuration:self.leftCloseAnimationDuration springDamping:self.leftCloseSpringDamping springVelocity:self.leftCloseSpringVelocity completion:nil];
    
    [self animateLeftParallaxOut];
}

- (void)animateLeftParallaxIn
{
    [UIView animateWithDuration:self.leftOpenAnimationDuration delay:0.0f usingSpringWithDamping:self.leftOpenSpringDamping initialSpringVelocity:self.leftOpenSpringVelocity options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect = self.leftController.view.frame;
        rect.origin.x = 0.0f;
        self.leftController.view.frame = rect;
    } completion:nil];
}

- (void)animateLeftParallaxOut
{
    [UIView animateWithDuration:self.leftCloseAnimationDuration delay:0.0f usingSpringWithDamping:self.leftCloseSpringDamping initialSpringVelocity:self.leftCloseSpringVelocity options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect = self.leftController.view.frame;
        rect.origin.x = -self.leftOpenAmount * self.leftParallaxAmount;
        self.leftController.view.frame = rect;
    } completion:nil];
}

- (BOOL)isPointInLeftOpenRect:(CGPoint)pos
{
    CGRect rect = CGRectZero;
    rect.size = CGSizeMake(self.leftPanSize, CGRectGetHeight(self.view.bounds));
    return CGRectContainsPoint(rect, pos);
}

- (BOOL)isPointInLeftCloseRect:(CGPoint)pos
{
    return CGRectContainsPoint(self.mainController.view.frame, pos);
}

#pragma mark -
#pragma mark Right Controller

- (void)handleRightPanBegan:(UIGestureRecognizer *)gestureRecognizer
{
    [self prepareToShowRightController];
}

- (void)handleRightPanChanged:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    
    CGPoint diffLocation = CGPointZero;
    diffLocation.x = location.x - self.panPreviousLocation.x;
    diffLocation.y = location.y - self.panPreviousLocation.y;
    
    CGRect rect = self.mainController.view.frame;
    CGFloat newX = rect.origin.x + diffLocation.x;
    newX = MIN(0.0f, MAX(newX, -self.rightOpenAmount));
    rect.origin.x = newX;
    self.mainController.view.frame = rect;
    
    self.panIntention = (diffLocation.x < 0) ? BSPanIntentionOpening : BSPanIntentionClosing;

    CGFloat percentage = fabsf(newX / self.rightOpenAmount);
    CGRect rightRect = self.rightController.view.frame;
    rightRect.origin.x = (self.rightOpenAmount * self.rightParallaxAmount) - (self.rightOpenAmount * self.rightParallaxAmount) * percentage;
    self.rightController.view.frame = rightRect;
    
    if ([self.delegate respondsToSelector:@selector(panViewController:didDragSide:toPercentage:withIntention:)])
    {
        [self.delegate panViewController:self didDragSide:BSSideRight toPercentage:percentage withIntention:self.panIntention];
    }
}

- (void)handleRightPanStopped:(UIGestureRecognizer *)gestureRecognizer
{
    switch (self.panIntention) {
        case BSPanIntentionOpening:
            [self openRightController];
            break;
        case BSPanIntentionClosing:
            [self closeRightController];
            break;
        default:
            break;
    }
}

- (void)prepareToShowRightController
{
    self.leftController.view.hidden = YES;
    self.rightController.view.hidden = NO;
    
    [self.view bringSubviewToFront:self.rightController.view];
    [self.view bringSubviewToFront:self.mainController.view];
    
    self.mainController.view.layer.shadowColor = self.rightShadowColor.CGColor;
    self.mainController.view.layer.shadowOpacity = self.rightShadowOpacity;
    self.mainController.view.layer.shadowRadius = self.rightShadowRadius;
    self.mainController.view.layer.shadowOffset = self.rightShadowOffset;
    
    if (!self.isOpened && self.openingRightMovesStatusBar)
    {
        [self showFakeStatusBar];
    }
}

- (void)openRightController
{
    CGPoint pos = CGPointMake(-self.rightOpenAmount, self.mainController.view.frame.origin.y);
    [self openBySettingMainControllerPosition:pos animationDuration:self.rightOpenAnimationDuration springDamping:self.rightOpenSpringDamping springVelocity:self.rightOpenSpringVelocity completion:nil];
    
    [self animateRightParallaxIn];
}

- (void)closeRightController
{
    CGPoint pos = CGPointMake(0.0f, self.mainController.view.frame.origin.y);
    [self closeBySettingMainControllerPosition:pos animationDuration:self.rightCloseAnimationDuration springDamping:self.rightCloseSpringDamping springVelocity:self.rightCloseSpringVelocity completion:nil];
    
    [self animateRightParallaxOut];
}

- (void)animateRightParallaxIn
{
    [UIView animateWithDuration:self.rightOpenAnimationDuration delay:0.0f usingSpringWithDamping:self.rightOpenSpringDamping initialSpringVelocity:self.rightOpenSpringVelocity options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect = self.rightController.view.frame;
        rect.origin.x = 0.0f;
        self.rightController.view.frame = rect;
    } completion:nil];
}

- (void)animateRightParallaxOut
{
    [UIView animateWithDuration:self.rightCloseAnimationDuration delay:0.0f usingSpringWithDamping:self.rightCloseSpringDamping initialSpringVelocity:self.rightCloseSpringVelocity options:UIViewAnimationOptionCurveLinear animations:^{
        CGRect rect = self.rightController.view.frame;
        rect.origin.x = self.rightOpenAmount * self.rightParallaxAmount;
        self.rightController.view.frame = rect;
    } completion:nil];
}

- (BOOL)isPointInRightOpenRect:(CGPoint)pos
{
    CGRect rect = CGRectZero;
    rect.origin = CGPointMake(CGRectGetWidth(self.mainController.view.frame) - self.rightPanSize, 0.0f);
    rect.size = CGSizeMake(self.rightPanSize, CGRectGetHeight(self.view.bounds));
    return CGRectContainsPoint(rect, pos);
}

- (BOOL)isPointInRightCloseRect:(CGPoint)pos
{
    return CGRectContainsPoint(self.mainController.view.frame, pos);
}

#pragma mark -
#pragma mark Gesture Recognizer Delegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint location = [gestureRecognizer locationInView:self.view];
    
    if (self.isLeftPanEnabled && !self.isOpened && [self isPointInLeftOpenRect:location])
    {
        // Open left side
        self.side = BSSideLeft;
        return YES;
    }
    else if (self.isLeftPanEnabled && self.isOpened && self.side == BSSideLeft && [self isPointInLeftCloseRect:location])
    {
        // Close left side
        return YES;
    }
    else if (self.isRightPanEnabled && !self.isOpened && [self isPointInRightOpenRect:location])
    {
        // Open right side
        self.side = BSSideRight;
        return YES;
    }
    else if (self.isRightPanEnabled && self.isOpened && self.side == BSSideRight && [self isPointInRightCloseRect:location])
    {
        // Close right side
        return YES;
    }
    
    return NO;
}

@end
