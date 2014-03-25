//
//  GDTMobBannerView.h
//  GDTMobSDK
//
//  Created by chaogao on 13-11-5.
//  Copyright (c) 2013年 Tencent. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  For iPhone
 */
#define GDTMOB_AD_SIZE_320x50    CGSizeMake(320, 50)

@protocol GDTMobBannerViewDelegate <NSObject>

@optional

- (void)bannerViewMemoryWarning;

/**
 *  请求广告条数据成功后调用
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)bannerViewDidReceived;

/**
 *  请求广告条数据失败后调用
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)bannerViewFailToReceived:(int)errCode;

/**
 *  全屏广告弹出时调用
 *  详解:当广告栏被点击，弹出内嵌全屏广告时调用
 */
- (void)bannerViewDidPresentScreen;

/**
 *  全屏广告关闭时调用
 *  详解:当弹出内嵌全屏广告关闭，返回广告栏界面时调用
 */
- (void)bannerViewDidDismissScreen;

/**
 *  应用进入后台时调用
 *  详解:当点击应用下载或者广告调用系统程序打开，应用将被自动切换到后台
 */
- (void)bannerViewWillLeaveApplication;

@end

@interface GDTMobBannerView : UIView
{
    
}

/**
 *  父视图
 *  详解：[必选]需设置为显示广告的UIViewController
 */
@property (nonatomic, assign) UIViewController *currentViewController;

/**
 *  委托 [可选]
 */
@property(nonatomic, assign) id<GDTMobBannerViewDelegate> delegate;

/**
 *  测试模式 [可选]
 */
@property(nonatomic, assign) BOOL isTestMode;

/**
 *  广告刷新间隔 [可选]
 */
@property(nonatomic, assign) int interval;

/**
 *  GPS精准广告定位模式开关,默认Gps关闭
 *  详解：[可选]GPS精准定位模式开关，YES为开启GPS，NO为关闭GPS，建议设为开启，可以获取地理位置信息，提高广告的填充率，增加收益。
 */
@property(nonatomic, assign) BOOL isGpsOn;

/**
 *  构造方法
 *  详解：frame是广告banner展示的位置和大小，包含四个参数(x, y, width, height)
 *       appkey是应用id
 *       placementId是广告位id
 */
- (id) initWithFrame:(CGRect)frame appkey:(NSString *)appkey placementId:(NSString *)placementId;

/**
 *  拉取并展示广告
 */
- (void) loadAdAndShow;
@end
