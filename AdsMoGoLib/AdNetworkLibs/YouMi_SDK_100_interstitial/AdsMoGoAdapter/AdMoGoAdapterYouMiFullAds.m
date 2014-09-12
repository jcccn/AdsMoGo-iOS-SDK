//
//  AdMoGoAdapterYouMiFullAds.m
//  __DARREN__
//
//  Created by Darren Liu on 14-08-06.
//
//

#import "AdMoGoAdapterYouMiFullAds.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"


#define PLATFORM_NAME @"有米插屏广告"
@implementation AdMoGoAdapterYouMiFullAds

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeYouMi;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    isReady = NO;
    [adMoGoCore adDidStartRequestAd];
    
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
        }
        [self getYouMiAdWithAppID:AppID AppSecret:AppSecret];
    }
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}


- (void)getYouMiAdWithAppID:(NSString *)AppID AppSecret:(NSString *)AppSecret
{
    void(^youMiCallBack)(BOOL ) = ^( BOOL isFinish)
    {
        if (isFinish) {
            isReady = YES;
            [self stopTimer];
            [self adapter:self didReceiveInterstitialScreenAd:nil];
            MGLog(MGD, @"%@请求成功",PLATFORM_NAME);
        }
        else
        {
            if (isStop) {
                return;
            }
            [self stopTimer];
            [self adapter:self didFailAd:nil];
            MGLog(MGD, @"%@请求失败",PLATFORM_NAME);
        }
    };
    void(^youMiClick)(void) = ^{
        if (isStop) {
            return;
        }
        [self specialSendRecordNum];
        MGLog(MGD, @"%@被点击",PLATFORM_NAME);
    };
    
    [YouMiNewSpot launchWithAppid:AppID appSecret:AppSecret];
    [YouMiNewSpot requestSpotADs:NO callBack:youMiCallBack clickCallBack:youMiClick];
    [self adapterDidStartRequestAd:self];
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
    return isReady;
}

- (void)presentInterstitial{
    [self showYouMiAd];
}

- (void)showYouMiAd
{
    [self adapter:self willPresent:nil];
    void(^youMiDismiss)(void) = ^{
        [self adapter:self didDismissScreen:nil];
        MGLog(MGD, @"%@关闭",PLATFORM_NAME);
    };
    [YouMiNewSpot showSpotDismiss:youMiDismiss];
    MGLog(MGD, @"%@显示",PLATFORM_NAME);
    [self adapter:self didShowAd:nil];
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
