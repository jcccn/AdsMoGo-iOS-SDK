//
//  airADViewDelegate.h
//  airADKit
//
//  Created by Qian Kun on 12/26/11.
//  Copyright (c) 2011 MitianTech. All rights reserved.
//

#import <Foundation/Foundation.h>
@class airADView;

@protocol airADViewDelegate <NSObject>

@optional
#pragma mark Ad Delegate

// 当接收到一个广告的时候，会发送该请求。广告在后台会自动刷新.以此作为一次成功请求。
- (void)airADDidReceiveAD:(airADView*)view;

//当遇到以下情况,会发送此请求:
//1.IP地址非法.在一些无法访问airAD广告的地区,会返回此信息.
//2.网络无相应.
//3.传输参数非法,比如,非正确的App_ID.
- (void)airADView:(airADView *)view didFailToReceiveAdWithError:(NSError *)error;

//当Banner显示完毕时,发送此请求.以此作为广告完成一次有效展示.
- (void)airADImpressionDidFinish:(airADView *)adView;

//当广告完全载入完毕时,发送此请求.以此作为广告完成一次有效点击.
- (void)airADClickDidFinish:(airADView *)adView;

#pragma mark ContentShow Delegate

//广告点击后,展示对应触发事件
- (void)airADWillShowContent:(airADView *)adView;
- (void)airADWillHideContent:(airADView *)adView;
- (void)airADDidHideContent:(airADView *)adView;

@end
