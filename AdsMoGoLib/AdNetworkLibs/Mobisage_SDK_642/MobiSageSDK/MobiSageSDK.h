//
//  MobiSageSDK.h
//  Adv_SDK_Demo
//
//  Created by yunjie on 13-4-26.
//  Copyright (c) 2013年 stick. All rights reserved.
//

// version 6.4.2

#define MS_Test_PublishID        @"zczNHqJZQNf+2euXSg=="
#define MS_Test_SlotToken_Banner @"hYSFVuoSCJ+2kaPfAhZeuAmj"//横幅广告位
#define MS_Test_SlotToken_Poster @"TE1MnyPbwVZ/WGoWy9+XccBr"//全屏广告位
#define MS_Test_SlotToken_Splash @"w8LDEKxUTtnw1+WZRFAY/k/n"//开屏广告位
#define MS_Test_SlotToken_Native @"k5KTQPwEHomgh7XJFABIrh+9"//信息流广告位
#define MS_Test_SlotToken_Recommend @"19bXBLhAWs3kw/GNUEQM6lv0"//荐计划

#define MS_Test_Audit_Flag   @"IOS_AppStore_v6.4.2"



#define Float_size_0                            (0)       // for iPhone iTouch 300*250 iPad 600*500
#define Float_size_3                            (3)       // for iPhone iTouch 320*480  iPad 640*960

#pragma Splash Orientation
#define MS_Orientation_Portrait                 (1)
#define MS_Orientation_Landscape                (2)


//广告轮换方式
typedef enum
{
    noAnime     = -1,
    Random      = 1,
    Fade        = 2,
    CubeT2B     = 5,
    CubeL2R     = 6,
} MobiSageAnimeType;

#pragma Ad_Interval
typedef enum
{
    Ad_NO_Refresh = 0,
    Ad_Refresh_30 = 4,
    Ad_Refresh_60 = 5,
}MSAdRefreshInterval;

typedef enum : NSUInteger {
    MSAdBannerType_default  = 0,   //for default , iPhone = MSAdBannerType_iPhone, iPad = MSAdBannerType_iPad
    MSAdBannerType_iPhone   = 1,   //for iPhone 320X50  iPhone6 375*50 iPhone6 Plus 414*50
    MSAdBannerType_iPad     = 2 ,  //for iPad      728X90
    MSAdBannerType_big      = 3,   //for iPhone 320X50  iPhone6 375*58 iPhone6 Plus 414*64
} MSAdBannerType;

@interface MobiSageManager : NSObject
{
    
}

/**
 *  @brief 获得MobiSage平台管理单例
 */
+ (MobiSageManager*)getInstance;

/**
 *  @brief 设置publisherID
 *  @param publisherID 开发者平台分配给应用的id
 *  @param flag 审核标识，区分大小写
 */
- (void)setPublisherID:(NSString*)publisherID auditFlag:(NSString*)flag;

/**
 *  @brief 设置应用分发渠道
 *  @param deployChannel 分发渠道名称
 *  @param flag 审核标识，区分大小写
 */
- (void)setPublisherID:(NSString*)publisherID deployChannel:(NSString*)deployChannel auditFlag:(NSString*)flag;

/**
 *  @brief 设置是否在应用内打开app store（使用store kit）
 *  @param flag YES在应用内打开，否则在应用外打开
 */
- (void)showStoreInApp:(BOOL)flag;

/**
 *  @brief 设置是否在应用内打开GPS
 *  @param flag YES在应用内打开，NO关闭
 *  @note  默认GPS是打开状态
 */
- (void)setEnableLocation:(BOOL)flag;

/**
 *  @brief 销毁管理单例
 *  @note  单例的生成和销毁动作占用资源较大，不建议经常调用
 */
+ (void)destroyInstance;
@end

#pragma mark -
#pragma mark MobiSageBanner


@class MobiSageBanner;

@protocol MobiSageBannerDelegate

@optional

/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site, in app purchase时需要使用当前广告所在的控制器。
 * 返回：一个视图控制器对象
 * 说明：如果没有实现此回调，将使用keyWindow.rootViewController
 */
- (UIViewController*)viewControllerToPresent;


/**
 *  adBanner被点击
 *  @param adBanner
 */
- (void)mobiSageBannerClick:(MobiSageBanner*)adBanner;


/**
 *  adBanner请求成功并展示广告
 *  @param adBanner
 */
- (void)mobiSageBannerSuccessToShowAd:(MobiSageBanner*)adBanner;

/**
 *  adBanner请求失败
 *  @param adBanner
 */
- (void)mobiSageBannerFaildToShowAd:(MobiSageBanner*)adBanner withError:(NSError*) error;

/**
 *  adBanner被点击后弹出LandingPage
 *  @param adBanner
 */
- (void)mobiSageBannerPopADWindow:(MobiSageBanner*)adBanner;

/**
 *  adBanner弹出的LandingPage被关闭
 *  @param adBanner
 */
- (void)mobiSageBannerHideADWindow:(MobiSageBanner*)adBanner;


