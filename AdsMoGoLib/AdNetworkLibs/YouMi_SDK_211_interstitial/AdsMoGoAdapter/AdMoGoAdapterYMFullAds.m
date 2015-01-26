//
//  AdMoGoAdapterYouMiFullAds.m
//  __DARREN__
//
//  Created by Darren Liu on 14-08-06.
//
//

#import "AdMoGoAdapterYMFullAds.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"


#define PLATFORM_NAME @"有米插屏广告"
@implementation AdMoGoAdapterYMFullAds

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeYM;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    isReady = NO;
}

- (void)myCallBack:(BOOL)checkFinish
{
    checkFinish = YES;
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
    return YES;
}

- (void)presentInterstitial{
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    AdViewType type =[configData.ad_type intValue];
	if (type == AdViewTypeFullScreen || type==AdViewTypeiPadFullScreen) {
        id key = [self.ration objectForKey:@"key"];
        NSString *AppID = @"";
        NSString *AppSecret = @"";
        if ([key isKindOfClass:[NSDictionary class]]) {
            AppID  = [key objectForKey:@"AppID"];
            AppSecret = [key objectForKey:@"AppSecret"];
        }
        else{
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
        
        [self getYouMiAdWithAppID:AppID AppSecret:AppSecret];
    }
}

- (void)getYouMiAdWithAppID:(NSString *)AppID AppSecret:(NSString *)AppSecret
{
    [YouMiNewSpot initYouMiDeveloperParams:AppID YM_SecretId:AppSecret];
    [YouMiNewSpot initYouMiDeveLoperSpot:kSPOTSpotTypeBoth];
    BOOL issuccess = [YouMiNewSpot showYouMiSpotAction:^(BOOL flag){
        if (flag) {
            MGLog(MGP, @"有米插屏展示成功");
        }
        else{
            MGLog(MGP, @"有米插屏展示失败");
        }
        [self adapter:self didDismissScreen:nil];
    }];
    
    [YouMiNewSpot clickYouMiSpotAction:^(BOOL flag){
        if (isStop) {
            return;
        }
        [self specialSendRecordNum];
    }];
    
    [self adapterDidStartRequestAd:self];
    
    if (issuccess) {
        [self stopTimer];
        [self adapter:self didShowAd:nil];
        [self adapter:self didReceiveInterstitialScreenAd:nil];
    }else{
        [self stopTimer];
        [self adapter:self didFailAd:nil];
    }
}

- (void)stopBeingDelegate {
    MGLog(MGP, @"stop begin delegate");
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
