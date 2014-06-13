//
//  AdMoGoAdapterDoMobSplash.m
//  wanghaotest
//
//  Created by mogo on 13-11-18.
//
//

#import "AdMoGoAdapterDoMobSplash.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"

@implementation AdMoGoAdapterDoMobSplash

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeDoMob;
}

+ (void)load{
    [[AdMoGoAdSDKSplashNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isFail = NO;
    isSuccess = NO;
    CGFloat offset = 0.0f;
    CGSize adSize;
    if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
        adSize = DOMOB_AD_SIZE_768x576;
        offset = 374.0f;
    } else {
        adSize = DOMOB_AD_SIZE_320x240;
        if ([UIScreen mainScreen].bounds.size.height > 480.0f) {
            offset = 233.0f;
        } else {
            offset = 168.0f;
        }
    }
    NSString *pubID = nil;
    NSString *placementId = nil;
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSDictionary class]]) {
        pubID  = [key objectForKey:@"PublisherId"];
        placementId = [key objectForKey:@"PlacementId"];
    }
    else{
        [self adFailWith:nil];
        return;
    }
    _splashAd = [[DMSplashAdController alloc] initWithPublisherId:pubID placementId:placementId window:[splashAds getWindow]];
    _splashAd.rootViewController = [self.adMoGoSplashAdsDelegate adsMoGoSplashAdsViewControllerForPresentingModalView];
    [self.splashAds adapterDidStartRequestSplashAd:self];
    _splashAd.delegate = self;
    if (_splashAd.isReady)
    {
        MGLog(MGT,@"_splashAd didReady");
        [_splashAd present];
    }else{
        MGLog(MGT,@"_splashAd did not Ready");
        [self adFailWith:nil];
    }
    
}

- (void)stopBeingDelegate{
    
}

- (void)dealloc{
    if (_splashAd) {
        _splashAd.delegate = nil;
        [_splashAd release];
    }
    [super dealloc];
}

- (void)adSuccess:(id) _awSplash{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [self.splashAds adSplashSuccess:self withSplash:_awSplash];
        if (!([UIApplication sharedApplication].statusBarHidden)) {
            [[UIApplication sharedApplication] setStatusBarHidden:YES];
        }
    }
}

- (void)adFailWith:(NSError *)error{
    MGLog(MGT,@"%s",__func__);
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [self.splashAds adSplashFail:self withError:error];
    }
}

- (BOOL)isSupportSplashCache{
    return YES;
}

#pragma mark DoMob DMSplashAdControllerDelegate

// Sent when an splash ad request success to loaded an ad
- (void)dmSplashAdSuccessToLoadAd:(DMSplashAdController *)dmSplashAd{
    MGLog(MGT,@"%s",__func__);
    [self adSuccess:dmSplashAd];
}
// Sent when an ad request fail to loaded an ad
- (void)dmSplashAdFailToLoadAd:(DMSplashAdController *)dmSplashAd withError:(NSError *)err{
    MGLog(MGT,@"%s",__func__);
    [self adFailWith:err];
}

// Sent just before presenting an splash ad view
- (void)dmSplashAdWillPresentScreen:(DMSplashAdController *)dmSplashAd{
    MGLog(MGT,@"%s",__func__);
    [self.splashAds adSplash:self WillPresent:dmSplashAd];
}
// Sent just after dismissing an splash ad view
- (void)dmSplashAdDidDismissScreen:(DMSplashAdController *)dmSplashAd{
    MGLog(MGT,@"%s",__func__);
    [self.splashAds adSplash:self didDismiss:dmSplashAd];
    if (([UIApplication sharedApplication].statusBarHidden)) {
        [[UIApplication sharedApplication] setStatusBarHidden:NO];
    }
}
@end
