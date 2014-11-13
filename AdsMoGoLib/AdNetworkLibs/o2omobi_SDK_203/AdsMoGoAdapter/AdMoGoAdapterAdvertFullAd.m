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
#import "BOADMiniFloat.h"
#import "BOAD.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"

@implementation AdMoGoAdapterAdvertFullAd

+ (AdMoGoAdNetworkType)networkType{
    return AdMogoAdNetworkTypeAdvert;
}
+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}
- (void)getAd{
    //获取用于展示插屏的UIViewController
}
- (void)presentInterstitial{
    isStop = NO;
    isRequest = NO;
    isStopTimer = NO;
    isReady=NO;
    UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(!uiViewController){
        uiViewController = [self rootViewControllerForPresent];
    }
    if(uiViewController){
        AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
        AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
        
        AdViewType type =[configData.ad_type intValue];
        NSString *apikey = nil;
        NSString *apiSecret = nil;
        id key = [self.ration objectForKey:@"key"];
        if ([key isKindOfClass:[NSDictionary class]]) {
            apikey  = [key objectForKey:@"appKey"];
            apiSecret = [key objectForKey:@"appSecret"];
        }
        else{
            [self adapter:self didFailAd:nil];
        }
        [BOAD setAppId:apikey appScrect:apiSecret];
        [BOAD setLogEnabled:NO]; //Open DEBUG
        switch (type) {
            case AdViewTypeiPadFullScreen:
            case AdViewTypeFullScreen:
                boadInter = [[BOADInterstitial alloc] init];
                boadInter.delegate = self;// 可以设置委托对象，监听广告状态
                [boadInter loadFloatAd];// 加载插屏广告
                [self adapterDidStartRequestAd:self];
                break;
            default:
                [self adapter:self didFailAd:nil];
                return;
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
        [self adapter:self didFailAd:nil];
    }
}

- (BOOL)ispreloadPlatform{
    return  NO;
}


#pragma mark --BOADMiniFloatDelegate

- (void)boadInterstitialWillLoadAd:(BOADInterstitial *)interstitial {
    // 加载开始
    NSLog(@"%s",__FUNCTION__);
}
- (void)boadInterstitialDidLoadAd:(BOADInterstitial *)_interstitial {
    // 加载完毕
        NSLog(@"%s",__FUNCTION__);
    if (isStop) {
        return;
    }
    isReady = YES;
    [self stopTimer];
    
    [self adapter:self didReceiveInterstitialScreenAd:_interstitial];
}
- (void)boadInterstitial:(BOADInterstitial *)_interstitial didFailToReceiveAdWithError:(BOADError *)error {
    // 加载失败
    
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}
- (void)boadInterstitialWillPresentScreen:(BOADInterstitial *)_interstitial {
    // 即将显示
      [self adapter:self willPresent:_interstitial];
}
- (void)boadInterstitialDidPresentScreen:(BOADInterstitial *)interstitial {
    // 已经显示
    [self adapter:self didShowAd:interstitial];
}
- (void)boadInterstitialWillDismissScreen:(BOADInterstitial *)interstitial {
    // 即将消失
}
- (void)boadInterstitialDidDismissScreen:(BOADInterstitial *)_interstitial {
    // 已经消失
    [self adapter:self didDismissScreen:_interstitial];
}
- (void)boadInterstitialDidTapAd:(BOADInterstitial *)_interstitial {
    // 点击广告
     [self specialSendRecordNum];
}


-(void)stopBeingDelegate{
    if (boadInter) {
        [boadInter release],boadInter=nil;
    }
}


- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    
}
- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)dealloc {
 
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
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}
@end
