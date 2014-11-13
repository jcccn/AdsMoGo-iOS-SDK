//
//  AdMoGoAdapterZmediaFullScreen.h
//  wanghaotest
//
//  Created by mogo on 14-7-28.
//
//
#import "ZMSDK.h"
#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "ZmediaSingleton.h"
@interface AdMoGoAdapterZmediaFullScreen : AdMoGoAdNetworkInterstitialAdapter<ZmediaSingletonDelegate>
{
    NSTimer *timer;
    BOOL isStop;
    BOOL isError;
    BOOL isReady;
    BOOL isPresent;
    BOOL isSuccess;
}
+ (AdMoGoAdNetworkType)networkType;
- (void)loadAdTimeOut:(NSTimer*)theTimer;
@end
