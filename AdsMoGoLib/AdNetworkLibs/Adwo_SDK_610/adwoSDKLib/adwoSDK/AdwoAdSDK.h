//
//  AdwoAdSDK.h
//  Adwo SDK 6.1
//
//  Created by zenny_chen on 12-8-17.
//  Copyright (c) 2011～2013 Adwo, Inc All rights reserved.
//
/////////////////////// NOTES /////////////////////////////

/**
 * !!IMPORTANT!!
 * 本次SDK将仅支持XCode5.0或更高版本，支持iOS 6.0，并且最低支持iOS 5.0系统。
 * 注意！本SDK以及附属的Demo属于本公司机密，未经许可不得擅自发布！
 * Release Notes：
 * 添加了Social.framework框架，此框架必须设置为可选的（Optional），否则如果以默认的Required加入会导致iOS6.0以下系统运行崩溃。
 * 在AWAdViewDelegate中增加了必须实现的adwoGetBaseViewController接口。
 
 * 必须添加的框架：
 * AddressBook.framework
 * AdSupport.framework
 * AudioToolbox.framework
 * AVFoundation.framework
 * CoreMedia.framework
 * CoreMotion.framework
 * CoreTelephony.framework
 * EventKit.framework
 * MessageUI.framework
 * PassKit.framework
 * QuartzCore.framework
 * StoreKit.framework
 * SystemConfiguration.framework
 * Social.framework（将required变为optional）
*/

#import <UIKit/UIKit.h>


// Adwo Ad SDK版本号的数值表示
#define ADWO_SDK_VERSION                    0x61

// Adwo Ad SDK版本号的字符串表示
#define ADWO_SDK_VERSION_STRING             @"6.1"


// 如果你的程序工程中没有包含CoreLocation.frameowrk，
// 那么把下面这个宏写到你的AppDelegate.m或ViewController.m中类实现的上面空白处。
// 如果已经包含了CoreLocation.framework，那么请不要在其它地方写这个宏。
// 注意：这个宏不能写在类中，也不能写在函数或方法中。详细用法请参考AdwoSDKBasic这个Demo～
#define ADWO_SDK_WITHOUT_CORE_LOCATION_FRAMEWORK(...)    \
@interface CLLocationManager : NSObject             \
                                                    \
@end                                                \
                                                    \
@implementation CLLocationManager                   \
                                                    \
@end                                                \
                                                    \
double kCLLocationAccuracyBest = 0.0;

// 如果你不想添加PassKit.framework，那么需要在你的ViewController.m或AppDelegate.m中加入这个宏
// 详细用法请参考AdwoSDKBasic这个Demo～
#define ADWO_SDK_WITHOUT_PASSKIT_FRAMEWORK(...)     \
@interface PKAddPassesViewController : NSObject     \
@end                                                \
                                                    \
@implementation PKAddPassesViewController           \
@end                                                \
                                                    \
@interface PKPass : NSObject                        \
                                                    \
@end                                                \
                                                    \
@implementation PKPass                              \
                                                    \
@end


#define ADWOSDK_DUMMYLAUNCHINGAD_VIEW_TAG           0x542B

#define ADWOADSDK_MAX_ETA_AD_SIZES           8


/** Adwo Ad SDK error code */
enum ADWO_ADSDK_ERROR_CODE
{
    // General error code
    ADWO_ADSDK_ERROR_CODE_SUCCESS,                      // 操作成功
    ADWO_ADSDK_ERROR_CODE_INIT_FAILED,                  // 广告对象初始化失败
    ADWO_ADSDK_ERROR_CODE_AD_HAS_BEEN_LOADED,           // 已经用当前广告对象调用了加载接口
    ADWO_ADSDK_ERROR_CODE_NULL_PARAMS,                  // 不该为空的参数为空
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_PARAMETER,            // 参数值非法
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_HANDLE,               // 非法广告对象句柄
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_DELEGATE,             // 代理为空或adwoGetBaseViewController方法没实现
    ADWO_ADSDK_ERROR_CODE_ILLEGAL_ADVIEW_RETAIN_COUNT,  // 非法的广告对象句柄引用计数
    ADWO_ADSDK_ERROR_CODE_UNEXPECTED_ERROR,             // 意料之外的错误
    ADWO_ADSDK_ERROR_CODE_AD_REQUEST_TOO_OFTEN,         // 广告请求太过频繁
    ADWO_ADSDK_ERROR_CODE_LOAD_AD_FAILED,               // 广告加载失败
    ADWO_ADSDK_ERROR_CODE_AD_HAS_BEEN_SHOWN,            // 广告已经被加载或展示过
    ADWO_ADSDK_ERROR_CODE_FS_AD_NOT_READY_TO_SHOW,      // 全屏广告还没准备好展示
    ADWO_ADSDK_ERROR_CODE_FS_RESOURCE_DAMAGED,          // 全屏广告资源破损
    ADWO_ADSDK_ERROR_CODE_FS_LAUNCHING_AD_REQUESTING,   // 开屏全屏广告正在请求
    ADWO_ADSDK_ERROR_CODE_FS_ALREADY_AUTO_SHOW,         // 当前全屏已设置为自动展示
    ADWO_ADSDK_ERROR_CODE_ETA_DISABLED,                 // 当前事件触发型广告已被禁用
    ADWO_ADSDK_ERROR_CODE_ETA_SIZE_INVALID,             // 没找到相应合法尺寸的事件触发型广告
    
