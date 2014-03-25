//
//  AderInterstitialDelegate.h
//
//  Copyright 2013 renren Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

//插屏广告delegate
@protocol AderInterstitialDelegate <NSObject>

@optional

#pragma mark 广告请求相关
//插屏广告请求成功，可以显示
- (void)aderInterstitialDidReceiveAd;

/*
 接受SDK返回的错误报告
 code 1: 参数错误
 code 2: 服务端错误
 code 3: 应用被冻结
 code 4: 无合适广告
 code 5: 应用账户不存在
 code 6: 频繁请求
 code 7: 广告为空
 code 101: 网络请求失败
 case 102: 广告关闭
 */
//插屏广告请求发生异常 
- (void)aderInterstitialDidReceiveError:(NSError *)error;

#pragma mark 广告显示相关
//将要显示插屏广告
- (void)aderInterstitialWillPresentScreen;

//将要移除插屏广告
- (void)aderInterstitialWillDismissScreen;

//插屏广告已被移除
- (void)aderInterstitialDidDismissScreen;

//开启定位 默认值YES
- (BOOL)aderInterstitialOpenLocation;

@end
