//
//  AdMoGoAdapterVungleVideoAd.m
//  TestMOGOSDKAPI
//
//  Created by Daxiong on 13-8-8.
//  Copyright (c) 2013年 Daxiong. All rights reserved.
//
#import <VungleSDK/VungleSDK.h>
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdapterVungleVideoAd.h"

@interface AdMoGoAdapterVungleVideoAd ()<VungleSDKDelegate>{
    
    BOOL isStop;
    BOOL isReady;
    UIViewController *_viewController;
    NSTimer *timer;
}
@end

@implementation AdMoGoAdapterVungleVideoAd

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeVungle;
}
+ (void)load {
	[[AdMoGoAdSDKVideoNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    isReady = NO;
    
    [self adapterDidStartRequestAd:self];
  
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    AdViewType type =[configData.ad_type intValue];
    if (type != AdViewTypeVideo) {
        MGLog(MGT,@"not video ad type");
        [self adapter:self didFailAd:nil];
        return;
    }
    
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO];
    }
    else{
        timer = [NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO];
    }
    
    _viewController = [self rootViewControllerForPresent];
    VungleSDK * vungle= [VungleSDK sharedSDK];
    NSString*    appID = [self.ration objectForKey:@"key"];
    vungle.delegate=self;
    // set up config data
    [vungle startWithAppId:appID];
    
    
}

- (void)stopBeingDelegate{
    [self stopTimer];
    VungleSDK * vungle= [VungleSDK sharedSDK];
    id delegate = vungle.delegate;
    if (delegate && [delegate isKindOfClass:[AdMoGoAdNetworkAdapter class]]) {
        if (delegate == self) {
            [vungle setDelegate:nil];
        }
    }
}

- (void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];
}
- (BOOL)isReadyPresentInterstitial{
    return isReady;
}
-(void)playVideoAd{

    if (_viewController && isReady){
        [self adapter:self willPresent:nil];
        VungleSDK * vungle= [VungleSDK sharedSDK];
        NSError * error;
        [vungle playAd:_viewController error:&error];
        if (error.code ==VungleSDKErrorCannotPlayAd) {
             [self adapter:self didFailAd:nil];
        }
        
    }
    else {
        MGLog(MGT,@"Ad Not Yet Available or no view controller to show");
    }
}
#pragma mark -
#pragma mark VGVunglePubDelegate

- (void)vungleSDKwillShowAd{
}


- (void)vungleSDKwillCloseAdWithViewInfo:(NSDictionary*)viewInfo willPresentProductSheet:(BOOL)willPresentProductSheet{
    [self adapter:self didDismissScreen:nil];
}

- (void)vungleSDKwillCloseProductSheet:(id)productSheet{
   
    [self adapter:self didDismissScreen:nil];
}


-(void)vungleSDKhasCachedAdAvailable{
    if (!isReady) {
        isReady=YES;
        [self stopTimer];
        [self adapter:self didReceiveInterstitialScreenAd:nil];
    }
}
 
#pragma mark -
#pragma mark timer time out method
- (void)loadAdTimeOut:(NSTimer*)theTimer{
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self adapter:self didFailAd:nil];
    
}
- (void)stopTimer {
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
}


@end
