//
//  AdMoGoAdapterGoogleAdMobFullAds.m
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-12-3.
//
//

#import "AdMoGoAdapterGoogleAdMobFullAds.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"
@implementation AdMoGoAdapterGoogleAdMobFullAds

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdMob;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd{
    isStop = NO;
    isReady = NO;
    [adMoGoCore adDidStartRequestAd];
    /*
     获取广告类型
     原来代码：AdViewType type = adMoGoView.adType;
     */
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    AdViewType type =[configData.ad_type intValue];
    
	if (type == AdViewTypeFullScreen || type==AdViewTypeiPadFullScreen) {
        gadinterstitial = [[GADInterstitial alloc] init];
        gadinterstitial.delegate = self;
        gadinterstitial.adUnitID = [self.ration objectForKey:@"key"];
        GADRequest *request = [GADRequest request];
        request.testDevices = [NSArray arrayWithObjects:                               // 
                               nil];
        [gadinterstitial loadRequest:request];
        [self adapterDidStartRequestAd:self];
    }
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }

}

- (void)stopBeingDelegate{
    gadinterstitial.delegate = nil;
    if (gadinterstitial) {
        [gadinterstitial release];
        gadinterstitial = nil;
    }
}

- (void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];
}

- (void)dealloc{
    [self stopTimer];
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    // 呈现插屏广告
    [gadinterstitial presentFromRootViewController:[self rootViewControllerForPresent]];
}

- (void)interstitialDidReceiveAd:(GADInterstitial *)ad{
    if (isStop) {
        return;
    }
    isReady = YES;
    [self stopTimer];

    [self adapter:self didReceiveInterstitialScreenAd:ad];
}

- (void)interstitial:(GADInterstitial *)ad
didFailToReceiveAdWithError:(GADRequestError *)error{
    if (isStop) {
        return;
    }
    [self stopTimer];
    MGLog(MGE,@"admob's fullScreen ad is failed :%@",error);
    [self adapter:self didFailAd:nil];
}

- (void)interstitialWillLeaveApplication:(GADInterstitial *)ad{
    [self specialSendRecordNum];
}

- (void)interstitialDidDismissScreen:(GADInterstitial *)ad{
    [self adapter:self didDismissScreen:ad];
}


- (void)interstitialWillPresentScreen:(GADInterstitial *)ad{
    [self adapter:self willPresent:ad];
    [self adapter:self didShowAd:ad];
}


- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

@end
