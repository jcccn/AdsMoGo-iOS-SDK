//
//  AdMoGoAdapterBaiduSplash.m
//  wanghaotest
//
//  Created by mogo on 13-11-15.
//
//

#import "AdMoGoAdapterBaiduSplash.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"
@implementation AdMoGoAdapterBaiduSplash

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeBaiduMobAd;
}

+ (void)load{
    [[AdMoGoAdSDKSplashNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd{
    isFail = NO;
    isSuccess = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:splashAds.config_key];
    isLocationOn = [configData islocationOn];
    baiduSplash = [[BaiduMobAdInterstitial alloc] init];
    baiduSplash.delegate = self;
    baiduSplash.interstitialType = BaiduMobAdViewTypeInterstitialLaunch;
    [baiduSplash load];
    [self.splashAds adapterDidStartRequestSplashAd:self];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut2 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}

- (void)stopTimer{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}
-(void)stopBeingDelegate{
    if(baiduSplash){
        baiduSplash.delegate = nil;
        [baiduSplash release],baiduSplash = nil;
    }
    
}


- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    
    [super loadAdTimeOut:theTimer];
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [self adFailWith:nil];
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
//-(BOOL) enableLocation{
//    return isLocationOn;
//}

/**
 *  广告预加载成功
 */
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)_interstitial{
    [self stopTimer];
    [self adSuccess:_interstitial];
    if (baiduSplash.isReady) {
        UIViewController *viewController = [self.adMoGoSplashAdsDelegate adsMoGoSplashAdsViewControllerForPresentingModalView];
        [baiduSplash presentFromRootViewController:viewController];
    }
}

/**
 *  广告预加载失败
 */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)_interstitial{
    [self stopTimer];
    [self adFailWith:nil];
}

/**
 *  广告即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)_interstitial{
    [self.splashAds adSplash:self WillPresent:_interstitial];
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
    [self adFailWith:nil];
}

/**
 *  广告展示结束
 */
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)_interstitial{
    [self.splashAds adSplash:self didDismiss:_interstitial];
}

- (void)adSuccess:(id) _awSplash{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [self.splashAds adSplashSuccess:self withSplash:_awSplash];
    }
}

- (void)adFailWith:(NSError *)error{
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [self.splashAds adSplashFail:self withError:error];
    }
}

@end
