//
//  CSInterstitial.h
//  CSADSDK
//
//  Created by CocoaChina_yangjh on 13-10-28.
//  Copyright (c) 2013年 CocoaChina. All rights reserved.
//

#ifndef CSInterstitial_h
#define CSInterstitial_h
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "CSADRequest.h"
#import "CSRequestError.h"


typedef NS_ENUM(unsigned int, CSInterstitialStatus) {
    CSInterstitialStatus_Hide,
    CSInterstitialStatus_Showing,
    CSInterstitialStatus_Show,
    CSInterstitialStatus_Hiding,
};


// 弹出广告加载完成
typedef void (^CSInterstitialDidLoadAD)();
// 弹出广告加载出错
typedef void (^CSInterstitialLoadFailure)(CSRequestError *error);
// 弹出广告打开完成
typedef void (^CSInterstitialDidPresent)();
// 弹出广告倒计时结束
typedef void (^CSInterstitialCountDownFinished)();
// 弹出广告将要关闭
typedef void (^CSInterstitialWillDismiss)();
// 弹出广告关闭完成
typedef void (^CSInterstitialDidDismiss)();


@protocol CSInterstitialDelegate;

@interface CSInterstitial : NSObject

// 关闭按钮显示前的倒计时时长（秒）
@property (nonatomic, assign) unsigned int countDown;
// 倒计时后是否自动关闭，默认为NO
@property (nonatomic, assign) BOOL autoCloseAfterCountDown;
// 是否显示关闭按钮，默认为YES
@property (nonatomic, assign) BOOL showCloseButton;
// 广告是否准备好。准备好则show或fill马上就能展现，否则可能需要等待
@property (nonatomic, readonly) BOOL isReady;
// 关闭时是否加载下一个广告（默认值为YES）
@property (nonatomic, assign) BOOL loadNextWhenClose;
// 积分墙当前状态
@property (nonatomic, readonly) CSInterstitialStatus status;
// 弹出广告图片尺寸
@property (nonatomic, readonly) CGSize interstitialSize;
// 弹出广告回调代理
@property (nonatomic, assign) id <CSInterstitialDelegate> delegate;

// 弹出广告加载完成的block
@property (nonatomic, copy) CSInterstitialDidLoadAD didLoadAD;
// 弹出广告加载出错的block
@property (nonatomic, copy) CSInterstitialLoadFailure loadADFailure;
// 弹出广告打开完成的block
@property (nonatomic, copy) CSInterstitialDidPresent didPresent;
// 弹出广告倒计时结束的block
@property (nonatomic, copy) CSInterstitialCountDownFinished countDownFinished;
// 弹出广告将要关闭的block
@property (nonatomic, copy) CSInterstitialWillDismiss willDismiss;
// 弹出广告关闭完成的block
@property (nonatomic, copy) CSInterstitialDidDismiss didDismiss;

// 弹出广告只有一个
+ (CSInterstitial *)sharedInterstitial;

/**
 *	@brief	加载弹出广告数据
 *
 *	@param 	csRequest 	请求弹出广告时的参数
 */
- (void)loadInterstitial:(CSADRequest *)csRequest;

/**
 *	@brief	显示弹出广告
 *
 *	@param 	scale 	显示比例（开发者想由后台设定显示比例，则该值设置为0即可）
 */
- (void)showInterstitialWithScale:(CGFloat)scale;

/**
 *	@brief	显示弹出广告
 *
 *	@param 	rootView 	弹出广告的父视图
 *	@param 	scale 	显示比例（开发者想由后台设定显示比例，则该值设置为0即可）
 */
- (void)showInterstitialOnRootView:(UIView *)rootView withScale:(CGFloat)scale;

/**
 *	@brief	用弹出广告填充view
 *
 *	@param 	弹出广告的容器
 */
- (void)fillInterstitialInView:(UIView *)view;

/**
 *	@brief	关闭弹出广告
 */
- (void)closeInterstitial;

@end


@protocol CSInterstitialDelegate <NSObject>

@optional

// 弹出广告加载完成
- (void)csInterstitialDidLoadAd:(CSInterstitial *)csInterstitial;

// 弹出广告加载错误
- (void)csInterstitial:(CSInterstitial *)csInterstitial
loadAdFailureWithError:(CSRequestError *)requestError;

// 弹出广告打开完成
- (void)csInterstitialDidPresentScreen:(CSInterstitial *)csInterstitial;

// 倒计时结束
- (void)csInterstitialCountDownFinished:(CSInterstitial *)csInterstitial;

// 弹出广告将要关闭
- (void)csInterstitialWillDismissScreen:(CSInterstitial *)csInterstitial;

// 弹出广告关闭完成
- (void)csInterstitialDidDismissScreen:(CSInterstitial *)csInterstitial;

@end
#endif
