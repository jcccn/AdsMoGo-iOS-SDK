//
//  AdMoGoAdadpterAdermobInterstital.h
//  wanghaotest
//
//  Created by MOGO on 13-5-24.
//
//
#import "AderInterstitial.h"
#import "AdMoGoAdNetworkAdapter.h"

@interface AdMoGoAdadpterAdermobInterstital : AdMoGoAdNetworkAdapter<AderInterstitialDelegate>
{
    BOOL isReady;
    BOOL isPresent;
    AderInterstitial *aderIntersitital;
    NSTimer *timer;
    BOOL isStopTimer;
}
+ (AdMoGoAdNetworkType)networkType;

@end
