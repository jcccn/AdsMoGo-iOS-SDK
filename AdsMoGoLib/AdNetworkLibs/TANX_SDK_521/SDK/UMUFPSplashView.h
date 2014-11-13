//
//  UMUFPSplashView.h
//  UFP
//
//  Created by liuyu on 5/17/13.
//  Updated by liu yu on 09/03/14.
//  Copyright 2007-2014 Alimama.com. All rights reserved.
//  Version 5.2.0
//
//  Support Email: mobilesupport@list.alibaba-inc.com

#import <UIKit/UIKit.h>

@protocol UMUFPSplashViewDelegate;

@interface UMUFPSplashView : UIView

@property (nonatomic) BOOL mCountdownEnable;  // Whether show the count down for the promoter impression progress, default is YES
@property (nonatomic) NSTimeInterval mTimeoutInterval; // Timeout for the default app launch duration, if the default app launch duration exceeds the timeout, current promoter impression will be canceled, default value is 0.0s 
@property (nonatomic, retain) UIView *mContentView; // Content view for the splash view, animation for the splash view can be added to layer of mContentView
@property (nonatomic, retain) UILabel *mCountDownLabel; // label for count down timer
@property (nonatomic, retain) UIImageView *mBackgroundView; // background view for the splash view, default is the 'Default' image
@property (nonatomic) NSTimeInterval mAppearAnimationInterval; // interval for the appear animation of splash view, default is 0.3s
@property (nonatomic) NSTimeInterval mDisappearAnimationInterval; // interval for the disappear animation of splash view, default is 0.3s
@property (nonatomic, assign) id<UMUFPSplashViewDelegate> delegate;

/**
 
 This method return a UMUFPSplashView object
 
 @param  frame frame for the splash view
 @param  appkey appkey get from www.umeng.com, if you want use ufp service only, set this parameter empty
 @param  slotId slotId get from ufp.umeng.com
 
 @return a UMUFPSplashView object
 */

- (id)initWithFrame:(CGRect)frame appKey:(NSString *)appkey slotId:(NSString *)slotId;

/**
 
 This method check and show splash view in the given parent view
 
 @param  view parent view for the splash view
 
 */

- (void)showInView:(UIView *)view; 

@end

@protocol UMUFPSplashViewDelegate <NSObject>

- (void)splashViewWillAppear:(UMUFPSplashView *)splashView; // implement this mothod if you want to change default animation for the splash view appear event
- (void)splashViewDidAppear:(UMUFPSplashView *)splashView;
- (void)splashViewWillDisappear:(UMUFPSplashView *)splashView; // implement this mothod if you want to change default animation for the splash view disappear event
- (void)splashViewDidDisappear:(UMUFPSplashView *)splashView;

@end
