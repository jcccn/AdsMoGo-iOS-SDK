//
//  AdMoGoAdapterGoogleAdMobFullAds.h
//  TestMOGOSDKAPP
//
//  Created by 孟令之 on 12-12-3.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@interface AdMoGoAdapterGoogleAdMobFullAds : AdMoGoAdNetworkInterstitialAdapter<GADInterstitialDelegate>{
    GADInterstitial *gadinterstitial;
    BOOL isStop;
    NSTimer *timer;
    BOOL isReady;
}
//+ (NSDictionary *)networkType;
+ (AdMoGoAdNetworkType)networkType;
@end
