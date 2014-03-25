//
//  MobWinBannerView.h
//  MobWinSDK
//
//  Created by Guo Zhao on 10/28/11.
//  Copyright (c) 2012 Tencent. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    MobWINBannerSizeIdentifierUnknow    = 0,
    MobWINBannerSizeIdentifier320x50      = 1, // iPhone/iPod Touch广告
    MobWINBannerSizeIdentifier300x250    = 2, // iPad 页首条幅广告
    MobWINBannerSizeIdentifier468x60     = 3, // iPad 标准条幅广告
    MobWINBannerSizeIdentifier728x90     = 4, // iPad 中等矩形广告
    MobWINBannerSizeIdentifier320x25     = 5  // iPhone/iPod Touch MiniBanner广告
} MobWinBannerSizeIdentifier;

#pragma mark MobWinBannerViewDelegate

@protocol MobWinBannerViewDelegate <NSObject>
@optional

// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived;

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(int)errCode;

// 全屏广告弹出时调用
//
// 详解:当广告栏被点击，弹出内嵌全屏广告时调用
- (void)bannerViewDidPresentScreen;

// 全屏广告关闭时调用
//
// 详解:当弹出内嵌全屏广告关闭，返回广告栏界面时调用
- (void)bannerViewDidDismissScreen;

// 应用进入后台时调用
//
// 详解:当点击下载或者地图类型广告时，会调用系统程序打开，
// 应用将被自动切换到后台
- (void)bannerViewWillLeaveApplication;

@end

@interface MobWinBannerView : UIView

#pragma mark MobWinBannerView properties

// 应用鉴权ID
// 详解：[必须设定]绑定应用的应用鉴权ID
@property (nonatomic, copy) NSString *adUnitID;

// 父视图
// 详解：[必选]需设置为显示广告的UIViewController
@property (nonatomic, assign) UIViewController *rootViewController;

// GPS精准广告定位模式开关
// 默认Gps模式开启 adGpsMode == NO
//
// 详解：[可选]精准定位模式开关，YES为精准定位模式，NO为非精准定位模式，建议设为精准定位模式，可以获取地域精准定向广告，提高广告的填充率，增加收益。
@property (nonatomic, assign) BOOL adGpsMode;

// 广告条尺寸
// 详解：[必选]需设置显示广告内容的广告条尺寸
@property (nonatomic, assign) MobWinBannerSizeIdentifier adSizeIdentifier;

// 委托
@property(nonatomic, assign) id<MobWinBannerViewDelegate> delegate;

// 聚合KEY
// 聚合平台鉴别ID, 与开发者无关
@property(nonatomic, copy) NSString *adIntegrateKey;

#pragma mark MobWinBannerView functions

// 广告条初始化请求
//
// 详解：[必选]生成广告单体
+ (MobWinBannerView*)instance;

// 广告请求发起方法
//
// 详解：[必选]发起拉取广告请求
- (void)startRequest;

// 广告请求停止方法
//
// 详解：[必选]停止拉取广告请求
- (void)stopRequest;

@end
