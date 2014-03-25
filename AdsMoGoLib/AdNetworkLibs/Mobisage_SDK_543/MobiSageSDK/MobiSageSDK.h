//
//  MobiSageSDK.h
//  MobiSageSDK
//
//  Created by sdk team on 2013/01/22.
//  Copyright (c) 2014 adsage. All rights reserved.

#pragma mark - 当前版本支持的广告尺寸

typedef struct StructBannerSize {
    int sizeType;
    CGSize size;
}BannerSize;

#pragma mark - Banner_Size_List
extern const BannerSize Ad_320X50;  //for iphone

extern const BannerSize Ad_300X250; //for ipad
extern const BannerSize Ad_468X60;  //for ipad
extern const BannerSize Ad_728X90;  //for ipad

typedef struct StructPosterSize {
    int sizeType;
    CGSize size;
}PosterSize;

#pragma mark - Poster_Size_List
extern const PosterSize Poster_300X250; //for iphone
extern const PosterSize Poster_320X480; //for iphone

extern const PosterSize Poster_640X960; //for ipad
extern const PosterSize Poster_600X500; //for ipad

#pragma mark - 横幅广告相关枚举变量

/*广告切换动画枚举*/
typedef enum
{
    Random      = 1,        //    随机
    Fade        = 2,        //    淡入淡出
    FlipL2R     = 3,        //    水平翻转从左到右
    FlipT2B     = 4,        //    水平翻转从上到下
    CubeT2B     = 5,        //    立体翻转从左到右
    CubeL2R     = 6,        //    立体翻转从上到下
    Ripple      = 7,        //    水波纹效果
    PageCurl    = 8,        //    翻页效果从下到上
    PageUnCurl  = 9         //    翻页效果从上到下
    
} MobiSageAnimeType;        //    广告切换动画效果

/*广告刷新周期枚举*/
typedef enum
{
    Ad_NO_Refresh = 0,        //    不轮显
    Ad_Refresh_15 = 1,        //    15秒
    Ad_Refresh_20 = 2,        //    20秒
    Ad_Refresh_25 = 3,        //    25秒
    Ad_Refresh_30 = 4,        //    30秒
    Ad_Refresh_60 = 5         //    60秒
    
}MSAdRefreshInterval;         //    广告自动轮显时间


#pragma mark - 开屏广告方向
#define MobiSage_Orientation_Portrait           1
#define MobiSage_Orientation_Landscape          2

#pragma mark - MobiSageManager

@interface MobiSageManager : NSObject

/**    
 *  @brief 获得MobiSage平台管理单例
 */
+(MobiSageManager*)getInstance;

/**    
 *  设置publisherID  
 *  @param publisherID	AC平台分配给应用的id
 */
- (void)setPublisherID:(NSString *)publisherID;

/**    
 *  @brief 设置应用分发渠道
 *  @param deployChannel	分发渠道名称 
 */
- (void)setDeployChannel:(NSString *)deployChannel;

/**
 *  @brief 设置是否在应用内打开app store（使用store kit）
 *  @param flag YES在应用内打开，否则在应用外打开
 *  @note  在IOS7下，只支持横屏的应用，打开app store应用内购，应用会崩溃
 */
- (void)showStoreInApp:(BOOL)flag;
@end

#pragma mark - MobiSageAdBanner

@class MobiSageAdBanner;

@protocol MobiSageAdBannerDelegate <NSObject>

@optional

/**
 *  @brief 指定adBanner点击后，弹出应用内页面的宿主viewController
 *  @return 需要用来宿主页面的viewController
 */
- (UIViewController *)viewControllerToPresent;

/**
 *  @brief adBanner被点击
 *  @param adBanner
 */
- (void)mobiSageAdBannerClick:(MobiSageAdBanner*)adBanner;

/**
 *  @brief adBanner被关闭
 *  @param adBanner
 */
- (void)mobiSageAdBannerClose:(MobiSageAdBanner*)adBanner;

/**
 *  @brief adBanner请求成功并展示广告
 *  @param adBanner
 */
- (void)mobiSageAdBannerSuccessToShowAd:(MobiSageAdBanner*)adBanner;

/**
 *  @brief adBanner请求失败
 *  @param adBanner
 */
- (void)mobiSageAdBannerFaildToShowAd:(MobiSageAdBanner*)adBanner;

/**
 *  @brief adBanner被点击后弹出LandingPage
 *  @param adBanner
 */
- (void)mobiSageAdBannerPopADWindow:(MobiSageAdBanner*)adBanner;

/**
 *  @brief adBanner弹出的LandingPage被关闭
 *  @param adBanner
 */
- (void)mobiSageAdBannerHideADWindow:(MobiSageAdBanner*)adBanner;

@end

@interface MobiSageAdBanner : UIView

/**
 *  @brief 横幅广告所使用的委托
 */