    // Server request relevant error code
    ADWO_ADSDK_ERROR_CODE_REQUEST_SERVER_BUSY,          // 服务器繁忙
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD,                // 当前没有广告
    ADWO_ADSDK_ERROR_CODE_REQUEST_UNKNOWN_ERROR,        // 未知请求错误
    ADWO_ADSDK_ERROR_CODE_REQUEST_INEXIST_PID,          // PID不存在
    ADWO_ADSDK_ERROR_CODE_REQUEST_INACTIVE_PID,         // PID未被激活
    ADWO_ADSDK_ERROR_CODE_REQUEST_REQUEST_DATA,         // 请求数据有问题
    ADWO_ADSDK_ERROR_CODE_REQUEST_RECEIVED_DATA,        // 接收到的数据有问题
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD_IP,             // 当前IP下广告已经投放完
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD_POOL,           // 当前广告都已经投放完
    ADWO_ADSDK_ERROR_CODE_REQUEST_NO_AD_LOW_RANK,       // 没有低优先级广告
    ADWO_ADSDK_ERROR_CODE_REQUEST_BUNDLE_ID,            // 开发者在Adwo官网注册的Bundle ID与当前应用的Bundle ID不一致
    ADWO_ADSDK_ERROR_CODE_REQUEST_RESPONSE_ERROR,       // 服务器响应出错
    ADWO_ADSDK_ERROR_CODE_REQUEST_NETWORK_CONNECT,      // 设备当前没连网络，或网络信号不好
    ADWO_ADSDK_ERROR_CODE_REQUEST_INVALID_REQUEST_URL   // 请求URL出错
};

/** Adwo Ad banner size */
enum ADWO_ADSDK_BANNER_SIZE
{
    /** Banner types for iPhone/iPod Touch 
     *
     * The default size is 320x50
    */
    ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER = 1,
    
    /** For banner on iPad
     *
     * The size is 320x50
    */
    ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_320x50 = 10,
    
    /** For banner on iPad
     *
     * The size is 720x110
     */
    ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_720x110
};

enum ADWOSDK_SPREAD_CHANNEL
{
    ADWOSDK_SPREAD_CHANNEL_APP_STORE,
    ADWOSDK_SPREAD_CHANNEL_91_STORE
};

enum ADWOSDK_AGGREGATION_CHANNEL
{
    ADWOSDK_AGGREGATION_CHANNEL_NONE,
    ADWOSDK_AGGREGATION_CHANNEL_GUOHEAD,
    ADWOSDK_AGGREGATION_CHANNEL_ADVIEW,
    ADWOSDK_AGGREGATION_CHANNEL_MOGO,
    ADWOSDK_AGGREGATION_CHANNEL_ADWHIRL,
    ADWOSDK_AGGREGATION_CHANNEL_ADSAGE,
    ADWOSDK_AGGREGATION_CHANNEL_ADMOB,
    ADWOSDK_AGGREGATION_CHANNEL_YISOU = 8
};

// 全屏广告展示形式ID
enum ADWOSDK_FSAD_SHOW_FORM
{
    ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND,   // App Fun插页式全屏广告加品牌全屏广告（App Fun优先）
    ADWOSDK_FSAD_SHOW_FORM_LAUNCHING,           // 应用启动后立即展示全屏广告
    ADWOSDK_FSAD_SHOW_FORM_GROUND_SWITCH,       // 后台切换到前台后立即显示全屏广告
    ADWOSDK_FSAD_SHOW_FORM_APPFUN,              // App Fun插页式全屏广告
    ADWOSDK_FSAD_SHOW_FORM_BRAND                // 品牌插页式全屏
};

// 事件触发型广告类型
enum ADWOSDK_ETA_TYPE
{
    ADWOSDK_ETA_TYPE_VOICEPRINT,
    ADWOSDK_ETA_TYPE_IBEACON,
    
