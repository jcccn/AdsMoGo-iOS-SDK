//
//  PBInterstitialSingleton.h
//  TestMOGOSDKAPI
//
//  Created by Daxiong on 14-3-27.
//  Copyright (c) 2014年 Daxiong. All rights reserved.
//

#import "CSInterstitial.h"

@protocol CSInterstitialSingletonDelegate ;
@interface CSInterstitialSingleton : NSObject

@property (assign) BOOL isReady;
@property (assign) BOOL isError;
@property (assign) id<CSInterstitialSingletonDelegate> delegate;

+ (id)shareInstanceWithPID:(NSString *)pid;
- (void) initInterstitialWithPlaceId:(NSString *)placeId;
- (void)showInterstitialWithScale:(float)scale;

@end

@protocol CSInterstitialSingletonDelegate <NSObject>

@optional

// 弹出广告加载完成
- (void)csInterstitialDidLoadAd:(CSInterstitial *)pbInterstitial;

// 弹出广告加载错误
- (void)csInterstitial:(CSInterstitial *)pbInterstitial
loadAdFailureWithError:(CSRequestError *)requestError;

// 弹出广告打开完成
- (void)csInterstitialDidPresentScreen:(CSInterstitial *)pbInterstitial;

// 弹出广告将要关闭
- (void)csInterstitialWillDismissScreen:(CSInterstitial *)pbInterstitial;

// 弹出广告关闭完成
- (void)csInterstitialDidDismissScreen:(CSInterstitial *)pbInterstitial;

@end
