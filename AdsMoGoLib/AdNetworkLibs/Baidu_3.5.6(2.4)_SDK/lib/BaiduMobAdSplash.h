//
//  BaiduMobAdInterstitial.h
//  BaiduMobAdWebSDK
//
//  Created by deng jinxiang on 13-8-1.
//
//
#import <UIKit/UIKit.h>
#import "BaiduMobAdSplashDelegate.h"


@interface BaiduMobAdSplash : NSObject


/**
 *  委托对象
 */
@property (nonatomic ,assign) id<BaiduMobAdSplashDelegate> delegate;


/**
 *  设置/获取广告位id
 */
@property (nonatomic,copy) NSString* AdUnitTag;

/**
 *  设置开屏广告是否可以点击的属性,开屏默认可以点击。
 */
@property (nonatomic) BOOL canSplashClick;

/**
 *  设置开屏广告是否实时请求的属性，默认值为使用缓存广告，不实时请求。
 */
@property (nonatomic) BOOL useCache;

/**
 *  设置开屏广告的背景色。
 */
@property (nonatomic, copy) UIColor *backgroundColor;

/**
 *  设置开屏广告的大小。
 */
@property (nonatomic) CGRect splashRect;

/**

 *  SDK版本
 */
@property (nonatomic, readonly) NSString* Version;

/**
 *  应用启动时展示开屏广告
 */
- (void)loadAndDisplayUsingKeyWindow:(UIWindow *)keyWindow;


@end
