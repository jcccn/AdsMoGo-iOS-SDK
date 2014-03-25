//
//  airADView.h
//  airADKit
//
//  Created by NSXiu on 4/17/12.
//  Copyright (c) 2012 airAD.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "airADViewDelegate.h"

#pragma mark -
#pragma mark Ad Size

#define AD_SIZE_320x54     CGSizeMake(320, 54)

typedef enum refreshMode {
  REFRESH_MODE_AUTO,
  REFRESH_MODE_MANUAL,
}ADRefreshMode;

/*!
 用来展示广告内容。
 */
@interface airADView : UIView
@property (nonatomic, assign) id<airADViewDelegate> delegate;

// 请求一条广告.
- (void)requestAd;

//设置ADRefreshMode可以设置当前BannerView的刷新方式.您可以选择方便的REFRESH_MODE_AUTO
//模式,这样BannerView内的广告会自动定时刷新.您也可以选择REFRESH_MODE_MANUAL模式,手动
//控制当前BannerView的广告内容刷新状态.
//默认: REFRESH_MODE_MANUAL
- (void)setRefreshMode:(ADRefreshMode)mode;

//设置IntervalTime主要影响REFRESH_MODE_AUTO时,广告刷新的周期.
//最小值为15.
//默认:15
- (void)setIntervalTime:(NSTimeInterval)interval;

@end

/*!
 设置公共参数的方法
 */
@interface airADView(Settings)

//设置AppId(可从登陆www.airad.com,创建新应用程序获得).
//一个应用程序只能设置也只会使用一个appId.
+ (void)setAppID:(NSString *)appId;

//设置是否开启地理位置信息
+ (void)setGPSOn:(BOOL)isOn;

@end