    ADWOSDK_ETA_TYPE_MAX_COUNT
};

// Banner动画类型
enum ADWO_ANIMATION_TYPE
{
    // Animation moving
    ADWO_ANIMATION_TYPE_AUTO,                   // 由Adwo服务器来控制动画类型
    ADWO_ANIMATION_TYPE_NONE,                   // 无动画，直接切换
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_LEFT,   // 从左到右的推移
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_RIGHT,  // 从右到左推移
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_BOTTOM, // 从下到上推移
    ADWO_ANIMATION_TYPE_PLAIN_MOVE_FROM_TOP,    // 从上到下推移
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_LEFT,  // 新广告从左到右移动，并覆盖在老广告条上
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_RIGHT, // 新广告从右到左移动，并覆盖在老广告条上
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_BOTTOM,// 新广告从下到上移动，并覆盖在老广告条上
    ADWO_ANIMATION_TYPE_PLAIN_COVER_FROM_TOP,   // 新广告从上到下移动，并覆盖在老广告条上
    
    ADWO_ANIMATION_TYPE_CROSS_DISSOLVE,         // 淡入淡出
    
    // Animation transition
    ADWO_ANIMATION_TYPE_CURL_UP,                // 向上翻页
    ADWO_ANIMATION_TYPE_CURL_DOWN,              // 向下翻页
    ADWO_ANIMATION_TYPE_FLIP_FROMLEFT,          // 从左到右翻页
    ADWO_ANIMATION_TYPE_FLIP_FROMRIGHT          // 从右到左翻页
};

// 全屏广告动画类型
enum ADWO_SDK_FULLSCREEN_ANIMATION_TYPE
{
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_AUTO,    // 由Adwo服务器来控制动画类型
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_NONE,    // 无动画，直接出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_LEFT_TO_RIGHT, // 从左到右出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_RIGHT_TO_LEFT, // 从右到左出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_BOTTOM_TO_TOP, // 从底到顶出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_MOVE_FROM_TOP_TO_BOTTOM, // 从顶到底出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_SCALE_LEFT_RIGHT,        // 水平方向伸缩出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_SCALE_TOP_BOTTOM,        // 垂直方向伸缩出现消失
    ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_CROSS_DISSOLVE,          // 淡入淡出
};


@protocol AWAdViewDelegate <NSObject>

@required

/**
 * @brief 当SDK需要弹出自带的Browser以显示mini site时需要使用当前广告所在的控制器。
 * @warning AWAdView的delegate必须被设置，并且此接口必须被实现。
 * @return 一个视图控制器对象
*/
- (UIViewController*)adwoGetBaseViewController;

@optional

/**
 * @brief 捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的广告对象句柄。开发者可以通过errorCode属性来查询失败原因。
*/
- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView;

/**
 * @brief 捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的广告对象句柄。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
*/
- (void)adwoAdViewDidLoadAd:(UIView*)adView;

/**
 * @brief 当全屏广告被关闭时，SDK将调用此接口。一般而言，当全屏广告被用户关闭后，开发者应当将当前全屏广告对象置空，使其无效化。对于全屏广告而言，没有提供给开发者的释放接口，所有回收工作由SDK自行处理。若开发者要在此接口中重新创建新的全屏广告对象，至少延迟3秒。
*/
- (void)adwoFullScreenAdDismissed:(UIView*)adView;

/**
 * @brief 当SDK弹出自带的全屏展示浏览器时，将会调用此接口。参数adView指向当前请求广告对象句柄。这里需要注意的是，当adView弹出全屏展示浏览器时，此adView不允许被释放，否则会导致SDK崩溃。
*/
- (void)adwoDidPresentModalViewForAd:(UIView*)adView;

/**
 * @brief 当SDK自带的全屏展示浏览器被用户关闭后，将会调用此接口。参数adView指向当前请求广告对象句柄。
*/
- (void)adwoDidDismissModalViewForAd:(UIView*)adView;

/**
 * @brief 用户点击植入性广告的关闭按钮之后，SDK将会发出此消息。参数adView指向当前请求广告对象句柄。在此消息中，开发者可以调用AdwoAdRemoveAndDestroyImplantAd接口。
 */
- (void)adwoUserClosedImplantAd:(UIView*)adView;

/**
 * @brief 用户点击横幅广告的关闭按钮之后，SDK将会发出此消息。参数adView指向当前请求广告对象句柄。在此消息中，开发者可以调用AdwoAdRemoveAndDestroyBanner接口来移除Banner广告。
 */
- (void)adwoUserClosedBannerAd:(UIView*)adView;

