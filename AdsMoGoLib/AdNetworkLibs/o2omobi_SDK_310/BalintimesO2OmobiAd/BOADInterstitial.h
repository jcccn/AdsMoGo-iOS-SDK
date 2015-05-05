//
//  BOADInterstitial.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-3-11.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BOADError;
@protocol BOADInterstitialDelegate;

/**
 *  间隙广告类型
 */
typedef NS_ENUM(NSUInteger, BOADInterstitialType) {
    /**
     *  插屏
     */
    BOADInterstitialTypeFloat,
    /**
     *  全屏
     */
    BOADInterstitialTypeFull,
    /**
     *  开屏
     */
    BOADInterstitialTypeStart
};

/**
 *  间隙广告。
 *  预加载功能：将广告的加载和显示分开。
 *  每个`BOADInterstitial`对象只对应一种广告类型。
 */
@interface BOADInterstitial : NSObject

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
@property (nonatomic, weak) id<BOADInterstitialDelegate> delegate;

/**
 *  间隙广告类型。
 */
@property (nonatomic, assign, readonly) BOADInterstitialType interstitialType;

/**
 *  YES表示广告已经加载完毕。
 *  当`loaded`由NO变成YES的时候，`delegate`的`boadInterstitialDidLoadAd:`会被调用。
 */
@property (nonatomic, assign, readonly, getter=isLoaded) BOOL loaded;

/**
 *  YES表示广告已经显示
 */
@property (nonatomic, assign, readonly, getter=isShowed) BOOL showed;

/**
 *  预加载插屏广告，显示需要调用`presentFloatAd`。
 *
 *  @warning 加载完毕`loaded`由NO变成YES，`delegate`的`boadInterstitialDidLoadAd:`会被调用。
 */
- (void)preloadFloatAd;

/**
 *  显示插屏广告。
 *
 *  @warning 使用`preloadFloatAd`方法后调用此方法才生效。
 *  @warning 当`loaded`为YES或者`delegate`的`boadInterstitialDidLoadAd:`有回调的时候，调用此方法才生效。
 */
- (void)presentFloatAd;

/**
 *  加载并显示插屏广告
 */
- (void)loadFloatAd;

/**
 *  预加载全屏广告，显示需要调用`presentFromViewController:`。
 *
 *  @warning 加载完毕`loaded`由NO变成YES，`delegate`的`boadInterstitialDidLoadAd:`会被调用。
 */
- (void)loadFullAd;

/**
 *  显示全屏广告。
 *
 *  @warning 使用`loadFullAd`方法后调用此方法才生效。
 *  @warning 当`loaded`为YES或者`delegate`的`boadInterstitialDidLoadAd:`有回调的时候，调用此方法才生效。
 *  @param viewController 当前控制器
 */
- (void)presentFromViewController:(UIViewController *)viewController;

/**
 *  加载并显示全屏广告
 *
 *  @param viewController 当前控制器
 */
- (void)loadFullAdAndPresentFromViewController:(UIViewController *)viewController;

/**
 *  加载开屏广告。
 *  `window`显示`defaultImage`直到`interstitial`请求成功或者请求超时(5s)。
 *  默认5s后自动关闭开屏广告。
 *
 *  @param window       应用窗体对象
 *  @param defaultImage 开屏默认图片对象
 */
- (void)loadStartAdUsingWindow:(UIWindow *)window defaultImage:(UIImage *)defaultImage;

/**
 *  加载开屏广告。
 *  `window`显示`defaultImage`直到`interstitial`请求成功或者请求超时(5s)。
 *  默认5s后自动关闭开屏广告。
 *
 *  @param window       应用窗体对象
 *  @param defaultImage 开屏默认图片对象
 *  @param autoClose    设置NO表示显示关闭按钮需要用户手工关闭
 */
- (void)loadStartAdUsingWindow:(UIWindow *)window defaultImage:(UIImage *)defaultImage autoClose:(BOOL)autoClose;

/**
 *  主控制器引用，例如：基于选项(Tab)的应用，则传递`UITabViewController`对象。
 *
 *  @warning 如果当前控制器是模式控制器(Modal Controller)，需要设置主控制器引用。
 */
@property (nonatomic, weak) UIViewController *rootViewController;

@end

/**
 *  间隙广告委托
 */
@protocol BOADInterstitialDelegate <NSObject>

@optional
/**
 *  加载开始
 *
 *  @param interstitial 间隙广告
 */
- (void)boadInterstitialWillLoadAd:(BOADInterstitial *)interstitial;
/**
 *  加载完毕
 *
 *  @param interstitial 间隙广告
 */
- (void)boadInterstitialDidLoadAd:(BOADInterstitial *)interstitial;
/**
 *  加载失败
 *
 *  @param interstitial 间隙广告
 *  @param error        错误
 */
- (void)boadInterstitial:(BOADInterstitial *)interstitial didFailToReceiveAdWithError:(BOADError *)error;
/**
 *  即将显示
 *
 *  @param interstitial 间隙广告
 */
- (void)boadInterstitialWillPresentScreen:(BOADInterstitial *)interstitial;
/**
 *  已经显示
 *
 *  @param interstitial 间隙广告
 */
- (void)boadInterstitialDidPresentScreen:(BOADInterstitial *)interstitial;
/**
 *  即将消失
 *
 *  @param interstitial 间隙广告
 */
- (void)boadInterstitialWillDismissScreen:(BOADInterstitial *)interstitial;
/**
 *  已经消失
 *
 *  @param interstitial 间隙广告
 */
- (void)boadInterstitialDidDismissScreen:(BOADInterstitial *)interstitial;
/**
 *  点击广告
 *
 *  @param interstitial 间隙广告
 */
- (void)boadInterstitialDidTapAd:(BOADInterstitial *)interstitial;

@end
