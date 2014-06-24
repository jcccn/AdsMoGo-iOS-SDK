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
@interface AdMoGoAdapterMobiSageFullAd : AdMoGoAdNetworkInterstitialAdapter<MobiSageFloatWindowDelegate>
{
    NSTimer *timer;
    BOOL isStop;
    BOOL isError;
    BOOL isReady;
    MobiSageFloatWindow
    *floatWindow;
}
+ (AdMoGoAdNetworkType)networkType;


- (void)loadAdTimeOut:(NSTimer*)theTimer;

@end
