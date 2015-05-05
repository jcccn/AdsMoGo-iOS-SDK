//
//  BOADBannerView.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-3-11.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BOADError;
@protocol BOADBannerViewDelegate;

#pragma mark - BOADAdSize
/**
 *  广告尺寸标识
 */
typedef NS_ENUM(NSUInteger, BOADAdSize) {
    /**
     *  320x50，iPhone和iPod Touch广告尺寸。
     */
    BOADAdSizeBanner,
    /**
     *  300x250，Medium Rectangle广告尺寸适用于iPad(especially in a UISplitView's left pane)。
     */
    BOADAdSizeMediumRectangle,
    /**
     *  468x60，Full Banner适用于iPad(especially in a UIPopoverController or in UIModalPresentationFormSheet)。
     */
    BOADAdSizeFullBanner,
    /**
     *  728x90，Leaderboard广告尺寸适用于iPad。
     */
    BOADAdSizeLeaderboard,
    /**
     *  iPhone: DEVICE_WIDTH × 50
     *  iPad: DEVICE_WIDTH × 90
     */
    BOADAdSizeSmartBannerPortrait,
    /**
     *  iPhone: DEVICE_WIDTH × 32
     *  iPad: DEVICE_WIDTH × 90
     */
    BOADAdSizeSmartBannerLandscape,
    /**
     *  非法广告标识
     */
    BOADAdSizeInvalid
};

/**
 *  传递`BOADAdSize`常量，返回`CGSize`。
 *  如果`BOADAdSize`非法，返回`CGSizeZero`。
 *
 *  @param size 广告尺寸标识
 *
 *  @return CGSize
 */
CGSize CGSizeFromBOADAdSize(BOADAdSize size);

/**
 *  YES表示广告尺寸标识合法。
 */
BOOL IsBOADAdSizeValid(BOADAdSize adSize);

/**
 *  YES表示广告标识一样。
 */
BOOL BOADAdSizeEqualToSize(BOADAdSize size1, BOADAdSize size2);

/**
 *  返回`BOADAdSize`的大小描述。
 */
NSString * NSStringFromBOADAdSize(BOADAdSize size);

/**
 *  横幅广告
 */
@interface BOADBannerView : UIView

/**
 *  指定初始化方法，通过广告尺寸标识和相对父视图的位置初始化`BOADBannerView`；如果`adSize`非法，不创建`BOADBannerView`对象，返回nil。
 *
 *  @param adSize 广告尺寸标识
 *  @param origin 相对父视图的位置
 *
 *  @return 横幅广告
 */
- (id)initWithAdSize:(BOADAdSize)adSize origin:(CGPoint)origin;
/**
 *  指定初始化方法，通过广告尺寸标识和相对父视图的左上位置初始化`BOADBannerView`；如果`adSize`非法，不创建`BOADBannerView`对象，返回nil。
 *
 *  @param adSize 广告尺寸标识
 *
 *  @return 横幅广告
 */
- (id)initWithAdSize:(BOADAdSize)adSize;

/**
 *  应用ID
 */
@property (nonatomic, copy) NSString *appId;
/**
 *  应用密钥
 */
@property (nonatomic, copy) NSString *appScrect;
/**
 *  委托
 */
@property (nonatomic, weak) id<BOADBannerViewDelegate> delegate;
/**
 *  设置广告大小，广告尺寸标识为`BOADAdSize`。
 *  如果广告已经显示，会重新发起请求。
 */
@property (nonatomic, assign) BOADAdSize adSize;
/**
 *  YES表示广告已经加载完毕。
 */
@property (nonatomic, assign, readonly, getter=isLoaded) BOOL loaded;

/**
 *  加载广告。
 */
- (void)loadAd;

/**
 *  主控制器引用，例如：基于选项(Tab)的应用，则传递`UITabViewController`对象。
 *
 *  @warning 如果当前控制器是模式控制器(Modal Controller)，需要设置主控制器引用。
 */
@property (nonatomic, weak) UIViewController *rootViewController;

/**
 *  默认为NO表示自动刷新；设置YES表示手工刷新，需要自己去轮询广告。
 *
 *  @warning !!!手工刷新!!!内部使用!!!
 */
@property (nonatomic, assign) BOOL manualRefresh;



@end

/**
 *  横幅广告委托
 */
@protocol BOADBannerViewDelegate <NSObject>

@optional
/**
 *  加载开始
 *
 *  @param bannerView 横幅广告
 */
- (void)boadBannerViewWillLoadAd:(BOADBannerView *)bannerView;
/**
 *  加载完毕
 *
 *  @param bannerView 横幅广告
 */
- (void)boadBannerViewDidLoadAd:(BOADBannerView *)bannerView;
/**
 *  加载失败
 *
 *  @param bannerView 横幅广告
 *  @param error  错误
 */
- (void)boadBannerView:(BOADBannerView *)bannerView didFailToReceiveAdWithError:(BOADError *)error;

/**
 *  点击广告
 *
 *  @param bannerView 横幅广告
 */
- (void)boadBannerViewDidTapAd:(BOADBannerView *)bannerView;

/**
 *  点击广告后，广告动作执行即将开始。
 *
 *  在用户点击广告后被调用。可以在这里暂停一些活动：游戏进行、视频播放等等。
 *  如果`willLeaveApplication`为YES表示应用进入后台，不需要做额外处理；
 *  如果`willLeaveApplication`为NO表示广告界面会覆盖整个应用，可以暂停一些活动直到广告动作执行完毕。
 *
 *  @warning 用户点击广告，先执行`boadBannerViewDidTapAd:`，然后执行`boadBannerViewActionWillBegin:willLeaveApplication:`，最后执行`boadBannerViewActionDidFinish:`。
 *  @param bannerView           横幅广告
 *  @param willLeaveApplication YES表示启动其他应用来执行广告动作；NO表示广告动作在应用内执行。
 */
- (void)boadBannerViewActionWillBegin:(BOADBannerView *)bannerView willLeaveApplication:(BOOL)willLeaveApplication;

/**
 *  广告动作执行完毕。
 *  在`boadBannerViewActionWillBegin:willLeaveApplication:`暂停的活动，可以在这里恢复。
 *
 *  @warning 用户点击广告，先执行`boadBannerViewDidTapAd:`，然后执行`boadBannerViewActionWillBegin:willLeaveApplication:`，最后执行`boadBannerViewActionDidFinish:`。
 *  @param bannerView 横幅广告
 */
- (void)boadBannerViewActionDidFinish:(BOADBannerView *)bannerView;

@end