/**
 * @brief 当用户点击广告触发某些事件时，需要暂停广告请求，此时SDK会发送此消息来通知开发者不要去释放当前的广告对象也不要去请求新的广告。
 */
- (void)adwoAdRequestShouldPause:(UIView*)adView;

/**
 * @brief 表示当前SDK需要暂停的事件已经完成，开发者接收到此消息之后可以释放当前的广告对象。对于Banner可以重新请求。
 */
- (void)adwoAdRequestMayResume:(UIView*)adView;

/**
 * @brief 当前SDK请求事件触发型广告成功过，通知开发者相应的ETA广告已被开启并且开始做相应的事件真侦听
*/
- (void)adwoAdETARequestedAndActivated;

/**
 * @brief 当特定的ETA广告接受到指定的事件触发特征码之后准备展示，SDK将会给应用发送此消息。
 * 应用可以在此消息回调中通过使用AdwoAdAddETAViewToSuperview或AdwoAdAddETAViewWithAnimation接口来展示ETA广告
 * @param etaType ETA广告类型。请参考enum ADWOSDK_ETA_TYPE
*/
- (void)adwoAdETAReceivedSpecifiedFeatureCode:(int)etaType;

/**
 * @brief 当使用AdwoAdAddETAViewWithAnimation接口来添加ETA广告视图，通过实现这个协议接口来处理动画结束后的定制处理
*/
- (void)adwoAdETAAnimationComplete;

/**
 * @brief 当用户点击ETA广告的关闭按钮之后，SDK将会发出此消息。参数adView指向当前请求广告对象句柄。在此消息中，开发者可以调用AdwoAdRemoveETAViewFromSuperview接口来移除ETA广告视图。
 * @param etaType 当前ETA广告的类型，请参考enum ADWOSDK_ETA_TYPE
*/
- (void)adwoUserClosedETA:(int)etaType;

@end


@protocol AWSocialShareDelegate <NSObject>

@required

/**
 * @brief 分享指定消息到指定社区的代理
 * @param shareInfo: 分享信息。这是一个字典类型，根据不同的分享社区，key的名称也有可能不同。
 * @param socialName: 指明了当前要把指定消息分享到哪个社区。
*/

- (void)adwoSocialShareMessage:(NSDictionary*)shareInfo social:(NSString*)socialName;

@end


// 偏好属性设置
struct AdwoAdPreferenceSettings
{    
    int adSlotID;                                   // 广告位ID（仅用于Banner与植入性广告）
    unsigned animationType;                         // 动画类型
    enum ADWOSDK_SPREAD_CHANNEL spreadChannel;      // 渠道类型（App Store、91等）
    BOOL disableGPS;                                // 是否禁用GPS
    BOOL unclickable;                               // 广告是否不可点击
    CGSize userSpecAdSize;                          // 开发者指定广告尺寸
};


