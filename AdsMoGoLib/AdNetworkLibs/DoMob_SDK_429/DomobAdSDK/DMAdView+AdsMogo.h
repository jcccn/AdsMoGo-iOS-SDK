//
//  DMAdView+AdsMogo.h
//  DomobAdSDK
//
//  Copyright (c) 2014年 Domob Ltd. All rights reserved.
//

@interface DMAdView (AdsMogo)

//开始请求Domob广告
- (void)domobAdLoad;

//聚合认为展示了Domob的广告则调用此方法
- (void)domobAdImpression;

//聚合认为Domob的广告结束了则调用此方法
- (void)domobAdDismiss;

@end
