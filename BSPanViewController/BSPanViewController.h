//
//  BSPanViewController.h
//  Example
//
//  Created by Simon Støvring on 17/11/13.
//  Copyright (c) 2013 intuitaps. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 *  Specifies a side which is revealed.
 */
typedef NS_ENUM(NSInteger, BSSide) {
    /**
     *  No side is revealed.
     */
    BSSideUnknown = -1,
    /**
     *  Left side is revelaed.
     */
    BSSideLeft = 0,
    /**
     *  Right side is revealed.
     */
    BSSideRight,
};

/**
 *  Specifies why the user is dragging.
 *  This can also be used to detect what will happen if the user stops the pan gesture.
 */
typedef NS_ENUM(NSInteger, BSPanIntention) {
    /**
     *  No intention is specified.
     */
    BSPanIntentionUnknown = -1,
    /**
     *  Opening intention. If the user stops the pan gesture, the side will be opened.
     */
    BSPanIntentionOpening = 0,
    /**
     *  Closing intention. If the user stops the pan gesture, side will be closed.
     */
    BSPanIntentionClosing,
};

@protocol BSPanViewControllerDelegate;

/**
 *  Controller which has a left and right side which can be opened and closed either
 *  using a pan gesture or programmatically.
 */
@interface BSPanViewController : UIViewController

/**
 *  The delegate which should be notified of events.
 */
@property (nonatomic, weak) id <BSPanViewControllerDelegate> delegate;

/**
 *  The current side being opened or closed. The value is reset when the side is closed.
 */
@property (nonatomic, readonly) BSSide side;

/**
 *  Whether or not a side is currently opened.
 *  Refer to the side to figure out which side is opened.
 *
 *  @see BSSide
 */
@property (nonatomic, readonly, getter = isOpened) BOOL opened;

/**
 *  The controller which can be dragged.
 */
@property (nonatomic, strong) UIViewController *mainController;

/**
 *  Controller disabled when the main controller is dragged to the left.
 *  Note that if this controller is set and you wish to be able to open
 *  and close the side using a pan gesture this must be enabled.
 *
 *  @see leftPanEnabled
 */
@property (nonatomic, strong) UIViewController *leftController;

/**
 *  Controller disabled when the main controller is dragged to the right.
 *  Note that if this controller is set and you wish to be able to open
 *  and close the side using a pan gesture this must be enabled.
 *
 *  @see rightPanEnabled
 */
@property (nonatomic, strong) UIViewController *rightController;

/**
 *  Specifies whether or not the user should be able to open and close
 *  the left controller using the pan gesture.
 */
@property (nonatomic, assign, getter = isLeftPanEnabled) BOOL leftPanEnabled;

/**
 *  Width of the area which will trigger the pan gesture when opening the left side.
 */
@property (nonatomic, assign) CGFloat leftPanSize;

/**
 *  Amount the left side should be revealed when the side is opened.
 */
@property (nonatomic, assign) CGFloat leftOpenAmount;

/**
 *  Duration of the animation when opening the left side,
 */
@property (nonatomic, assign) NSTimeInterval leftOpenAnimationDuration;

/**
 *  Amount of damping in the animation played when opening the left side.
 */
@property (nonatomic, assign) CGFloat leftOpenSpringDamping;

/**
 *  Amount of velocity in the animation played when opening the left side.
 */
@property (nonatomic, assign) CGFloat leftOpenSpringVelocity;

/**
 *  Duration of the animation when closing the left side,
 */
@property (nonatomic, assign) NSTimeInterval leftCloseAnimationDuration;

/**
 *  Amount of damping in the animation played when closing the left side.
 */
@property (nonatomic, assign) CGFloat leftCloseSpringDamping;

/**
 *  Amount of velocity in the animation played when closing the left side.
 */
@property (nonatomic, assign) CGFloat leftCloseSpringVelocity;

/**
 *  Parallax amount of the left side. A value between 0 and 1.
 *  A value of 0 means that the side will not be parallaxed and value of 1 means
 *  that the side will scroll with the same speed as the main controller.
 *  A value of 0.50 means the view is shifted half of the amount the side
 *  should be opened and thus it scrolls half speed of the main controller.
 */
@property (nonatomic, assign) CGFloat leftParallaxAmount;

/**
 *  Specifies whether or not the status bar should be moved along with
 *  the main controller or it should stay at its default position.
 */
@property (nonatomic, assign) BOOL openingLeftMovesStatusBar;

/**
 *  Color of the shadow on the main controller when revealing the left side.
 */
@property (nonatomic, strong) UIColor *leftShadowColor;

/**
 *  Opacity of the shadow on the main controller when revealing the left side.
 */
@property (nonatomic, assign) CGFloat leftShadowOpacity;

