//
//  BaiduMobAdView.h
//  BaiduMobAdSdk
//
//  Created by jaygao on 11-9-6.
//  Copyright 2011年 Baidu. All rights reserved.
//
//  Baidu Mobads SDK Version 3.1
//

#import <UIKit/UIKit.h>
#import "BaiduMobAdDelegateProtocol.h"

#define kBaiduAdViewSizeDefaultWidth 320
#define kBaiduAdViewSizeDefaultHeight 48
#define kBaiduAdViewBanner320x48 CGSizeMake(320, 48)
#define kBaiduAdViewBanner468x60 CGSizeMake(468, 60)
#define kBaiduAdViewBanner728x90 CGSizeMake(728, 90)

#define kBaiduAdViewSquareBanner300x250 CGSizeMake(300, 250)
#define kBaiduAdViewSquareBanner600x500 CGSizeMake(600, 500)
/**
 *  投放广告的视图接口,更多信息请查看[百度移动联盟主页](http://munion.baidu.com)
 */

/**
 *  广告类型
 * 0 banner广告
 * 2 前贴片 BaiduMobAdViewTypeVABeforeVideo
 * 3 暂停视图 BaiduMobAdViewTypeVAPause
 * 4 切换视图 BaiduMobAdViewTypeVASwitchView
 */
typedef enum _BaiduMobAdViewType {
    BaiduMobAdViewTypeBanner = 0,
    BaiduMobAdViewTypeVABeforeVideo = 2,
    BaiduMobAdViewTypeVAPause = 3,
    BaiduMobAdViewTypeVASwitchView = 4    
} BaiduMobAdViewType;


@interface BaiduMobAdView : UIView {
    @private
    UIColor                     *_textColor;
    UIColor                     *_backgroundColor;
    CGFloat                      _alpha;    
    
    NSString                     *_aduTag;
    id<BaiduMobAdViewDelegate>  _delegate;
}

///---------------------------------------------------------------------------------------
/// @name 属性
///---------------------------------------------------------------------------------------

/**
 *  委托对象
 */
@property (nonatomic ,assign)   id<BaiduMobAdViewDelegate>  delegate;

/**
 *  广告类型
 */
@property (nonatomic) BaiduMobAdViewType AdType;

/**
 *  设置／获取当前广告（文字）的文本颜色
 */
@property (nonatomic, retain)   UIColor                     *textColor;


/**
 *  - 设置是否需要启动SDK的自动轮播机制
 *  - autoplayEnabled设置为YES（默认值）时，SDK会自动根据一定的时间间隔播放不同的广告。开发者无须编写额外的代码控制广告的更新和展示。request接口不可用
 *  - autoplayEnabled设置为NO（默认值）时，SDK不会主动调用第一个广告的展示，并产生回调函数 [BaiduMobAdViewDelegate willDisplayAd:]或者[BaiduMobAdViewDelegate failedDisplayAd:],
 *    开发者需要在回调函数[BaiduMobAdViewDelegate willDisplayAd:]或者[BaiduMobAdViewDelegate failedDisplayAd:]中调用request接口请求一次广告展示
 */

@property (nonatomic)           BOOL                        autoplayEnabled;

/**
 *  设置/获取广告位id
 */
@property (nonatomic, copy) NSString                    *AdUnitTag;

/**
 *  SDK版本
 */
@property (nonatomic, readonly) NSString                    *Version;

/**
 *  - 开始广告展示请求,会触发所有资源的重新加载，推荐初始化以后调用一次
 *  - 会驱动一次广告展示，回调函数willDisplayAd或者failedDisplayAd中调用[BaiduMobAdView request]接口请求一次广告展示
 *  
 */
- (void) start;

/**
 *  - 高级接口
 *  - 请求广告展示，在[BaiduMobAdView autoplayEnabled]设置为NO时使用。
 *
 */
- (void) request;


@end

