//
//  AdMoGoAdapterAduuInterstitialAds.h
//  wanghaotest
//
//  Created by mogo_wenyand on 13-7-4.
//
//
#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "AduuInsertAd.h"
#import "AduuConfig.h"
@interface AdMoGoAdapterAduuInterstitialAds : AdMoGoAdNetworkInterstitialAdapter<AduuInsertAdDelegate>
{
    BOOL isStop;
    NSTimer *timer;
    AduuInsertAd *insertAd;
    BOOL isReady;
    CGAffineTransform inittransform;
    BOOL isStopTimer;
}
+ (AdMoGoAdNetworkType)networkType;
@end
