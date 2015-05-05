//
//  BOADMiniFloat.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-3-21.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class BOADMiniFloatView;
@class BOADError;
@protocol BOADMiniFloatDelegate;

/**
 *  悬浮广告
 */
@interface BOADMiniFloat : NSObject

/**
 *  单例
 *
 *  @return BOADMiniFloat 对象
 */
+ (instancetype)sharedInstance;

/**
 *  悬浮广告视图
 */
@property (nonatomic, strong, readonly) BOADMiniFloatView *miniFloatView;

/**
 *  委托
 */
@property (nonatomic, weak) id<BOADMiniFloatDelegate> delegate;

/**
 *  YES表示广告已经加载完毕并显示在当前界面
 */
@property (nonatomic, assign, readonly, getter=isLoaded) BOOL loaded;

/**
 *  应用ID
 */
@property (nonatomic, copy) NSString *appId;

/**
 *  应用密钥
 */
@property (nonatomic, copy) NSString *appScrect;

/**
 *  加载广告
 */
- (void)loadAd;

/**
 *  移除悬浮广告，移除之后如果还要显示悬浮广告，需要重新发起请求`loadAd`。
 */
- (void)removeAd;

/**
 *  主控制器引用，例如：基于选项(Tab)的应用，则传递`UITabViewController`对象。
 *
 *  @warning 如果当前控制器是模式控制器(Modal Controller)，需要设置主控制器引用。
 */
@property (nonatomic, weak) UIViewController *rootViewController;

@end

/**
 *  悬浮广告委托
 */
@protocol BOADMiniFloatDelegate <NSObject>

@optional
/**
 *  加载开始
 *
 *  @param miniFloat 悬浮广告
 */
- (void)boadMiniFloatWillLoadAd:(BOADMiniFloat *)miniFloat;
/**
 *  加载完毕
 *
 *  @param miniFloat 悬浮广告
 */
- (void)boadMiniFloatDidLoadAd:(BOADMiniFloat *)miniFloat;
/**
 *  加载失败
 *
 *  @param miniFloat 悬浮广告
 *  @param error  错误
 */
- (void)boadMiniFloat:(BOADMiniFloat *)miniFloat didFailToReceiveAdWithError:(BOADError *)error;
/**
 *  点击广告
 *
 *  @param miniFloat 悬浮广告
 */
- (void)boadMiniFloatDidTapAd:(BOADMiniFloat *)miniFloat;

@end
