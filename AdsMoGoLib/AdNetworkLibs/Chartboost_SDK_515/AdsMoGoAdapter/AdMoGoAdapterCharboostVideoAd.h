//
//  AdMoGoAdapterCharboostVideoAd.h
//  wanghaotest
//
//  Created by MOGO on 15-4-2.
//
//
#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import <Chartboost/Chartboost.h>

@interface AdMoGoAdapterCharboostVideoAd : AdMoGoAdNetworkInterstitialAdapter<ChartboostDelegate>{
    Chartboost *cb;
    NSTimer *timer;
    BOOL isStop;
    BOOL isReady;
    BOOL isClose;
}

@end
