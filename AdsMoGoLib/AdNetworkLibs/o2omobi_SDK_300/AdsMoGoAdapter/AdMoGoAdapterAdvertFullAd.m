//
//  AdMoGoAdapterAdvertFullAd.m
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#define AdvertFullScreen 0

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
    //获取用于展示插屏的UIViewControllerisStop = NO;
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
#if AdvertFullScreen
                [boadInter loadFullAd];// 加载全屏广告
                
#else
                [boadInter preloadFloatAd];// 加载插屏广告
#endif
                
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
- (void)presentInterstitial{
    if (boadInter.loaded) {// 加载完成，调用|presentFloatAd|显示插屏
#if AdvertFullScreen
        UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        if(!uiViewController){
            uiViewController = [self rootViewControllerForPresent];
        }
        [boadInter presentFromViewController:uiViewController];
#else
        [boadInter presentFloatAd];
#endif
        
    }
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

//- (BOOL)ispreloadPlatform{
//    return  NO;
//}


#pragma mark --BOADMiniFloatDelegate

- (void)boadInterstitialWillLoadAd:(BOADInterstitial *)interstitial {
    MGLog(MGD, @"百灵欧拓插屏广告加载开始");
}
- (void)boadInterstitialDidLoadAd:(BOADInterstitial *)_interstitial {
    if (isStop) {
        return;
    }
    MGLog(MGD, @"百灵欧拓插屏广告加载完毕");
    isReady = YES;
    [self stopTimer];
    
    [self adapter:self didReceiveInterstitialScreenAd:_interstitial];
}
- (void)boadInterstitial:(BOADInterstitial *)_interstitial didFailToReceiveAdWithError:(BOADError *)error {
    
    if (isStop) {
        return;
    }
    MGLog(MGD, @"百灵欧拓插屏广告加载失败");
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}
- (void)boadInterstitialWillPresentScreen:(BOADInterstitial *)_interstitial {
    MGLog(MGD, @"百灵欧拓插屏广告即将显示");
      [self adapter:self willPresent:_interstitial];
}
- (void)boadInterstitialDidPresentScreen:(BOADInterstitial *)interstitial {
    MGLog(MGD, @"百灵欧拓插屏广告已经显示");
    [self adapter:self didShowAd:interstitial];
}
- (void)boadInterstitialWillDismissScreen:(BOADInterstitial *)interstitial {
    MGLog(MGD, @"百灵欧拓插屏广告即将消失");
}
- (void)boadInterstitialDidDismissScreen:(BOADInterstitial *)_interstitial {
    MGLog(MGD, @"百灵欧拓插屏广告已经消失");
    [self adapter:self didDismissScreen:_interstitial];
}
- (void)boadInterstitialDidTapAd:(BOADInterstitial *)_interstitial {
    MGLog(MGD, @"百灵欧拓插屏广告点击广告");
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
    MGLog(MGD, @"百灵欧拓插屏广告加载超时");
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}
@end
