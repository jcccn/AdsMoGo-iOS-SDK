/*!
 @header SMAdBannerView.h
 @abstract base bannerView
 @author madhouse
 @version 3.0.5 2013/12/11 Creation 
 */

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "SMAdManager.h"



@class SMAdBannerView;
@class SMAdEventCode;


/*!
 @protocol
 @abstract SMAdBannerViewDelegate
 @discussion SMAdBannerView's delegate
 */

@protocol SMAdBannerViewDelegate <NSObject>

@optional

/*!
 @method
 @abstract Banner received
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewDidReceiveAd:(SMAdBannerView*)adView;

/*!
 @method
 @abstract Banner request failed
 @discussion
 @param adView
 @param errorCode
 @result nil
 */
- (void)adBannerView:(SMAdBannerView*)adView didFailToReceiveAdWithError:(SMAdEventCode*)errorCode;

/*!
 @method
 @abstract Banner will present screen
 @discussion
 @param adView
 @param eventCode
 @result nil
 */
- (void)adBannerViewWillPresentScreen:(SMAdBannerView*)adView impressionEventCode:(SMAdEventCode*)eventCode;

/*!
 @method
 @abstract Banner will dismiss screen
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewWillDismissScreen:(SMAdBannerView*)adView;

/*!
 @method
 @abstract Banner did dismiss screen
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewDidDismissScreen:(SMAdBannerView*)adView;

/*!
 @method
 @abstract Banner will leave application, eg. call default browser
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewWillLeaveApplication:(SMAdBannerView*)adView;

/*!
 @method
 @abstract Banner Clicked
 @discussion
 @result nil
 */
- (void)adDidClick;

/*!
 @method
 @abstract Banner exended
 @discussion
 @param adView
 @result nil
 */
- (void)adWillExpandAd:(SMAdBannerView *)adView;

/*!
 @method
 @abstract Banner close expand status
 @discussion
 @param adView
 @result nil
 */
- (void)adDidCloseExpand:(SMAdBannerView*)adView;

/*!
 @method
 @abstract Application will suspend for ad, eg. call in-app browser
 @discussion
 @param adView
 @result nil
 */
- (void)appWillSuspendForAd:(SMAdBannerView*)adView;

/*!
 @method
 @abstract Application will resume from ad
 @discussion
 @param adView
 @result nil
 */
- (void)appWillResumeFromAd:(SMAdBannerView*)adView;

@end


/*!
 @class
 @abstract SMAdBannerView
 */

@interface SMAdBannerView : UIView

/*!
 @property
 @abstract SMAdBannerViewDelegate's object
 */
@property (nonatomic, assign) id<SMAdBannerViewDelegate> delegate;

/*!
 @property
 @abstract adSpaceId
 */

@property (nonatomic, copy) NSString* adSpaceId;

/*!
 @property
 @abstract adSize
 */
@property (nonatomic, assign) SMAdBannerSizeType adSize;

/*!
 @property
 @abstract rootViewController
 */
@property (nonatomic, assign) UIViewController *rootViewController;

/*!
 @property
 @abstract adBannerAnimationType
 */
@property (nonatomic, assign) SMAdBannerAnimationType adBannerAnimationType;

/*!
 @method
 @abstract SMAdBannerView Public Constructors
 @discussion 
 @param adSpaceId 

 @result SMAdBannerView's object
 */

- (id)initWithAdSpaceId:(NSString*)adSpaceId;


/*!
 @method
 @abstract SMAdBannerView Public Constructors
 @discussion 
 @param adSpaceId
 @param adSize
 @result SMAdBannerView's object
 */
- (id)initWithAdSpaceId:(NSString *)adSpaceId smAdSize:(SMAdBannerSizeType)adSize;

@end
