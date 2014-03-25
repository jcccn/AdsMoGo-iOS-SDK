//
//  AdMoGoAdapterDoMobFullAd.h
//  TestMOGOSDKAPP
//
//  
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "DMInterstitialAdController.h"
#import "AdMoGoConfigData.h"

@interface AdMoGoAdapterDoMobFullAd : AdMoGoAdNetworkAdapter<DMInterstitialAdControllerDelegate>{
    BOOL isStop;
    DMInterstitialAdController *_dmInterstitial;
    NSTimer *timer;
    BOOL isRequest;
    BOOL isStopTimer;
}
+ (AdMoGoAdNetworkType)networkType;
@end
