//
//  AdMoGoAdapterWAPSFullAd.h
//  MoGoSample_iPhone
//
//  Created by MOGO on 13-5-8.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"

@interface AdMoGoAdapterWAPSFullAd : AdMoGoAdNetworkInterstitialAdapter
{
    NSTimer *timer;
    BOOL isReady;
    NSTimer *detachPresentTimer;
    BOOL isPresent;
}
+ (AdMoGoAdNetworkType)networkType;

@end