#ifdef __cplusplus
extern "C" {
#endif

/**
 * @brief 停止Banner广告自动轮询刷新。这个接口一般适用于广告SDK的聚合。
*/
extern void adwoAdStopBannerAutoRefresh(void);

/**
 * @brief 创建一条Banner广告
 * @param pid 申请一个应用后，页面返回出来的广告发布ID（32个ASCII码字符）。
 * @param showFormalAd 是否展示正式广告。如果传NO，表示使用测试模式，SDK将给出测试广告；如果传YES，那么SDK将给出正式广告。
 * @param delegate AWAdViewDelegate代理。应用开发者应该将展示本SDK Banner的视图控制器实现AWAdViewDelegate代理，并且将视图控制器对象传给此参数。此参数不能为空。注意，此参数不会被retain。
 * @return 如果返回为空，表示广告初始化创建失败，开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。如果创建成功，则返回一个UIView对象，作为广告对象句柄。
*/
extern UIView* AdwoAdCreateBanner(NSString *pid, BOOL showFormalAd, NSObject<AWAdViewDelegate> *delegate);

/**
 * @brief 移除并销毁Banner广告
 * @param adView Banner对象句柄
 * @return 如果销毁成功，返回YES；否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdRemoveAndDestroyBanner(UIView *adView);

/**
 * @brief 当完成初始化和相关设置之后，调用此方法来加载Banner广告。
 * @param adView Banner对象句柄
 * @param bannerSize 指定当前的Banner尺寸。如果是用于iPhone、iPod Touch，那么使用ADWO_ADSDK_BANNER_SIZE_NORMAL_BANNER即可，该尺寸为320x50；如果是用于iPad，那么可以指定ADWO_ADSDK_AD_TYPE_BANNER_SIZE_FOR_IPAD_320x50和ADWO_ADSDK_BANNER_SIZE_FOR_IPAD_720x110两种尺寸。
 * @param pRemainInterval 指向剩余请求时间间隔的变量指针
 * @return 如果操作成功，返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。当这个接口返回后，Banner未必加载成功，开发者必须通过AWAdViewDelegate代理中的adwoAdViewDidLoadAd方法来捕获Banner是否加载成功。
 * @attention 这里要注意的是，广告对象应该被加到一个控制器的根视图中，即其大小撑满整个屏幕，否则某些广告展示形式可能会影响父视图的尺寸。
*/
extern BOOL AdwoAdLoadBannerAd(UIView *adView, enum ADWO_ADSDK_BANNER_SIZE bannerSize, NSTimeInterval *pRemainInterval);

/**
 * @brief 将当前的Banner广告对象添加到用户指定的父视图上
 * @param adView Banner对象句柄
 * @param superView 用户指定的父视图
 * @return 如果操作成功，返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。当这个接口返回后，Banner未必加载成功，开发者必须通过AWAdViewDelegate代理中的adwoAdViewDidLoadAd方法来捕获Banner是否加载成功。
*/
extern BOOL AdwoAdAddBannerToSuperView(UIView *adView, UIView *superView);

/**
 * @brief 获取当前Banner广告的最小请求间隔时间
 * @return 当前Banner广告的最小请求间隔时间
*/
extern NSTimeInterval AdwoAdGetBannerRequestInterval(void);

/**
 * @brief 获取全屏广告对象句柄
 * @param pid 申请一个应用后，页面返回出来的广告发布ID（32个ASCII码字符）。
 * @param showFormalAd 是否展示正式广告。如果传NO，表示使用测试模式，SDK将给出测试广告；如果传YES，那么SDK将给出正式广告。
 * @param delegate AWAdViewDelegate代理。应用开发者应该将展示本SDK Banner的视图控制器实现AWAdViewDelegate代理，并且将视图控制器对象传给此参数。此参数不能为空。
 * @param fsAdForm 全屏广告类型。详情可见ADWOSDK_FSAD_SHOW_FORM枚举在值的定义
 * @return 全屏广告句柄。
 * @attention 这个接口由SDK自动管理全屏广告对象，因此开发者不需要自己释放全屏广告对象
*/
extern UIView* AdwoAdGetFullScreenAdHandle(NSString *pid, BOOL showFormalAd, NSObject<AWAdViewDelegate> *delegate, enum ADWOSDK_FSAD_SHOW_FORM fsAdForm);

/**
 * @brief 加载全屏广告
 * @param fsAd 全屏广告对象句柄
 * @param orientationLocked 应用是否锁定了屏幕方向。如果当前应用在展示全屏广告的时候仅支持横屏或竖屏，那么传YES；如果横竖屏都支持且会切换，则传NO
 * @param pRemainInterval 指向剩余请求时间间隔的变量指针
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @discussion 如果fsAdForm为ADWOSDK_FSAD_SHOW_FORM_LAUNCHING，那么错误码可能为ADWO_ADSDK_ERROR_CODE_FS_LAUNCHING_AD_REQUESTING。
 * 这表示当前SDK正在请求开屏全屏广告资源，因此开发者不需要等待广告加载，可以直接做自己后面的作业；如果返回YES，说明开屏全屏广告已经有加载好的资源，此时可以进行展示
 */
extern BOOL AdwoAdLoadFullScreenAd(UIView *fsAd, BOOL orientationLocked, NSTimeInterval *pRemainInterval);

/**
 * @brief 展示全屏广告
 * @param fsAd 全屏广告对象句柄
 * @return 若展示成功，则返回YES，否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdShowFullScreenAd(UIView *fsAd);

/**
 * @brief 设置是否自动展示后台切换到前台全屏广告
 * @param fsAd 全屏广告对象句柄
 * @param autoToShow 是否自动展示。如果为YES，则当应用从后台切换到前台时，倘若此时后台切换到前台全屏广告已加载好，则由SDK自动展示；若为NO，则SDK不会自动展示，交给开发者来调用AdwoAdShowFullScreenAd接口展示全屏
 * @return 若展示成功，则返回YES，否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @attention 默认情况下，SDK会自动展示后台切换到前台广告。若当前为自动展示，那么开发者手工对后台切换到前台调用AdwoAdShowFullScreenAd接口将会返回NO，同时给出ADWO_ADSDK_ERROR_CODE_FS_ALREADY_AUTO_SHOW的错误码
*/
extern BOOL AdwoAdSetGroundSwitchAdAutoToShow(UIView *fsAd, BOOL autoToShow);

/**
 * @brief 获取当前所指定类型的全屏广告的最小请求间隔时间
 * @param fsAdType——所指定的全屏广告类型
 * @return 当前全屏广告的最小请求间隔时间
*/
extern NSTimeInterval AdwoAdGetFullScreenRequestInterval(enum ADWOSDK_FSAD_SHOW_FORM fsAdType);

/**
 * @brief 创建植入性广告
 * @param pid 申请一个应用后，页面返回出来的广告发布ID（32个ASCII码字符）。
 * @param showFormalAd 是否展示正式广告。如果传NO，表示使用测试模式，SDK将给出测试广告；如果传YES，那么SDK将给出正式广告。
 * @param delegate AWAdViewDelegate代理。应用开发者应该将展示本SDK Banner的视图控制器实现AWAdViewDelegate代理，并且将视图控制器对象传给此参数。此参数不能为空。注意，此参数不会被retain。
 * @param adInfo 广告信息。开发者可以设置指定广告信息来请求自己想要的广告植入性广告。如果设置为空或者非有效的字符串，则由服务器来决定给出相应广告。注意，这个参数会被retain，因此如果字符串实参使用alloc分配的话，在调用完这个接口之后需要release一次。
 * @return 如果返回为空，表示广告初始化创建失败，开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。如果创建成功，则返回一个UIView对象，作为广告对象句柄。
*/
extern UIView* AdwoAdCreateImplantAd(NSString *pid, BOOL showFormalAd, NSObject<AWAdViewDelegate> *delegate, NSString *adInfo);

/**
 * @brief 移除并销毁植入性广告
 * @param adView 植入性广告对象句柄
 * @return 如果销毁成功，返回YES；否则，返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 */
extern BOOL AdwoAdRemoveAndDestroyImplantAd(UIView *adView);

/**
 * @brief 加载植入性广告
 * @param adView 植入性广告对象句柄
 * @param pRemainInterval 指向剩余请求时间间隔的变量指针
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 */
extern BOOL AdwoAdLoadImplantAd(UIView *adView, NSTimeInterval *pRemainInterval);

/**
 * @brief 展示植入性广告
 * @param adView——植入性广告对象句柄
 * @param theSuperview 植入性广告视图将被添加到的父视图
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdShowImplantAd(UIView *adView, UIView *theSuperview);

/**
 * @brief 激活植入性广告
 * @discussion 当展示了植入性广告之后，开发者可以在适当时机调用此接口来激活植入性广告。倘若植入性广告具有动画、播放音视频等效果的话，
 * 那么往往通过调用这个接口来激活这些动态行为。
 * @param adView 植入性广告对象句柄
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdImplantAdActivate(UIView *adView);

/**
 * @brief 设置能与植入性广告内容进行互动的应用信息
 * @discussion 当开发者输入一些简短的字符串信息之后，某些定制的植入性广告将以某种方式将开发者传入的信息展示在广告页面上
 * @param adView 植入性广告对象句柄
 * @param info 指定的应用互动信息
 * @return 若加载成功返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @attention 这个接口可以在任意时候调用。如果当前广告已经展示，那么重新设置新的信息将会刷新广告页面内容
*/
extern BOOL AdwoAdSetImplantAdInteractiveInfo(UIView *adView, NSString *info);

/**
 * @brief 获取当前植入性广告的最小请求间隔时间
 * @return 当前植入性广告的最小请求间隔时间
 */
extern NSTimeInterval AdwoAdGetImplantRequestInterval(void);

/**
 * @brief 获取最近的错误码。具体错误码请参考ADWO_ADSDK_ERROR_CODE
 * @return 错误码枚举值
*/
extern enum ADWO_ADSDK_ERROR_CODE AdwoAdGetLatestErrorCode(void);

/**
 * @brief 设置广告对象属性。这个接口对所有广告类型（包括Banner和各类全屏等）都适用
 * @param adView 广告对象句柄
 * @param settings 设置结构体
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @warning 该接口应该在广告加载之前使用。
*/
extern BOOL AdwoAdSetAdAttributes(UIView *adView, const struct AdwoAdPreferenceSettings *settings);

/**
 * @brief 设置关键字。关键字一般由应用自己决定，并且一般需要与本SDK进行一个合作交互。
 * 因此普通开发者可以不用关心此接口
 * @param adView 广告对象句柄
 * @param keywords 关键字字符串
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @warning 该接口应该在广告加载之前使用。此外，keywords对象会被retain，因此调用好这个接口之后，如果你的keywords是被alloc出来的，则需要调用一次release。
*/
extern BOOL __attribute__((overloadable)) AdwoAdSetKeywords(UIView *adView, NSString *keywords);

/**
 * @brief 从关键字字典获取关键字字符串
 * @brief 以字典来设置关键字的方式方便开发者进行数据处理，此接口允许开发者传定义好的字典对象
 * @param keywordsDict 关键字字典对象
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @warning 该接口应该在广告加载之前使用。此外，keywords对象会被retain，因此调用好这个接口之后，如果你的keywords是被alloc出来的，则需要调用一次release。
*/
extern BOOL __attribute__((overloadable)) AdwoAdSetKeywords(UIView *adView, NSDictionary *keywords);

/**
 * @brief 对当前广告视图对象设置代理对象
 * @param adView 广告对象句柄
 * @param delegate AWAdViewDelegate代理。应用开发者应该将展示本SDK Banner的视图控制器实现AWAdViewDelegate代理，并且将视图控制器对象传给此参数。此参数不能为空。注意，此参数不会被retain。
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdSetDelegate(UIView *adView, NSObject<AWAdViewDelegate> *delegate);

/**
 * @brief 获取当前广告信息
 * @param adView 广告对象句柄
 * @return 如果成功，则返回当前广告信息。如果失败，则返回空，开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * @discussion 开发者可以在获得AWAdViewDelegate代理的adwoAdViewDidLoadAd通知之后来获取此广告相关的广告信息。如果为空字符串，说明当前广告并无特别信息。
*/
extern NSString* AdwoAdGetAdInfo(UIView *adView);

/**
 * @brief 获取当前广告ID
 * @param adView 广告对象句柄
 * @param pAdID 指向输出的存放广告ID变量的指针。若所得到的广告ID为-1，说明当前广告请求尚未成功。
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdGetCurrentAdID(UIView *adView, int *pAdID);

/**
 * @brief 注册社区分享代理
 * 这个接口可用于注册多个代理，使得SDK能做指定的社区分享。目前支持微信（WeChat）
 * @param delegate 接收负责分享指定信息到指定社区消息的对象代理
 * @param socialName 这个是本SDK定义好的字符串。@"WeChat"表示此代理用于负责接收分享到微信的消息通知
 * @warning 当调用这个接口之后，参数delegate对象会被retain一次。因此，当你要释放这个delegate的时候，请传空来调用此接口一次，如：AdwoAdRegisterSocialShareDelegate(nil, @"WeChat");使得代理对象delegate能被最终释放掉
*/
extern void AdwoAdRegisterSocialShareDelegate(NSObject<AWSocialShareDelegate> *delegate, NSString *socialName);

/**
 * @brief 社区分享的结果响应
 * @discussion 当社区分享完成之后，第三方应用程序调用此接口来通知SDK端分享的结果
 * @param adView 当前广告对象句柄
 * @param result 分享的结果。YES表示分享成功；NO表示分享失败
 * @param socialName 社区名，比如"WeChat"表示微信社区
*/
extern void AdwoAdReceiveSocialShareResult(UIView *adView, BOOL result, NSString *socialName);

/**
 * @brief 启动事件触发型广告。事件触发型广告被启动后将会自动请求当前的指定的事件触发型广告。若指定的ETA广告能被触发，SDK会对应用发送adwoAdETARequestedAndActivated消息。
 * 但是即便存在事件触发型广告，SDK也不会马上通知应用程序。而是等到SDK捕获到了相应事件触发特征码之后才会通知第三方应用的代理，
 * 发出adwoAdETAReceivedSpecifiedFeatureCode代理回调通知。
 * @param etaType 指定的事件触发广告类型，参考ADWOSDK_ETA_TYPE枚举
 * @param pid 申请一个应用后，页面返回出来的广告发布ID（32个ASCII码字符）。
 * @param showFormalAd 是否展示正式广告。如果传NO，表示使用测试模式，SDK将给出测试广告；如果传YES，那么SDK将给出正式广告。
 * @param settings 指向广告属性设置结构体变量的指针。若为空，则启用默认设置
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdLaunchETA(enum ADWOSDK_ETA_TYPE etaType, NSString *pid, BOOL showFormalAd, const struct AdwoAdPreferenceSettings *settings);

/**
 * @brief 设置事件触发型广告代理
 * @param etaType 指定的事件触发广告类型，参考ADWOSDK_ETA_TYPE枚举
 * @param delegate AWAdViewDelegate代理。应用开发者应该将展示本SDK广告的视图控制器实现AWAdViewDelegate代理，并且将视图控制器对象传给此参数。
 * @attention 注意，delegate参数不会被retain。因此，如果开发者要销毁delegate所对应的对象之前，必须调用此接口，并传空。
 * @warning 这个接口应该在AdwoAdLaunchETA调用之后立即调用，来设置当前的delegate。
*/
extern void AdwoAdSetETADelegate(enum ADWOSDK_ETA_TYPE etaType, NSObject<AWAdViewDelegate> *delegate);

/**
 * @brief 获取当前事件触发型广告可用的广告尺寸
 * @param etaType 指定的事件触发广告类型，参考ADWOSDK_ETA_TYPE枚举
 * @attention 关于当前广告SDK可支持的事件触发型广告尺寸的最大个数，请使用宏ADWOADSDK_MAX_ETA_AD_SIZES
 * @param adSizes 存放SDK所返回的广告尺寸的数组，最大个数为ADWOADSDK_MAX_ETA_AD_SIZES。
 * @return 当前事件触发型广告所支持的尺寸个数。若是0，则说明当前事件触发型广告未被识别或尚未被激活
 * @warning 此接口应该在收到adwoAdETAReceivedSpecifiedFeatureCode代理通知之后才能被调用，否则将会返回0。
*/
extern int AdwoAdGetETAViewSizes(enum ADWOSDK_ETA_TYPE etaType, CGSize adSizes[]);

/**
 * @brief 将当前识别到的事件触发型广告添加到指定的父视图上，并指定其尺寸
 * @param etaType 指定的事件触发广告类型，参考ADWOSDK_ETA_TYPE枚举
 * @param superview 将当前事件触发型广告所添加到的父视图
 * @param adSize 指定当前广告页面尺寸。这个尺寸应该在AdwoAdGetETAViewSizes接口所返回的广告尺寸数组中来选择。
 * @param position 指定当前事件触发型广告视图的位置
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
 * 
*/
extern BOOL AdwoAdAddETAViewToSuperview(enum ADWOSDK_ETA_TYPE etaType, UIView *superview, CGSize adSize, CGPoint position);

/**
 * @brief 将当前识别到的事件触发型广告添加到指定的父视图上，指定其尺寸并且做切换动画。
 * 该动画是从fromView切换到当前所要展示的广告
 * @param etaType 指定的事件触发广告类型，参考ADWOSDK_ETA_TYPE枚举
 * @param superview 将当前广告所添加到的父视图
 * @param adSize 指定当前广告页面尺寸。这个尺寸应该在AdwoAdGetVoicePrintAdViewSizes接口所返回的广告尺寸数组中来选择。
 * @param position指定当前事件触发型广告视图的位置
 * @param fromView 动画从fromView这个视图切换到当前的事件触发广告视图
 * @param duration 动画过程时间
 * @param options 动画类型
 * @param completion 动画结束后要做的事情
 * @return 如果成功，则返回YES，否则返回NO。开发者可以通过调用AdwoAdGetLatestErrorCode接口来获取错误码。
*/
extern BOOL AdwoAdAddETAViewWithAnimation(enum ADWOSDK_ETA_TYPE etaType, UIView *superview, CGSize adSize, CGPoint position, UIView *fromView, NSTimeInterval duration, UIViewAnimationOptions options);

/**
 * @brief 将指定的事件触发型广告从当前父视图上移除
 * @param etaType 指定的事件触发广告类型，参考ADWOSDK_ETA_TYPE枚举
 * @attention 当指定的事件触发型广告从父视图上移除后，事件侦听并不会被关闭，SDK隔一段时间会再次做事件侦听
*/
extern void AdwoAdRemoveETAViewFromSuperview(enum ADWOSDK_ETA_TYPE etaType);

/**
 * @brief 获取事件触发型广告信息
 * @param etaType 指定的事件触发广告类型，参考ADWOSDK_ETA_TYPE枚举
 * @param pAdID 指向接受当前事件触发型广告ID的变量
 * @param pIsReadyToShow 指向接受当前事件触发型广告是否准备好展示的变量
 * @return 若当前事件触发型广告已经加载好，则返回当前事件触发型广告信息字符串，否则返回空。
*/
extern NSString *AdwoAdGetVoicePrintAdInfo(enum ADWOSDK_ETA_TYPE etaType, int *pAdID, BOOL *pIsReadyToShow);

/**
 * @brief 打开指定的事件触发型广告侦听
 * @param etaType 指定的事件触发广告类型，参考ADWOSDK_ETA_TYPE枚举
*/
extern void AdwoAdOpenETATracking(enum ADWOSDK_ETA_TYPE etaType);

/**
 * @brief 关闭指定的事件触发型广告侦听
 * @param etaType 指定的事件触发广告类型，参考ADWOSDK_ETA_TYPE枚举
*/
extern void AdwoAdCloseETATracking(enum ADWOSDK_ETA_TYPE etaType);


#ifdef __cplusplus
}
#endif



