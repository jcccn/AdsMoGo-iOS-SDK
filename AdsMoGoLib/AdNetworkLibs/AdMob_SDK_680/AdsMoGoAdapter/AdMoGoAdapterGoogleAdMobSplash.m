//
//  AdMoGoAdapterGoogleAdMobSplash.m
//  wanghaotest
//
//  Created by mogo on 13-11-18.
//
//

#import "AdMoGoAdapterGoogleAdMobSplash.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"

@implementation AdMoGoAdapterGoogleAdMobSplash

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdMob;
}

+ (void)load{
    [[AdMoGoAdSDKSplashNetworkRegistry sharedRegistry] registerClass:self];
}

//+ (NSDictionary *)networkType{
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeAdMob IsSDK:YES isApi:NO isAutoOptimize:NO isS2S:NO isSplash:YES];
//}
//
//+ (void)load{
//    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

- (void)getAd{
    isFail = NO;
    isSuccess = NO;
    
    gadsplash = [[GADInterstitial alloc] init];
    gadsplash.delegate = self;
    gadsplash.adUnitID = [self.ration objectForKey:@"key"];
    [gadsplash loadAndDisplayRequest:[GADRequest request]
                                   usingWindow:[splashAds getWindow]
                                  initialImage:[self getBackgroundImage]];
    [self.splashAds adapterDidStartRequestSplashAd:self];
    
}

- (UIImage *)getBackgroundImage{
    NSString *imageName = [self.splashAds getBackgroundImageName];
    UIImage *backgroundImage = nil;
    if (imageName) {
        backgroundImage = [UIImage imageNamed:imageName];
    }
    return backgroundImage;
}

- (void)stopBeingDelegate{
    
}

- (void)dealloc{
    if (gadsplash) {
        gadsplash.delegate = nil;
        [gadsplash release];
        gadsplash = nil;
    }
    [super dealloc];
}

- (void)adSuccess:(id) _awSplash{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [self.splashAds adSplashSuccess:self withSplash:_awSplash];
    }
}

- (void)adFailWith:(NSError *)error{
    NSLog(@"%s",__func__);
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [self.splashAds adSplashFail:self withError:error];
    }
}



- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    [self adSuccess:ad];
//    if ([[UIDevice currentDevice].systemVersion intValue] >= 7) {
//        BOOL status = [UIApplication sharedApplication].statusBarHidden;
//        if (!status) {
//            [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
//        }
//    }
    
}

// Sent when an interstitial ad request completed without an interstitial to
// show.  This is common since interstitials are shown sparingly to users.
- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"Admob Error %@",[error debugDescription]);
    [self adFailWith:error];
}

#pragma mark Display-Time Lifecycle Notifications

// Sent just before presenting an interstitial.  After this method finishes the
// interstitial will animate onto the screen.  Use this opportunity to stop
// animations and save the state of your application in case the user leaves
// while the interstitial is on screen (e.g. to visit the App Store from a link
// on the interstitial).
- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    [self.splashAds adSplash:self WillPresent:ad];
}

// Sent before the interstitial is to be animated off the screen.
- (void)interstitialWillDismissScreen:(GADInterstitial *)ad{
    [self.splashAds adSplash:self WillDismiss:ad];
}

// Sent just after dismissing an interstitial and it has animated off the
// screen.
- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    [self.splashAds adSplash:self didDismiss:ad];
}

// Sent just before the application will background or terminate because the
// user clicked on an ad that will launch another application (such as the App
// Store).  The normal UIApplicationDelegate methods, like
// applicationDidEnterBackground:, will be called immediately before this.
- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad{

}

@end
