//
//  UMUFPBannerView.h
//  UFP
//
//  Created by liu yu on 11/7/11.
//  Updated by liu yu on 07/10/14.
//  Copyright 2007-2014 Alimama.com. All rights reserved.
//  Version 5.1.0
//
//  Support Email: mobilesupport@list.alibaba-inc.com

#import <UIKit/UIKit.h>

@class CLLocation;

@protocol MMUBannerViewDelegate;

/**
 
 The MMUBannerViewDelegate class defines a banner view that can show different kind of Ads and response for releated click actions.
 
 */

@interface MMUBannerView : UIView

@property (nonatomic, assign) id<MMUBannerViewDelegate> delegate; //delegate for banner view

 /** 
 
 This method return a MMUBannerView object
 
 @param  frame frame for the banner view
 @param  slotId unique id for the releated position
 @param  controller view controller releated to the view that the banner view added into
 
 @return a MMUBannerView object
 */

- (id)initWithFrame:(CGRect)frame slotId:(NSString *)slotId currentViewController:(UIViewController *)controller;

/** 
 
 This method start the promoter data load in background, promoter data will be load until this method called
 
 */

- (void)requestPromoterDataInBackground;

/**
 
 This method set channel for this app, the default channel is App Store, call this method if you want to set channel for another value, don't need to call this method among different views, only once is enough
 
 @param  channel channel name for the app
 
 */

+ (void)setAppChannel:(NSString *)channel;

/**
 
 This method set current location
 
 @param  location current location
 
 */

+ (void)setLocation:(CLLocation *)location;

@end

/**
 
 MMUBannerViewDelegate is a protocol for MMUBannerView.
 Optional methods of the protocol allow the delegate to capture MMUBannerView releated events, and perform other actions.
 
 */

@protocol MMUBannerViewDelegate <NSObject>

@optional

- (void)bannerWillAppear:(MMUBannerView *)banner;
- (void)bannerDidAppear:(MMUBannerView *)banner;
- (void)bannerWillDisappear:(MMUBannerView *)banner;
- (void)bannerDidDisappear:(MMUBannerView *)banner;
- (void)bannerDidClicked:(MMUBannerView *)banner;
- (void)bannerView:(MMUBannerView *)banner didLoadPromoterFailedWithError:(NSError *)error;

@end