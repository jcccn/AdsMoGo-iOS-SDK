//
//  AdMoGoNativeAdapterCustomEvent.h
//  AdsMoGoNative
//
//  Created by MOGO on 15-5-6.
//  Copyright (c) 2015年 MOGO. All rights reserved.
//

#import "AdMoGoNativeAdNetworkAdapter.h"

#define APPID_Native_F @"APPID-1"
#define APPID_Native_S @"APPID-2"

@interface AdMoGoNativeAdapterCustomEvent : AdMoGoNativeAdNetworkAdapter{
    BOOL isStop;
}
#pragma mark custom overwrite method
// return native custom type;
+ (AdMoGoNativeAdNetworkType)networkType;
// regiter native adapter class;
+ (void)registerClass:(id)clazz;
// request native ads;
- (void)loadAd:(int)adcount;
// show native ad;
-(void)attachAdView:(UIView*)view nativeData:(AdsMogoNativeAdInfo*)info;
// click native ad;
-(void)clickAd:(AdsMogoNativeAdInfo*)info;

#pragma mark custom  method
//停止请求广告
- (void)stopAd;
//请求广告超时
- (void)loadAdTimeOut:(NSTimer*)theTimer;

#pragma mark native adapter delegate call
-(void)adMoGoNativeCustom:(AdMoGoNativeAdNetworkAdapter *)adapter didReceiveAd:(NSArray*)adList;
-(void)adMoGoNativeCustom:(AdMoGoNativeAdNetworkAdapter *)adapter didFail:(int)errorCode;


@end
