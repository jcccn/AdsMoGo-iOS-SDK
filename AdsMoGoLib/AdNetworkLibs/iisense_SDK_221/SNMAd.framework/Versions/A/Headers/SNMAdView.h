#import <UIKit/UIKit.h>

//--the Response Codes
enum {
    AdSdkErrorUnknown = 0,
    AdSdkErrorServerFailure = 1,
    AdSdkErrorInventoryUnavailable = 2,
    AdSdkErrorInventoryUnusageJsonData = 3,
    AdSdkErrorAnimationCreateFailed = 4
};

//--Advert Sensing Setting--
enum AdvertSensingSetting{
    SensedAndNormalAd = 0,
    NormalAdOnly = 1,
    SensedAdOnly = 2
};

//-- Advert Show Type
enum AdvertShowType{
    BannerAndAnimationAd = 0,
    BannerAdOnly = 1,
    AnimationAdOnly = 2
};

@class SNMAdView;

@protocol SNMAdViewDelegate <NSObject>

@optional

- (void)SNMAdViewDidLoadAdSdkAd:(SNMAdView *)adView;

- (void)SNMAdViewDidLoadRefreshedAd:(SNMAdView *)adView;

- (void)SNMAdView:(SNMAdView *)adView didFailToReceiveAdWithError:(NSError *)error;

- (BOOL)SNMAdViewActionShouldBegin:(SNMAdView *)adView willLeaveApplication:(BOOL)willLeave;

- (void)SNMAdViewActionWillPresent:(SNMAdView *)adView;

- (void)SNMAdViewActionWillFinish:(SNMAdView *)adView;

- (void)SNMAdViewActionDidFinish:(SNMAdView *)adView;

- (void)SNMAdViewActionWillLeaveApplication:(SNMAdView *)adView;

- (void)SNMAdViewActionAdvertClick:(SNMAdView *)adView advertClicking:(enum AdvertShowType)advertType;

- (void)SNMAdViewActionAdvertClose:(SNMAdView *)adView advertClosing:(enum AdvertShowType)advertType;

@end

@interface SNMAdView : UIViewController <UIApplicationDelegate>
{
	NSString *advertisingSection;
	BOOL bannerLoaded;
	BOOL bannerViewActionInProgress;
	UIViewAnimationTransition refreshAnimation;
	__unsafe_unretained id <SNMAdViewDelegate> delegate;

	UIImage *_bannerImage;
	BOOL _tapThroughLeavesApp;
	BOOL _shouldScaleWebView;
	BOOL _shouldSkipLinkPreflight;
	BOOL _statusBarWasVisible;
	NSURL *_tapThroughURL;
	NSInteger _refreshInterval;
    
	NSTimer *_refreshDetectionTimer;
  
    BOOL refreshTimerOff;
    NSString *requestURL;
    NSString *placementId;

    
    //-uivew define
    UIView *bannerView;
    UIView *animationView;
    
    //--refresh animation image --
    NSTimer *_refreshAnimationTimer;
    
    //-- for requestAd error Refresh
    NSTimer *_refreshRequestErrTimer;
    int  requestRequestErrCount;
    
    NSInteger showType;  //-andy-the webview show type 0-1-2-3-4-
    BOOL usingShaking;
    NSInteger shackingExpire; //-- seconds
    
    enum AdvertSensingSetting adSensingSetting;
    enum AdvertShowType adShowType;
    
    //-advert auto turns
    BOOL enableAutoAdRefresh;
}

@property (nonatomic, assign) __unsafe_unretained id <SNMAdViewDelegate> delegate;
@property (nonatomic, copy) NSString *advertisingSection;
@property (nonatomic, assign) UIViewAnimationTransition refreshAnimation;

@property (nonatomic, readonly, getter=isBannerLoaded) BOOL bannerLoaded;
@property (nonatomic, readonly, getter=isBannerViewActionInProgress) BOOL bannerViewActionInProgress;

@property (nonatomic, assign) BOOL    refreshTimerOff;

@property (strong, nonatomic) NSString *requestURL;
@property (strong, nonatomic) NSString *placementId;

@property (strong, nonatomic) UIView *bannerView;
@property (strong, nonatomic) UIView *animationView;

//@property (nonatomic, assign) BOOL allowDelegateAssigmentToRequestAd;

@property (nonatomic, assign) NSInteger showType;  //-andy-the webview show type 0-1-2-3-4-

@property (nonatomic, assign) BOOL usingShaking;
@property (nonatomic, assign) NSInteger shackingExpire;

@property (nonatomic,assign) enum AdvertSensingSetting adSensingSetting;
@property (nonatomic,assign) enum AdvertShowType adShowType;

//--advert auto turns
@property (nonatomic,assign) BOOL enableAutoAdRefresh;

- (void)requestAd;
- (void)initSNMLookup;

@end

extern NSString * const AdSdkErrorDomain;