//
//  UMUFPInterstitialView.h
//
//  Updated by liu yu on 07/10/14.
//  Updated by liu yu on 09/03/14.
//  Copyright 2007-2014 Alimama.com. All rights reserved.
//  Version 5.2.0
//
//  Support Email: mobilesupport@list.alibaba-inc.com

#import <UIKit/UIKit.h>

@class CLLocation;
@protocol MMUInterstitialViewDelegate;

@interface MMUInterstitialView : UIView

@property (nonatomic, assign) id<MMUInterstitialViewDelegate> delegate;

/**
 * slotId: 广告位ID
 * controller: 当前controller
 * mask: 是否带背景半透明蒙板
 */
- (id)initWithSlotId:(NSString*)slotId
          controller:(UIViewController*)controller
                mask:(BOOL)mask;

/**
 * tt: 视频名称
 * dur: 视频时长 单位为秒
 * ca: 视频类目
 */
- (void)loadWithTt:(NSString*)tt
               dur:(NSString*)dur
                ca:(NSString*)ca;

- (void)load;

- (void)close;

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

@protocol MMUInterstitialViewDelegate <NSObject>

@optional

- (void)loadFinished:(MMUInterstitialView*)interstitialView;
- (void)loadFailed:(MMUInterstitialView*)interstitialView error:(NSError*)error;
- (void)InterstitialViewDidClose:(MMUInterstitialView*)interstitialView;
- (void)interstitialViewDidClicked:(MMUInterstitialView *)interstitialView;

@end
