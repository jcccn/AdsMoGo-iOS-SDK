//
//  YouMiSpot.h
//  YouMiSDK
//
//  Created by 陈建峰 on 13-3-11.
//  Copyright (c) 2013年 YouMi Mobile Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#define YouMiNewSpot dNZuxGNLTMygsdTP
#define launchWithAppid uMtOYqNyPiZkBQVU
#define requestSpotADs XUVhTXiwQQPfRUmR
#define showSpotDismiss rAbMlMLxRKxHNVXv

// *** 重要 ***
// 当前提供一种尺寸的插播广告: 300*250 显示在屏幕正中央。
@interface YouMiNewSpot : NSObject

// 设置appid与appSecret
+(void)launchWithAppid:(NSString *)appid appSecret:(NSString*)appSecret;

//请求插播数据，传入NO为无积分插播。（暂时还不提供积分插播，所以请都传入NO）,callBack里面回调isFinish为YES即数据请求成功   clickCallBack为点击回调
+ (void)requestSpotADs:(BOOL)isRewarded callBack:(void(^)(BOOL isFinsh))callBack  clickCallBack:(void(^)(void))clickCallBack;

// 显示插播广告，有显示返回YES.没得显示返回NO
+ (BOOL)showSpotDismiss:(void (^)())dismiss;

@end
