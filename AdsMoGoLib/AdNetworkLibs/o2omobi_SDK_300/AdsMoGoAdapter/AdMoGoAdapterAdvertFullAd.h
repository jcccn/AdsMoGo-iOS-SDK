//
//  AdMoGoAdapterAdvertFullAd.h
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoConfigData.h"
#import "BOADInterstitial.h"
@interface AdMoGoAdapterAdvertFullAd : AdMoGoAdNetworkInterstitialAdapter<BOADInterstitialDelegate>
{
    BOOL isStop;
    BOADInterstitial *boadInter;
    NSTimer *timer;
    BOOL isRequest;
    BOOL isStopTimer;
     BOOL isReady;
}
@end