/**
 *  Radius of the shadow on the main controller when revealing the left side.
 */
@property (nonatomic, assign) CGFloat leftShadowRadius;

/**
 *  Offset of the shadow on the main controller when revealing the left side.
 */
@property (nonatomic, assign) CGSize leftShadowOffset;

/**
 *  Specifies whether or not the left side should be closed when tapping
 *  the main controller while the side is opened.
 */
@property (nonatomic, assign) BOOL leftTapToCloseEnabled;

/**
 *  Specifies whether or not the user should be able to open and close
 *  the right controller using the pan gesture.
 */
@property (nonatomic, assign, getter = isRightPanEnabled) BOOL rightPanEnabled;

/**
 *  Width of the area which will trigger the pan gesture when opening the right side.
 */
@property (nonatomic, assign) CGFloat rightPanSize;

/**
 *  Amount the right side should be revealed when the side is opened.
 */
@property (nonatomic, assign) CGFloat rightOpenAmount;

/**
 *  Duration of the animation when opening the right side,
 */
@property (nonatomic, assign) NSTimeInterval rightOpenAnimationDuration;

/**
 *  Amount of damping in the animation played when opening the right side.
 */
@property (nonatomic, assign) CGFloat rightOpenSpringDamping;

/**
 *  Amount of velocity in the animation played when opening the right side.
 */
@property (nonatomic, assign) CGFloat rightOpenSpringVelocity;

/**
 *  Duration of the animation when closing the right side,
 */
@property (nonatomic, assign) NSTimeInterval rightCloseAnimationDuration;

/**
 *  Amount of damping in the animation played when closing the right side.
 */
@property (nonatomic, assign) CGFloat rightCloseSpringDamping;

/**
 *  Amount of velocity in the animation played when closing the right side.
 */
@property (nonatomic, assign) CGFloat rightCloseSpringVelocity;

/**
 *  Parallax amount of the right side. A value between 0 and 1.
 *  A value of 0 means that the side will not be parallaxed and value of 1 means
 *  that the side will scroll with the same speed as the main controller.
 *  A value of 0.50 means the view is shifted half of the amount the side
 *  should be opened and thus it scrolls half speed of the main controller.
 */
@property (nonatomic, assign) CGFloat rightParallaxAmount;

/**
 *  Specifies whether or not the status bar should be moved along with
 *  the main controller or it should stay at its default position.
 */
@property (nonatomic, assign) BOOL openingRightMovesStatusBar;

/**
 *  Color of the shadow on the main controller when revealing the right side.
 */
@property (nonatomic, strong) UIColor *rightShadowColor;

/**
 *  Opacity of the shadow on the main controller when revealing the right side.
 */
@property (nonatomic, assign) CGFloat rightShadowOpacity;

/**
 *  Radius of the shadow on the main controller when revealing the right side.
 */
@property (nonatomic, assign) CGFloat rightShadowRadius;

/**
 *  Offset of the shadow on the main controller when revealing the right side.
 */
@property (nonatomic, assign) CGSize rightShadowOffset;

/**
 *  Specifies whether or not the right side should be closed when tapping
 *  the main controller while the side is opened.
 */
@property (nonatomic, assign) BOOL rightTapToCloseEnabled;

/**
 *  Open or close the left side depending on its current state.
 */
- (void)toggleLeft;

/**
 *  Open or close the right side depending on its current state.
 */
- (void)toggleRight;

/**
 *  Open the left side.
 */
- (void)openLeft;

/**
 *  Close the left side.
 */
- (void)closeLeft;

/**
 *  Open the right side,
 */
- (void)openRight;

/**
 *  Close the right side.
 */
- (void)closeRight;

@end

@protocol BSPanViewControllerDelegate <NSObject>
@optional
/**
 *  Called when a side is opened.
 *
 *  @param controller The pan controller which opened the side.
 *  @param side       Side which was opened.
 *
 *  @see BSSide
 */
- (void)panViewController:(BSPanViewController *)controller didOpenSide:(BSSide)side;

/**
 *  Called when a side is closed.
 *
 *  @param controller The pan controller which closed the side.
 *  @param side       Side which was closed.
 *
 *  @see BSSide
 */
- (void)panViewController:(BSPanViewController *)controller didCloseSide:(BSSide)side;

/**
 *  Called when the main controller is dragged.
 *
 *  @param controller The pan controller which closed the side.
 *  @param side       Side the controller was dragged in.
 *  @param percentage Amount the side is revelead.
 *  @param intention  Intention of the user.
 *
 *  @see BSSide
 *  @see BSPanIntention
 */
- (void)panViewController:(BSPanViewController *)controller didDragSide:(BSSide)side toPercentage:(CGFloat)percentage withIntention:(BSPanIntention)intention;
@end
