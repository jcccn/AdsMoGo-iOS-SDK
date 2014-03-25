//
//  AdMoGoAdapterAdvertFullAd.m
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import "AdMoGoAdapterAdvertFullAd.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "BTAdvert.h"

#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"

@implementation AdMoGoAdapterAdvertFullAd

+ (AdMoGoAdNetworkType)networkType{
    return AdMogoAdNetworkTypeAdvert;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}
- (void)getAd{
    isStop = NO;
    isRequest = NO;
    isStopTimer = NO;
    isReady=NO;
    //获取用于展示插屏的UIViewController
    
    UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(!uiViewController){
        uiViewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    }
    if(uiViewController){
        AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
        AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
        
        AdViewType type =[configData.ad_type intValue];
        NSString *apikey = nil;
        NSString *apiSecret = nil;
        id key = [self.ration objectForKey:@"key"];
        if ([key isKindOfClass:[NSDictionary class]]) {
            apikey  = [key objectForKey:@"appKey"];
            apiSecret = [key objectForKey:@"appSecret"];
        }
        else{
            [interstitial adapter:self didFailAd:nil];
        }
        if (advertFullScreen == nil) {
            switch (type) {
                case AdViewTypeFullScreen:
                      [BTAdvert registerWithAPIkey:apikey apiSecret:apiSecret];
                    advertFullScreen= [[BTAdvertFullScreen alloc] initWithDelegate:self];
                    [advertFullScreen start];
                    [interstitial adapterDidStartRequestAd:self];
                    break;
                default:
                    [interstitial adapter:self didFailAd:nil];
            }
        }
 
  
        
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
    else{
        [interstitial adapter:self didFailAd:nil];
    }
}

- (void)presentInterstitial{
    if([advertFullScreen superview])
    {
        [advertFullScreen removeFromSuperview];
    }
    UIViewController* viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    [viewController.view addSubview:advertFullScreen];
}

#pragma mark --BannerDelegate

- (void)bannerWillGetAdvert:(BTAdverView *)adverView{
}
- (void)bannerDidGetAdvert:(BTAdverView *)adverView{
    if (isStop) {
        return;
    }
    isReady=YES;
    [self stopTimer];
   [interstitial adapter:self didReceiveInterstitialScreenAd:adverView];
}


- (void)bannerDidFailedGetAdvert:(BTAdverView *)adverView error:(NSError *)error{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [interstitial adapter:self didFailAd:error];
}
-(void)stopBeingDelegate{
    if(advertFullScreen){
        advertFullScreen.delegate = nil;
        [advertFullScreen release],advertFullScreen = nil;
    }
}

- (void)btadInterstitialDidDismissScreen:(BTAdverView *)adverView{
      [interstitial adapter:self didDismissScreen:nil];
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    
}
- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)dealloc {
    if(advertFullScreen){
        advertFullScreen.delegate = nil;
        [advertFullScreen release],advertFullScreen = nil;
    }
    [super dealloc];
}
- (void)stopTimer {
    if (!isStopTimer) {
        isStopTimer = YES;
    }else{
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}
/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [interstitial adapter:self didFailAd:nil];
}
@end