@end


@interface MobiSageBanner : UIView

@property(nonatomic, assign) id<MobiSageBannerDelegate> delegate;


- (id)initWithDelegate:(id<MobiSageBannerDelegate>)delegate
             slotToken:(NSString *)slotToken;

- (id)initWithDelegate:(id<MobiSageBannerDelegate>)delegate
                adType:(MSAdBannerType)type
             slotToken:(NSString *)slotToken;

- (id)initWithDelegate:(id<MobiSageBannerDelegate>)delegate
                adType:(MSAdBannerType)type
             slotToken:(NSString *)slotToken
          intervalTime:(MSAdRefreshInterval)intervalTime
       switchAnimeType:(MobiSageAnimeType)animeType;


- (void)setAdType:(MSAdBannerType)type
        slotToken:(NSString *)slotToken
     intervalTime:(MSAdRefreshInterval)interval
  switchAnimeType:(int)animeType;

@end

#pragma mark -
#pragma mark MobiSageFloatWindow

@class MobiSageFloatWindow;

@protocol MobiSageFloatWindowDelegate

@optional

- (void)mobiSageFloatClick:(MobiSageFloatWindow*)adFloat;

- (void)mobiSageFloatClose:(MobiSageFloatWindow*)adFloat;

- (void)mobiSageFloatSuccessToRequest:(MobiSageFloatWindow*)adFloat;

- (void)mobiSageFloatFaildToRequest:(MobiSageFloatWindow*)adFloat withError:(NSError*) error;
@end


@interface MobiSageFloatWindow : UIView

@property(nonatomic, assign) id<MobiSageFloatWindowDelegate> delegate;

// 使用 Float_size_0
- (id)initWithDelegate:(id<MobiSageFloatWindowDelegate>)delegate
             slotToken:(NSString *)slotToken;

- (id)initWithAdSize:(NSUInteger) adSize
            delegate:(id<MobiSageFloatWindowDelegate>)delegate
           slotToken:(NSString *)slotToken;

- (void)setAdSize:(NSUInteger)adSize slotToken:(NSString *)slotToken;

// 展示插屏广告，建议在收到成功回调时使用
- (void)showAdvView;

@end


#pragma mark -
#pragma mark MobiSageSplash



@class MobiSageSplash;

@protocol MobiSageSplashDelegate<NSObject>
@optional


/**
 *  AdSplash展示成功
 *  @param adSplash
 */
- (void)mobiSageSplashSuccessToShow:(MobiSageSplash*)adSplash;

/**
 *  AdSplash展示失败
 *  @param adSplash
 */
- (void)mobiSageSplashFaildToRequest:(MobiSageSplash*)adSplash withError:(NSError*) error;

/**
 *  AdSplash被点击
 *  @param adSplash
 */
- (void)mobiSageSplashClick:(MobiSageSplash*)adSplash;

/**
 *  AdSplash被关闭
 *  @param adSplash
 */
- (void)mobiSageSplashClose:(MobiSageSplash*)adSplash;
@end

@interface MobiSageSplash : UIView
{
    id<MobiSageSplashDelegate> adviewDelegate;
}

@property (nonatomic, assign) id<MobiSageSplashDelegate> delegate;

- (id)initWithOrientation:(NSInteger)screenOrientation
               background:(UIColor*)bgColor
             withDelegate:(id<MobiSageSplashDelegate>)delegate
                slotToken:(NSString *)slotToken;

- (void)setOrientation:(NSInteger)orientation
            background:(UIColor*)bgColor
             slotToken:(NSString *)slotToken;

- (void)startSplash;
@end

@interface MobiSageRTSplash : MobiSageSplash


- (id)initWithOrientation:(NSInteger)screenOrientation
               background:(UIColor*)bgColor
             withDelegate:(id<MobiSageSplashDelegate>)delegate
                slotToken:(NSString *)slotToken;

- (void)startSplash;

@end

#pragma mark - 荐计划广告

@protocol MobiSageRecommendDelegate <NSObject>
@required
/**
 *  嵌入应用推荐界面对象中实现Delegate
 */
- (UIViewController *)viewControllerForPresentingModalView;


@optional
/**
 *  应用推荐界面打开时调用
 */
- (void)MobiSageWillOpenRecommendModalView;
/**
 *  应用推荐界面打开失败时调用
 */
- (void)MobiSageFailToOpenRecommendModalView;
/**
 *  应用推荐界面关闭时调用
 */
- (void)MobiSageDidCloseRecommendModalView;

@end

//弹出式荐计划
@interface MobiSageRecommendView : UIControl
/**
 *  初始化应用推荐功能
 *  @param delegate	  设置委托
 *  @param pid        设置publishID
 *  @param slotToken  设置荐计划广告位
 */
- (id)initWithDelegate:(id<MobiSageRecommendDelegate>)delegate
             publishID:(NSString *)pid
             slotToken:(NSString *)slotToken;
/**
 *  弹出应用推荐页面
 */
- (void)OpenAdSageRecmdModalView;

@end
