//
//  AdMoGoAdapterAduuInterstitialAds.m
//  wanghaotest
//
//  Created by mogo_wenyand on 13-7-4.
//
//

#import "AdMoGoAdapterAduuInterstitialAds.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
static BOOL isLoadedAduuConfig = NO;
@implementation AdMoGoAdapterAduuInterstitialAds

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAduu;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

//+ (NSDictionary *)networkType{
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeAduu IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load{
//    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

- (void)getAd{
    isStop = NO;
    isReady = NO;
    isStopTimer = NO;
    
    //获取用于展示插屏的UIViewController
//    UIViewController *uiViewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    
   
        if (!isLoadedAduuConfig) {
            isLoadedAduuConfig = YES;
            NSString *appid = nil;
            NSString *appsecret = nil;
            id key = [self.ration objectForKey:@"key"];
            if ([key isKindOfClass:[NSDictionary class]]) {
                appid  = [key objectForKey:@"appid"];
                appsecret = [key objectForKey:@"appsecret"];
                [AduuConfig launchWithAppID:appid appSecret:appsecret channelID:@"62"];
            }
            else{
                [interstitial adapter:self didFailAd:nil];
                return;
            }
        }
        
        AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
        
        AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
        AdViewType type =[configData.ad_type intValue];
        switch (type) {
            case AdViewTypeFullScreen:
            case AdViewTypeiPadFullScreen:
                insertAd = [[AduuInsertAd alloc] init];
                insertAd.delegate = self;
                [insertAd loadingInsertAd];
                [interstitial adapterDidStartRequestAd:self];
                id _timeInterval = [self.ration objectForKey:@"to"];
                if ([_timeInterval isKindOfClass:[NSNumber class]]) {
                    timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
                }
                else{
                    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
                }
                
                break;
            default:
                break;
        }
    
}

- (void)stopBeingDelegate {
    [self stopTimer];
    insertAd.delegate = nil;
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    
}

- (void)dealloc {
    if(insertAd){
        insertAd.delegate = nil;
        [insertAd release],
        insertAd = nil;
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

- (BOOL)isReadyPresentInterstitial{
    return [insertAd isReady];
}

- (void)presentInterstitial{
    // 呈现插屏广告
    if ([insertAd isReady]) {
        [insertAd showInsertAd];
    }else{
        [insertAd loadingInsertAd];
    }
}

/**
 *	获取insertAd数据
 *
 *	@param	insertAd
 */
- (void)didInsertAdRequestFinished:(AduuInsertAd *)_insertAd{
    if (!isReady) {
        isReady = YES;
        [self stopTimer];
        [interstitial adapter:self didReceiveInterstitialScreenAd:_insertAd];
    }
}

/**
 *	获取insertAd数据失败
 *
 *	@param	insertAd
 *	@param	error	错误信息
 */
- (void)didInsertAdRequestFailed:(AduuInsertAd *)insertAd error:(NSError *)error{
    isReady = NO;
    MGLog(MGT,@"Aduu failed---->%@",error);
    [self stopTimer];
    [interstitial adapter:self didFailAd:nil];
}

/**
 *	insertAd 将要呈现
 *
 *	@param	insertAd
 */
- (void)insertAdWillPresentScreen:(AduuInsertAd *)insertAd{
    [self.interstitial adapter:self WillPresent:insertAd];
}

/**
 *	insertAd 消失
 *
 *	@param	insertAd
 */
- (void)insertAdDidDismissScreen:(AduuInsertAd *)insertAd{
     [interstitial adapter:self didDismissScreen:insertAd];
}

/**
 *	点击insertAd
 */
- (void)didClickInsertAd{
    [interstitial specialSendRecordNum];
}

@end
