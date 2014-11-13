//
//  YouMiSpot.h
//  YouMiSDK
//
//  Created by 陈建峰 on 13-3-11.
//  Copyright (c) 2013年 YouMi Mobile Co. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "spotconfuse.h"
// *** 重要 ***
// 当前提供一种尺寸的插屏广告: 300*250 显示在屏幕正中央。
@interface YouMiNewSpot : NSObject

// 设置appid与appSecret
+(void)launchWithAppid:(NSString *)appid appSecret:(NSString*)appSecret;

// 显示插屏广告，有显示返回YES.没得显示返回NO，dismiss为广告点关闭后的回调。
+ (BOOL)showSpotDismiss:(void (^)())dismiss;


// 点击插屏广告的回调
+ (void)clickSpotAction:(void (^)())callback;


// 读出spot sdk版本
+ (NSString *)getUniversalSDKVersion;

@end
