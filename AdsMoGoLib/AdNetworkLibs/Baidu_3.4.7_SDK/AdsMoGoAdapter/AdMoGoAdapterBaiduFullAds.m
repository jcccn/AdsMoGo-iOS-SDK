//
//  AdMoGoAdapterBaiduFullAds.m
//  TestV1.3.1
//
//  Created by wang hao on 13-9-17.
//
//

#import "AdMoGoAdapterBaiduFullAds.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"


#define kAdMoGoBaiduAppInterstitialIDKey @"AppID"
#define kAdMoGoBaiduAppInterstitialSecretKey @"AppSEC"

@implementation AdMoGoAdapterBaiduFullAds

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeBaiduMobAd;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

//+ (NSDictionary *)networkType{
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeBaiduMobAd IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load{
//    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

- (void)getAd{
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    isLocationOn = [configData islocationOn];
    baiduInterstitial = [[BaiduMobAdInterstitial alloc] init];
    baiduInterstitial.delegate = self;
    baiduInterstitial.interstitialType = BaiduMobAdViewTypeInterstitialRefresh;
    [baiduInterstitial load];
    [interstitial adapterDidStartRequestAd:self];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO];
    }
    else{
        timer = [NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] ;
    }
}

- (void)stopTimer{
    @synchronized(self){
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
    }
    
}
-(void)stopBeingDelegate{
    if(baiduInterstitial){
        baiduInterstitial.delegate = nil;
        [baiduInterstitial release],baiduInterstitial = nil;
    }

}
- (BOOL)isReadyPresentInterstitial{
    return baiduInterstitial.isReady;
}

- (void)presentInterstitial{
    UIViewController *viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];    
    [baiduInterstitial presentFromRootViewController:viewController];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [interstitial adapter:self didFailAd:nil];
}
-(void)dealloc{
    [super dealloc];
}
#pragma mark BaiduMobAdInterstitialDelegate 
/**
 *  应用在mounion.baidu.com上的id
 */
- (NSString *)publisherId{
    NSString *publishId = [[self.ration objectForKey:@"key"] objectForKey:@"AppID"];
    return publishId;
}

/**
 *  应用在mounion.baidu.com上的计费名
 */
- (NSString*) appSpec{
    NSString *appSpec = [[self.ration objectForKey:@"key"] objectForKey:@"AppSEC"];
    return appSpec;

}

/**
 *  渠道id
 */
- (NSString*) channelId{
    return @"13b50d6f";
}



/**
 *  启动位置信息
 */
-(BOOL) enableLocation{
    return isLocationOn;
}

/**
 *  广告预加载成功
 */
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)_interstitial{
    [self stopTimer];
    [interstitial adapter:self didReceiveInterstitialScreenAd:baiduInterstitial];
}

/**
 *  广告预加载失败
 */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)_interstitial{
    [self stopTimer];
    [interstitial adapter:self didFailAd:nil];
}

/**
 *  广告即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)_interstitial{
    [interstitial adapter:self WillPresent:baiduInterstitial];
}

/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)_interstitial{
    
}

/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)_interstitial withError:(BaiduMobFailReason) reason{
    [self stopTimer];
    [interstitial adapter:self didFailAd:nil];
}

/**
 *  广告展示结束
 */
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)_interstitial{
    [interstitial adapter:self didDismissScreen:_interstitial];
}


@end
