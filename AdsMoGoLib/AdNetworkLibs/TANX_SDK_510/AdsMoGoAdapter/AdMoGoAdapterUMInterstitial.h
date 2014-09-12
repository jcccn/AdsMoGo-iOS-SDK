//
//  AdMoGoAdapterUMInterstitial.h
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "MMUInterstitialView.h"
@interface AdMoGoAdapterUMInterstitial :  AdMoGoAdNetworkInterstitialAdapter<MMUInterstitialViewDelegate>
{
    MMUInterstitialView *dialog;
    NSTimer *timer;
    BOOL isStop;
    BOOL isReady;
    BOOL isSuccess;
    BOOL isFail;
}

@end
