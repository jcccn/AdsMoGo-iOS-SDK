//
//  AdMoGoAdapterRmobInterstitial.h
//  wanghaotest
//
//  Created by MOGO on 14-10-31.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoConfigData.h"
#import "RmobInterstitialDelegate.h"
#import "RmobInterstitial.h"

@interface AdMoGoAdapterRmobInterstitial : AdMoGoAdNetworkInterstitialAdapter<RmobInterstitialDelegate>
{
    RmobInterstitial *_rmobInterstitial;
    NSTimer *timer;
    BOOL isStop;
    BOOL isStopTimer;
    BOOL isSuccess;
}
@end
