//
//  MiidiAdSpot.h
//  MiidiSDKApp
//
//  Created by xuyi on 14-2-18.
//  Copyright (c) 2014年 miidi. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MiidiAdSpot : NSObject

/*
 * 请求插屏广告数据 ,complete block: error不为空，请求失败。error为空，请求成功
 */
+ (void) requestMiidiBasSpotAd :(void (^)(NSError *))complete;

/*
 * 当isSpotAdReady返回true的时候，才显示插播广告
 */
+  (BOOL) isMiidiBasSpotAdReady;


//默认5s显示关闭按钮
/**
 *  显示插屏广告,默认5s显示close按钮
 *
 *  @param hostViewController 可以直接传nil
 *  @param dismiss            block: close插屏通知
 *  @param time               自定义延迟延时close按钮时间
 */
+ (void)displayMiidiBasSpotAdWithBlock:(UIViewController*)hostViewController withMiidiBasBlock:(void(^)())dismiss;
+ (void)displayMiidiBasSpotAdWithBlock:(UIViewController*)hostViewController withMiidiBasBlock:(void(^)())dismiss withMiidiBasTime:(NSTimeInterval)time;

@end
