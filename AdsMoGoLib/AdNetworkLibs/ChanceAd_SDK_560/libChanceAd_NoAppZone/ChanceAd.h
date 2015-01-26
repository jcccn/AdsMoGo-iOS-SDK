//
//  ChanceAd.h
//  ChanceAd
//
//  Created by CocoaChina_yangjh on 13-10-15.
//  Copyright (c) 2013年 CocoaChina. All rights reserved.
//

#ifndef ChanceAd_h
#define ChanceAd_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CSADRequest.h"
#import "CSRequestError.h"
#import "CSBannerView.h"
#import "CSInterstitial.h"
#import "CSMoreGame.h"
#import "CSNativeMoreGame.h"


// SDK_Version仅供参考，以[ChanceAd sdkVersion];得到的版本号为准
#define SDK_Version  @"5.6.0"


@interface ChanceAd : NSObject

/**
 *	@brief	开启会话，在程序启动的时候调用
 *          建议放在协议方法application:didFinishLaunchingWithOptions:中调用
 *
 *	@param 	publisherID 	publisherID
 */
+ (void)startSession:(NSString *)publisherID;

/**
 *	@brief	获取SDK版本号
 *
 *	@return	SDK版本号
 */
+ (NSString *)sdkVersion;

/**
 *	@brief	非越狱设备上是否应用内打开（越狱设备上直接强制跳转）
 *
 *	@param 	openInApp 	YES表示iTunes链接要应用内打开。默认为NO。
 */
+ (void)openInAppWhenNoJailBroken:(BOOL)openInApp;

/**
 *	@brief	用于积分墙广告，开发者设置自己的用户系统信息，长度限制80（不能使用url参数禁用的字符，必要时开发者自行转义）
 *
 *	@param 	userInfo 	用户信息，可设置用户ID等信息
 */
+ (void)setUserInfo:(NSString *)userInfo;


#pragma mark - 精品推荐

/**
 *	@brief	显示精品推荐动画按钮
 *
 *	@param 	frameButton 	按钮位置。默认按钮尺寸：iPhone为55，iPad为110
 *	@param 	superViewButton 	按钮的父视图
 *	@param 	showBadge 	是否显示徽章
 *	@param 	animationImages 	按钮的帧图片
 *	@param 	duration 	帧间隔时间
 */
+ (void)showMoreGameButton:(CGRect)frameButton andBadge:(BOOL)showBadge onView:(UIView *)superViewButton
       withAnimationImages:(NSArray *)animationImages duration:(NSTimeInterval)duration;

/**
 *	@brief	移除精品推荐动画按钮
 */
+ (void)removeMoreGameButton;

@end
#endif

