//
//  MIXViewDelegate.h
//  GuoHeMixiOSDev
//
//  Created by Lynn Woo on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIXView;
// 消费结果状态码
typedef enum {
    // 广告未下载完成
    MIXCacheNotFinish = -101,
    // 广告加载失败
    MIXCacheFailLoad,
    
} MIXErrorCode;

@protocol MIXViewDelegate <NSObject>

@required

@optional
//加载推广橱窗失败时调用
- (void)mixViewDidFailToShowAd:(MIXView *)view withPlace:(NSString *)place;

//加载推广橱窗成功时调用
- (void)mixViewDidShowAd:(MIXView *)view withPlace:(NSString *)place;

//推广橱窗点击出现内容窗口时调用
- (void)mixViewDidClickedAd:(MIXView *)view withPlace:(NSString *)place;

//推广橱窗的关闭按钮被点击时调用
- (void)mixViewDidClosed:(MIXView *)view withPlace:(NSString *)place;

//没有推广橱窗返回时调用
- (void)mixViewNoAdWillPresent:(MIXView *)view withPlace:(NSString *)place;

//预加载广告完成时调用
- (void)mixViewDidCacheAd:(MIXView *)view withPlace:(NSString *)place;

//预加载广告失败时调用
- (void)mixViewDidFailToCacheAdWithError:(MIXErrorCode)errorCode withPlace:(NSString *)place;

@end
