//
//  MixViewDelegate.h
//  GuoHeMixiOSDev
//
//  Created by GuoHeSDK on 15/1/19.
//  Copyright (c) 2015年 智动果合信息科技(北京)有限责任公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIXView;

typedef enum {
    MIXCacheNotFinish = -101,   // 广告未下载完成
    MIXCacheFailLoad,           // 广告加载失败
} MIXErrorCode;

@protocol MIXViewDelegate <NSObject>
@required

/** MIXViewDelegate
 *  协议中的参数含义
 *
 *  @param view      : 初始化得到的MIXView的单例对象
 *  @param place     : 广告位
 *  @param errorCode : 状态码
 */

@optional

// 预加载广告完成时调用
- (void)mixViewDidCacheAd:(MIXView *)view withPlace:(NSString *)place;

// 预加载广告失败时调用
- (void)mixViewDidFailToCacheAdWithError:(MIXErrorCode)errorCode withPlace:(NSString *)place;

// 根据广告位展示广告完成时调用
- (void)mixViewDidShowAd:(MIXView *)view withPlace:(NSString *)place;




// 已显示广告，点击广告内容时调用
- (void)mixViewDidClickedAd:(MIXView *)view withPlace:(NSString *)place;

// 已显示广告，点击广告的关闭按钮调用
- (void)mixViewDidClosed:(MIXView *)view withPlace:(NSString *)place;




// 展示广告失败时调用
- (void)mixViewDidFailToShowAd:(MIXView *)view withPlace:(NSString *)place;

// 没有广告可用时调用
- (void)mixViewNoAdWillPresent:(MIXView *)view withPlace:(NSString *)place;

@end
