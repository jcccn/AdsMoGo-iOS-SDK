

#import <UIKit/UIKit.h>

enum {
    MobFoxInterstitialViewErrorUnknown = 0,
    MobFoxInterstitialViewErrorServerFailure = 1,
    MobFoxInterstitialViewErrorInventoryUnavailable = 2,
};

typedef enum {
    MobFoxAdTypeVideoToInterstitial = 0,
    MobFoxAdTypeVideo = 1,
    MobFoxAdTypeInterstitial = 2,
    MobFoxAdTypeInterstitialToVideo = 3,
    MobFoxAdTypeNoAdInventory = 4,
    MobFoxAdTypeError = 5,
    MobFoxAdTypeUnknown = 6
} MobFoxAdType;

typedef enum {
    MobFoxAdGroupVideo = 0,
    MobFoxAdGroupInterstitial = 1
} MobFoxAdGroupType;

@class MobFoxVideoInterstitialViewController;
@class MobFoxAdBrowserViewController;

@protocol MobFoxVideoInterstitialViewControllerDelegate <NSObject>

- (NSString *)publisherIdForMobFoxVideoInterstitialView:(MobFoxVideoInterstitialViewController *)videoInterstitial;

@optional

- (void)mobfoxVideoInterstitialViewDidLoadMobFoxAd:(MobFoxVideoInterstitialViewController *)videoInterstitial advertTypeLoaded:(MobFoxAdType)advertType;

- (void)mobfoxVideoInterstitialView:(MobFoxVideoInterstitialViewController *)banner didFailToReceiveAdWithError:(NSError *)error;

- (void)mobfoxVideoInterstitialViewActionWillPresentScreen:(MobFoxVideoInterstitialViewController *)videoInterstitial;

- (void)mobfoxVideoInterstitialViewWillDismissScreen:(MobFoxVideoInterstitialViewController *)videoInterstitial;

- (void)mobfoxVideoInterstitialViewDidDismissScreen:(MobFoxVideoInterstitialViewController *)videoInterstitial;

- (void)mobfoxVideoInterstitialViewActionWillLeaveApplication:(MobFoxVideoInterstitialViewController *)videoInterstitial;

@end

@interface MobFoxVideoInterstitialViewController : UIViewController
{

    BOOL advertLoaded;
	BOOL advertViewActionInProgress;

    BOOL locationAwareAdverts;

    __unsafe_unretained id <MobFoxVideoInterstitialViewControllerDelegate> delegate;

    MobFoxAdBrowserViewController *_browser;

    NSString *requestURL;

}

@property (nonatomic, assign) IBOutlet __unsafe_unretained id <MobFoxVideoInterstitialViewControllerDelegate> delegate;

@property (nonatomic, readonly, getter=isAdvertLoaded) BOOL advertLoaded;
@property (nonatomic, readonly, getter=isAdvertViewActionInProgress) BOOL advertViewActionInProgress;

@property (nonatomic, assign) BOOL locationAwareAdverts;

@property (nonatomic, strong) NSString *requestURL;

- (void)requestAd;

- (void)presentAd:(MobFoxAdType)advertType;

- (void)setLocationWithLatitude:(CGFloat)latitude longitude:(CGFloat)longitude;

- (void)requestDemoVideoAdvert; 
- (void)requestDemoInterstitualAdvert;
- (void)requestDemoVideoToInterstitualAdvert;
- (void)requestDemoInterstitualToVideoAdvert;

@end

extern NSString * const MobFoxVideoInterstitialErrorDomain;