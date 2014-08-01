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

typedef enum AdsMogoBaiduMobInterstitialState
{
    AdsMogoBMobIState_INIT = 0,
    
    AdsMogoBMobIState_LOADSUC,
    
    AdsMogoBMobIState_LOADFAI,
    
    AdsMogoBMobIState_PRESENT,
    
    AdsMogoBMobIState_CLOSED
    
} AdsMogoBMobIState;

@interface AdMoGoAdapterBaiduFullAds()<UIGestureRecognizerDelegate>{
    
    int clickCount;
    AdsMogoBMobIState curState;
}

@end

@implementation AdMoGoAdapterBaiduFullAds

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeBaiduMobAd;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd{
    
    clickCount = 0;

    isStop = NO;

    curState = AdsMogoBMobIState_INIT;

    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    isLocationOn = [configData islocationOn];
    baiduInterstitial = [[BaiduMobAdInterstitial alloc] init];
    baiduInterstitial.delegate = self;
    baiduInterstitial.interstitialType = BaiduMobAdViewTypeInterstitialRefresh;
    
    [baiduInterstitial load];
    [self adapterDidStartRequestAd:self];
    
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
    isStop = YES;
    if(baiduInterstitial){
        baiduInterstitial.delegate = nil;
        [baiduInterstitial release],baiduInterstitial = nil;
    }

}
- (BOOL)isReadyPresentInterstitial{
    return baiduInterstitial.isReady;
}

- (void)presentInterstitial{
    curState = AdsMogoBMobIState_PRESENT;
    UIViewController *viewController = [self rootViewControllerForPresent];
    [baiduInterstitial presentFromRootViewController:viewController];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self failAd];
}
-(void)dealloc{
    isStop = YES;
    [super dealloc];
}

- (void)failAd{
    
    if (curState != AdsMogoBMobIState_INIT) {
        return;
    }
    baiduInterstitial.delegate = nil;
    curState = AdsMogoBMobIState_LOADFAI;
    
    [self adapter:self didFailAd:nil];
    
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

    if (isStop) {
        return;
    }

    curState = AdsMogoBMobIState_LOADSUC;

    [self stopTimer];
    [self adapter:self didReceiveInterstitialScreenAd:baiduInterstitial];
}

/**
 *  广告预加载失败
 */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)_interstitial{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self failAd];
}

/**
 *  广告即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)_interstitial{
    if (isStop) {
        return;
    }
    [self adapter:self willPresent:baiduInterstitial];
}

/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)_interstitial{
    if (isStop) {
        return;
    }
//    [[UIApplication sharedApplication].delegate performSelector:@selector(logViewTreeForMainWindow) withObject:nil];
    [self adapter:self didShowAd:_interstitial];
}

/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)_interstitial withError:(BaiduMobFailReason) reason{
   
    [self stopTimer];

    if (isStop) {
        return;
    }
//    [self adapter:self didFailAd:nil];

    if (curState != AdsMogoBMobIState_INIT) {
        return;
    }
    [self failAd];

}

/**
 *  广告展示结束
 */
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)_interstitial{
    if (isStop) {
        return;
    }
    curState = AdsMogoBMobIState_CLOSED;
    [self adapter:self didDismissScreen:_interstitial];
}

- (void)interstitialDidAdClicked:(BaiduMobAdInterstitial *)interstitial{
    [self specialSendRecordNum];
}





@end
