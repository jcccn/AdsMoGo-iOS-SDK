//
//  AdMoGoAdapterLimeiInterstitial.h
//  wanghaotest
//
//  Created by MOGO on 13-9-11.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "PagodaPearl.h"

@interface AdMoGoAdapterZSHDInterstitial : AdMoGoAdNetworkInterstitialAdapter<PagodaPearlDelegate>
{
    NSTimer *timer;
    BOOL isReady;
    BOOL isStopTimer;
    BOOL isStop;
    BOOL isRequest;
    BOOL iserror;
}
+ (AdMoGoAdNetworkType)networkType;
@end
