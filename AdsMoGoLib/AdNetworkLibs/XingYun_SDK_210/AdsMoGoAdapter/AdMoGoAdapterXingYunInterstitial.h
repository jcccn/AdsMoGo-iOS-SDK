//
//  AdMoGoAdapterXingYunInterstitial.h
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import <AdWalker/PobFrameWall.h>
@interface AdMoGoAdapterXingYunInterstitial : AdMoGoAdNetworkInterstitialAdapter<PobFrameWallDelegate>
{
    BOOL isStop;
    NSTimer *timer;
    BOOL isLoaded;
    CGRect initAdChinaFrame;
}
@end
