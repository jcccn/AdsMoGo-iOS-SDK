//
//  AdMoGoAdapterLimeiInterstitial.h
//  wanghaotest
//
//  Created by MOGO on 13-9-11.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import <immobSDK/immobView.h>
@interface AdMoGoAdapterLimeiInterstitial : AdMoGoAdNetworkInterstitialAdapter<immobViewDelegate>
{
    NSTimer *timer;
    BOOL isReady;
    BOOL isStopTimer;
    BOOL isStop;
    immobView *iMFullScreen;
    BOOL iserror;
}
+ (AdMoGoAdNetworkType)networkType;
@end
