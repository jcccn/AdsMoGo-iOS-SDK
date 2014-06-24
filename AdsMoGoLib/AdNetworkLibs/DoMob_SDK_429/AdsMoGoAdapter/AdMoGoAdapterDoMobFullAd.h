//
//  AdMoGoAdapterDoMobFullAd.h
//  TestMOGOSDKAPP
//
//  
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "DMInterstitialAdController.h"
#import "AdMoGoConfigData.h"

@interface AdMoGoAdapterDoMobFullAd : AdMoGoAdNetworkInterstitialAdapter<DMInterstitialAdControllerDelegate>{
    BOOL isStop;
    DMInterstitialAdController *_dmInterstitial;
    NSTimer *timer;
    BOOL isRequest;
    BOOL isStopTimer;
}
+ (AdMoGoAdNetworkType)networkType;
@end
