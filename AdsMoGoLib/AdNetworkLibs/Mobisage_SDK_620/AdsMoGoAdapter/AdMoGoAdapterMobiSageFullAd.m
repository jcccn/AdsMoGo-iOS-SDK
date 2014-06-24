//
//  AdMoGoAdapterMobiSageFullAd.m
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-8-22.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdapterMobiSageFullAd.h"
#import "AdMoGoAdapterMobiSage.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"

static BOOL isloaded = false; 
@implementation AdMoGoAdapterMobiSageFullAd

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMobiSage;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    isError = NO;
    isReady = NO;
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    
    AdViewType type =[configData.ad_type intValue];

    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
           break;
        default:
            [self adapter:self didFailAd:nil];
            return;
            break;
    }

    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
   
    
    [[MobiSageManager getInstance] setPublisherID:[self.ration objectForKey:@"key"]];
    floatWindow=[[MobiSageFloatWindow alloc] initWithAdSize:Float_size_3 delegate:self];

    
    [self adapterDidStartRequestAd:self];
}

- (void)stopBeingDelegate {
    floatWindow.delegate = nil;
}

- (void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];
}

- (void)stopTimer {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        if (timer) {
            [timer invalidate];
            [timer release];
            timer = nil;
        }
        
    });
    
}

- (void)dealloc {
    isStop = YES;
    if (floatWindow) {
        [floatWindow release];
        floatWindow = nil;
    }
	[super dealloc];
}


- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    if (isReady) {
        [floatWindow showAdvView];
        [self adapter:self willPresent:nil];
        [self adapter:self didShowAd:nil];
    }
    
    
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    isError = YES;
    [self adapter:self didFailAd:nil];
}

- (void)mobiSageFloatClick:(MobiSageFloatWindow*)adFloat{
    [self specialSendRecordNum];
}

- (void)mobiSageFloatClose:(MobiSageFloatWindow*)adFloat{
    [self adapter:self didDismissScreen:self -> floatWindow];
}

- (void)mobiSageFloatSuccessToRequest:(MobiSageFloatWindow*)adFloat{
    if (isStop || isError || isReady) {
        return;
    }
    
    [self stopTimer];
    
    isReady = YES;
    
    [self adapter:self didReceiveInterstitialScreenAd:self.adNetworkView];
}

- (void)mobiSageFloatFaildToRequest:(MobiSageFloatWindow*)adFloat{
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    isError = YES;
    [self adapter:self didFailAd:nil];
}


@end
