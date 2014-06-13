/*!
 @header SMAdInterstitial.h
 @abstract base bannerView
 @author madhouse
 @version 3.0.6 2014/04/03 Creation 
 */


#import <UIKit/UIKit.h>
#import "SMAdManager.h"

@class SMAdInterstitial;
@class SMAdEventCode;

/*!
 @protocol
 @abstract SMAdInterstitialDelegate
 @discussion SMAdInterstitial's delegate
 */

@protocol SMAdInterstitialDelegate <NSObject>

@optional

/*!
 @method
 @abstract 插页广告接收成功
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialDidReceiveAd:(SMAdInterstitial*)ad;

/*!
 @method
 @abstract 插页广告接收失败
 @discussion
 @param adview
 @param errorCode
 @result nil
 */
- (void)adInterstitial:(SMAdInterstitial*)adview didFailToReceiveAdWithError:(SMAdEventCode*)errorCode;

/*!
 @method
 @abstract 插页广告已经被点击
 @discussion
 @result nil
 */
- (void)adInterstitialDidClick;


/*!
 @method
 @abstract 插页广告将添加到屏幕上
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialWillPresentScreen:(SMAdInterstitial*)ad;

/*!
 @method
 @abstract 插页广告将要从屏幕上移出
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialWillDismissScreen:(SMAdInterstitial*)ad;

/*!
 @method
 @abstract 插页广告已经从屏幕上移出
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialDidDismissScreen:(SMAdInterstitial*)ad;

/*!
 @method
 @abstract 插页广告被点击后应用切换到后台，例如：调用系统浏览器
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialWillLeaveApplication:(SMAdInterstitial*)ad;


@end


/*!
 @class
 @abstract SMAdInterstitial
 */
@interface SMAdInterstitial : NSObject

/*!
 @property
 @abstract delegate
 */
@property (nonatomic, assign) id<SMAdInterstitialDelegate> delegate;

/*!
 @property
 @abstract 插页广告的广告位
 */
@property (nonatomic, copy) NSString* adSpaceId;

/*!
 @property
 @abstract 插页广告的尺寸
 */
@property (nonatomic, assign) SMAdInterstitialSizeType adSize;

/*!
 @property
 @abstract 插页广告的动画
 */
@property (nonatomic, assign) SMAdInterstitialAnimationType adInterstitialAnimationType;


/*!
 @method
 @abstract initWithAdSpaceId 用广告位初始化插页广告方法
 @discussion
 @param adSpaceId
 @result id
 */
- (id)initWithAdSpaceId:(NSString*)adSpaceId;

/*!
 @method
 @abstract initWithAdSpaceId 用广告位和广告尺寸初始化插页广告方法
 @discussion
 @param adSpaceId
 @param adSize
 @result id
 */
- (id)initWithAdSpaceId:(NSString *)adSpaceId smAdSize:(SMAdInterstitialSizeType)adSize;

/*!
 @method
 @abstract 请求插页广告
 @discussion
 @result nil
 */
- (void)requestAd;

/*!
 @method
 @abstract 展示插页广告
 @discussion
 @param rootViewController
 @result nil
 */

- (void)presentFromRootViewController:(UIViewController *)rootViewController;

@end
