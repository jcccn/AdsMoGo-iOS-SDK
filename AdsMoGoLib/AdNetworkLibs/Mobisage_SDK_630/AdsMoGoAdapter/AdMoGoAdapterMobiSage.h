//
//  File: AdMoGoAdapterMobiSage.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "MobiSageSDK.h"

@interface AdMoGoAdapterMobiSage : AdMoGoAdNetworkAdapter<MobiSageBannerDelegate> {
	NSTimer *timer;
    MobiSageBanner *adView;
    BOOL isStop;
    BOOL isStopTimer;
    BOOL isSuccess;
}
//+ (NSDictionary *)networkType;
+ (AdMoGoAdNetworkType)networkType;
- (void)loadAdTimeOut:(NSTimer*)theTimer;
@end
