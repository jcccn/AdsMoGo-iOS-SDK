//
//  AdMoGoAdapterMobiSageFullAd.h
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "MobiSageSDK.h"
@interface AdMoGoAdapterMbSFullAd : AdMoGoAdNetworkInterstitialAdapter<MobiSageFloatWindowDelegate>
{
    NSTimer *timer;
    BOOL isStop;
    BOOL isError;
    BOOL isReady;
    BOOL isPresent;
    MobiSageFloatWindow *adPoster;
}
+ (AdMoGoAdNetworkType)networkType;

//+ (NSDictionary *)networkType;

- (void)loadAdTimeOut:(NSTimer*)theTimer;

@end
