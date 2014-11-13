//
//  AdMoGoAdapterLimeiInterstitial.h
//  wanghaotest
//
//  Created by MOGO on 13-9-11.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import <MBJoy/MBJoyView.h>
@interface AdMoGoAdapterLMBInterstitial : AdMoGoAdNetworkInterstitialAdapter<MBJoyViewDelegate>
{
    NSTimer *timer;
    NSTimer *timerFail;
    BOOL isReady;
    BOOL isStopTimer;
    BOOL isStop;
    BOOL iserror;
}
@property (nonatomic,retain)  MBJoyView *ad;
+ (AdMoGoAdNetworkType)networkType;
@end
