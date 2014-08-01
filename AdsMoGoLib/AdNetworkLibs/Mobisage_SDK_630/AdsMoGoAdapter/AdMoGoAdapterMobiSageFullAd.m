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

//static BOOL isloaded = false; 
@implementation AdMoGoAdapterMobiSageFullAd

//+ (NSDictionary *)networkType {
//	return [self makeNetWorkType:AdMoGoAdNetworkTypeMobiSage IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
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
    isPresent = NO;
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
   
    
    [[MobiSageManager getInstance] setPublisherID:[[self.ration objectForKey:@"key"] objectForKey:@"PublisherID"]];
    
    adPoster = [[MobiSageFloatWindow alloc] initWithAdSize:Float_size_0
                                                  delegate:self
                                                 slotToken:[[self.ration objectForKey:@"key"] objectForKey:@"slotToken"]];

    
    [self adapterDidStartRequestAd:self];
}

- (void)stopBeingDelegate {
    adPoster.delegate = nil;
//    [adPoster release],adPoster = nil;
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
    if (adPoster) {
        adPoster.delegate = nil;
        [adPoster release], adPoster = nil;
    }
	[super dealloc];
}


- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{

    isPresent = YES;
    [adPoster showAdvView];
    [self adapter:self willPresent:nil];
    [self adapter:self didShowAd:nil];
    
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop || isError || isReady ||isPresent) {
        return;
    }
    isError = YES;
    if (adPoster) {
        adPoster.delegate = nil;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}
#pragma mark -
#pragma mark MobiSageFloatWindowDelegate method




//插屏广告预加载成功时,触发此回调方法,建议在此回调方法触发之后,再调用插屏广告的展示方法
- (void)mobiSageFloatSuccessToRequest:(MobiSageFloatWindow *)adFloat{
    if (isStop || isError || isReady ||isPresent) {
        return;
    }
    
    [self stopTimer];
    
    isReady = YES;
    
    [self adapter:self didReceiveInterstitialScreenAd:adPoster];
}

//插屏广告被点击时,触发此回调方法,多用于聚合中统计广告点击数
- (void)mobiSageFloatClick:(MobiSageFloatWindow *)adFloat{
    [self specialSendRecordNum];
}

//插屏广告预加载失败时,触发此回调方法,多用于聚合
- (void)mobiSageFloatFaildToRequest:(MobiSageFloatWindow *)adFloat{
    if (isStop || isError || isReady ||isPresent) {
        return;
    }
    
    isError = YES;
    
    if (adPoster) {
        adPoster.delegate = nil;
    }
    
    [self stopTimer];
    
    [self adapter:self didFailAd:nil];

}

- (void)mobiSageFloatClose:(MobiSageFloatWindow*)adFloat{
    [self adapter:self didDismissScreen:adFloat];
}

@end
