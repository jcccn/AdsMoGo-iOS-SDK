//
//  MixView.h
//  GuoHeMixiOSDev
//
//  Created by GuoHeSDK on 15/1/19.
//  Copyright (c) 2015年 智动果合信息科技(北京)有限责任公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#import "MIXViewDelegate.h"

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
// We need StoreKit to use the product view controller.
#import <StoreKit/StoreKit.h>
#endif

@interface MIXView:UIViewController

#if __IPHONE_OS_VERSION_MAX_ALLOWED >= 60000
<UIWebViewDelegate, SKStoreProductViewControllerDelegate>
#else
<UIWebViewDelegate>
#endif

// 初始化广告
+ (MIXView *)initWithID:(NSString *)adUnitId;

// 预加载广告 place参数：如果没有设置别的广告位的话，请填写默认的default或者nil即可
+ (void)preloadAdWithDelegate:(id)delegate withPlace:(NSString *)place;

// 展示广告
+ (void)showAdWithDelegate:(id)delegate;

// 根据广告位展示广告
+ (void)showAdWithDelegate:(id)delegate withPlace:(NSString *)place;

// 检查是否可以进行预加载
+ (BOOL)canServeAd:(NSString *)place;

// 检查预渲染是否完成
+ (BOOL)isPreloadFinish:(NSString *)place;

@end
