//
//  PBInterstitialSingleton.h
//  TestMOGOSDKAPI
//
//  Created by Daxiong on 14-3-27.
//  Copyright (c) 2014年 Daxiong. All rights reserved.
//

#import "PBInterstitial.h"

@protocol PBInterstitialSingletonDelegate ;
@interface PBInterstitialSingleton : NSObject

@property (assign) BOOL isReady;
@property (assign) BOOL isError;
@property (assign) id<PBInterstitialSingletonDelegate> delegate;

+ (id)shareInstanceWithPID:(NSString *)pid;
- (void) initInterstitialWithPlaceId:(NSString *)placeId;
- (BOOL)showInterstitialWithScale:(float)scale;

@end

@protocol PBInterstitialSingletonDelegate <NSObject>

@optional

// 弹出广告加载完成
- (void)pbInterstitialDidLoadAd:(PBInterstitial *)pbInterstitial;

// 弹出广告加载错误
- (void)pbInterstitial:(PBInterstitial *)pbInterstitial
loadAdFailureWithError:(PBRequestError *)requestError;

// 弹出广告打开完成
- (void)pbInterstitialDidPresentScreen:(PBInterstitial *)pbInterstitial;

// 弹出广告将要关闭
- (void)pbInterstitialWillDismissScreen:(PBInterstitial *)pbInterstitial;

// 弹出广告关闭完成
- (void)pbInterstitialDidDismissScreen:(PBInterstitial *)pbInterstitial;

@end
