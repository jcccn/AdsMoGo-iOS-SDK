//
//  LomarkAdView.h
//  LomarkAdDemo_nonASI_js
//
//  Created by DONSON on 14-2-18.
//  Copyright (c) 2014年 donson. All rights reserved.
//

#import <UIKit/UIKit.h>

//分享时没有标题的显示
#define DEFAULTTITLE @"点媒广告展示"
//是否为ipad
#define isIPad (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
//获取屏幕 bounds
#define MAINSCREEN [[UIScreen mainScreen] bounds]
//屏幕宽度
#define SCREENWIDTH MAINSCREEN.size.width
//屏幕高度
#define SCREENHEIGHT MAINSCREEN.size.height

//推荐使用的 banner 类型广告尺寸————————————————仅仅是推荐，开发集成的时候可以根据需要，自己定义大小
#define ADSIZE_1280_200 CGSizeMake(1280, 200)
#define ADSIZE_640_100 CGSizeMake(640, 100)
#define ADSIZE_480_75 CGSizeMake(480, 75)
#define ADSIZE_360_56 CGSizeMake(360, 56)
#define ADSIZE_320_50 CGSizeMake(320, 50)
#define ADSIZE_240_38 CGSizeMake(240, 38)

//浮动窗广告，推荐使用以下两个尺寸
#define FWSIZE_600_500 CGSizeMake(600, 500)
#define FWSIZE_300_250 CGSizeMake(300, 250)

typedef NS_ENUM(NSInteger, LomarkAdType) {
    LomarkAdTypeBanner = 1,         //横幅广告
    LomarkAdTypeFloatWindow =2,     //插屏广告
    LomarkAdTypeFullScreen = 3      //全屏广告
};

//应用分类信息
//1工具 2游戏 3阅读 4娱乐 5商旅 6财经 7汽车
//8女性（母婴 服饰 时尚） 9新闻 10生活 11体育 12其他
typedef NS_ENUM(NSInteger, AppCategory) {
    AppTool = 1,
    AppGame ,
    AppReading ,
    AppEntertainment ,
    AppBusinessTravel ,
    AppFinance ,
    AppCars ,
    AppFemale ,
    AppNews ,
    AppLive ,
    AppSports ,
    AppOther
};

@protocol LomarkAdViewDelegate;


@interface LomarkAdView : UIView
@property (nonatomic, assign) id <LomarkAdViewDelegate> delegate;
@property (nonatomic) BOOL isOpenOutSideApp;
@property (nonatomic) BOOL locationEnable;      // 定位的开关



/**
 @功能: 初始化广告
 @注意: 仅 LomarkAdTypeBanner 类型 autoTimeInterval 有效，并且时间为 15~60s，不在此范围内的一律设置为15s
 @参数: AdType:广告类型   appCategory:应用类型    size:生成广告的size  autoTimeInterval:每隔一段时间刷新一次广告（注意仅当 LomarkAdTypeBanner 有效）
 */
- (id)initWithAdType:(LomarkAdType)type appCategory:(AppCategory)appCategory appId:(NSString *)theAppId appKey:(NSString *)theAppKey appSecret:(NSString *)theAppSecret appName:(NSString *)appName size:(CGSize)size autoTimeInterval:(int)time;

//功能:开始广告展示请求，推荐初始化以后调用一次
- (BOOL)loadADAutoPlay;

//功能:单次调用广告，手动控制广告展示时使用
- (void)loadAD;

//功能:用于LomarkAdTypeBanner 类型广告,停止刷新
- (void)stopAutoLoadAD;

//功能：得到sdk版本号
+(NSString *)getLomarkSDKVersion;

@end

@protocol LomarkAdViewDelegate <NSObject>

@optional

//即将请求广告数据
- (void)adViewWillLoadAd:(UIView *)view;

//获取到可展示的广告数据，加载广告
- (void)adViewDidLoadAd:(UIView *)view;

//获取到不可展示的广告数据 或者 没有获取到可展示的广告数据
- (void)adView:(UIView *)view didFailToReceiveAdWithError:(NSError *)error;

//广告展示被点击，将要打开广告地址
-(void)adViewDidClicked:(UIView *)view;

//视图被移除
-(void)adViewDidRemoved:(UIView *)view;

//分享
-(void)adShareAction:(UIView *)view Info:(NSDictionary *)infoDict;

@end