@property(nonatomic, assign) id<MobiSageAdBannerDelegate> delegate;

/**    
 *  @brief 初始化，并设置广告尺寸
 *  @param adSize 广告视图大小  
 *  @param delegate 该广告所使用的委托
 */
- (id)initWithAdSize:(BannerSize)adSize
        withDelegate:(id<MobiSageAdBannerDelegate>)delegate;

/**    
 *  @brief 设置广告刷新间隔时间
 *  @param interval 广告刷新间隔时间，单位是“秒” 
 */
- (void)setInterval:(MSAdRefreshInterval)interval;

/**    
 *  @brief 设置多个广告之间过渡（切换）效果
 *  @param switchAnimeType	多个广告之间过渡（切换）效果  
 */
- (void)setSwitchAnimeType:(MobiSageAnimeType)switchAnimeType;

@end

#pragma mark - MobiSageAdPoster

@class MobiSageAdPoster;

@protocol MobiSageAdPosterDelegate <NSObject>
@optional
/**
 *  @brief AdPoster被点击
 *  @param adPoster
 */
- (void)mobiSageAdPosterClick:(MobiSageAdPoster*)adPoster;

/**
 *  @brief AdPoster被关闭
 *  @param adPoster
 */
- (void)mobiSageAdPosterClose:(MobiSageAdPoster*)adPoster;

/**
 *  @brief AdPoster请求成功
 *  @param adPoster
 */
- (void)mobiSageAdPosterSuccessToRequest:(MobiSageAdPoster*)adPoster;

/**
 *  @brief AdPoster请求失败
 *  @param adPoster
 */
- (void)mobiSageAdPosterFaildToRequest:(MobiSageAdPoster*)adPoster;

@end


@interface MobiSageAdPoster : NSObject

/**
 *  @brief 插屏广告所使用的委托
 */
@property(nonatomic, assign) id<MobiSageAdPosterDelegate> delegate;

/**    
 *  @brief 初始化，并设置广告尺寸
 *  @param adSize 广告视图大小  
 *  @param delegate 该广告所使用的委托
 */
- (id)initWithAdSize:(PosterSize)adSize
        withDelegate:(id<MobiSageAdPosterDelegate>)delegate;

/**
 *  @brief Poster广告是否处于展示状态
 */
@property(nonatomic, readonly) BOOL adPosterShow;

/**
 *  Poster广告请求是否成功
 *  @note 可以用该属性来判断是否可以展示
 */
@property(nonatomic, readonly) BOOL isRequestSuccess;

/**
 *  展示广告
 */
- (void)show;
@end

#pragma mark - MobiSageAdSplash

@class MobiSageAdSplash;
@protocol MobiSageAdSplashDelegate <NSObject>
@optional
/**
 *  AdSplash展示成功
 *  @param adSplash
 */
- (void)mobiSageAdSplashSuccessToShow:(MobiSageAdSplash*)adSplash;

/**
 *  AdSplash展示失败
 *  @param adSplash
 */
- (void)mobiSageAdSplashFaildToRequest:(MobiSageAdSplash*)adSplash;

/**
 *  AdSplash被关闭
 *  @param adSplash
 */
- (void)mobiSageAdSplashClose:(MobiSageAdSplash*)adSplash;
@end

@interface MobiSageAdSplash : NSObject

/**
 *  开屏广告
 *  可以自定义广告方向
 */
@property(nonatomic, assign) id<MobiSageAdSplashDelegate> delegate;

/**
 *  初始化，并设置广告展示方向和背景
 *  @param Orientation  广告展示方向
 *  @param background   广告背景设置
 *  @param delegate     该广告所使用的委托
 */
- (id)initWithOrientation:(NSInteger)screenOrientation
               background:(UIColor*)bgColor
             withDelegate:(id<MobiSageAdSplashDelegate>)delegate;

/**
 * 开屏广告开始准备展示
 */
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
 *  @param delegate	设置委托
 */
- (id)initWithDelegate:(id<MobiSageRecommendDelegate>)delegate;

/**
 *  初始化应用推荐功能
 *  @param delegate	设置委托
 *  @param image	设置点击图片
 */
- (id)initWithDelegate:(id<MobiSageRecommendDelegate>)delegate
                andImg:(UIImage*)image;

/**
 *  弹出应用推荐页面
 */
- (void)OpenAdSageRecmdModalView;

@end

//表格式荐计划
@interface MSRecommendContentView : UIView

/**
 *  构造一个表格形式的荐计划
 *  @param delegate	表格荐计划的委托
 *  @param iWidth	表格荐计划视图的宽度
 *  @param iAdCount	表格荐计划展示的广告个数;每个广告高度是157,开发者根据选择的广告个数计算相应的高度
 */
- (id)initWithdelegate:(id<MobiSageRecommendDelegate>)delegate
                 width:(float)width
               adCount:(NSInteger)iAdCount;
@end
