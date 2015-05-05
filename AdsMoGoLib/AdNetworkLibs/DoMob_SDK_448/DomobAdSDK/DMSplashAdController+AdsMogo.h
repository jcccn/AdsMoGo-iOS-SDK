//
//  DMSplashAdController+AdsMogo.h
//  DomobAdSDK
//
//  Copyright (c) 2014年 Domob Ltd. All rights reserved.
//

#import "DMSplashAdController.h"

@interface DMSplashAdController (AdsMogo)

//开始请求Domob广告
- (void)domobSplashAdLoad;

//聚合认为展示了Domob的广告则调用此方法
- (void)domobSplashAdImpression;

//聚合认为Domob的广告结束了则调用此方法
- (void)domobSplashAdDismiss;

@end
