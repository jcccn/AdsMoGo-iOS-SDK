//
//  AdMoGoAdapterWAPSFullAd.m
//  MoGoSample_iPhone
//
//  Created by MOGO on 13-5-8.
//
//

// 注 如果使用cocos2d中添加万普插屏广告
// iscocos2d 设置为1
// 否则设置 0，默认为0
#define iscocos2d 0

#define App_ID @"App_ID"

#define Pid @"pid"

#import "AdMoGoAdapterWAPSFullAd.h"

#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "WapsOffer/AppConnect.h"
#if iscocos2d
    #import "WapsOffer/WapsPopAdController.h"
#endif

@implementation AdMoGoAdapterWAPSFullAd

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeWAPS IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeWAPS;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isReady = NO;
    isPresent = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    
    AdViewType type =[configData.ad_type intValue];
    [WapsLog setLogThreshold:LOG_DEBUG];
	if (type == AdViewTypeFullScreen ) {
        
        NSString *appid = [[self.ration objectForKey:@"key"] objectForKey:App_ID];
        NSString *pid = [[self.ration objectForKey:@"key"] objectForKey:Pid];
        [AppConnect getConnect:appid pid:pid];
        [AppConnect initPopAd];
    
    }
    
    [interstitial adapterDidStartRequestAd:self];
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut60 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //指定获取连接状态的回调方法
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wapsSuccess:) name:WAPS_CONNECT_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wapsFailed:) name:WAPS_CONNECT_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wapsInterstitialAdShow:) name:WAPS_POPAD_SHOW object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wapsInterstitialAdClosed:) name:WAPS_POPAD_CLOSED object:nil];
     
    
}

- (void)stopAd{
    [self stopTimer];
    [self stopPresentTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopBeingDelegate {
    
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

-(void)presentInterstitial{
#if iscocos2d    
    [[[CCDirector sharedDirector] openGLView] addSubview:[[WapsPopAdController alloc]
                                                          init].view];
#else
    UIViewController *viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    [AppConnect showPopAd:viewController];
    
#endif
    detachPresentTimer = [[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(isPresented:) userInfo:nil repeats:NO] retain];
}

#pragma mark TimerOut
/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [interstitial adapter:self didFailAd:nil];
}

- (void)isPresented:(NSTimer*)theTimer {
    [self stopPresentTimer];
    if (!isPresent) {
        [interstitial adapter:self didDismissScreen:nil];
    }
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)stopPresentTimer{
    if (detachPresentTimer) {
        [detachPresentTimer invalidate];
        [detachPresentTimer release];
        detachPresentTimer = nil;
    }
}

- (void)wapsSuccess:(NSNotification*)notifyObj{
    isReady = YES;
    [self stopTimer];
    [interstitial adapter:self didReceiveInterstitialScreenAd:notifyObj];
}

- (void)wapsFailed:(NSNotification*)notifyObj{
    if (isReady) {
        return;
    }
    [self stopTimer];
    [interstitial adapter:self didFailAd:nil];
}

- (void)wapsInterstitialAdShow:(NSNotification*)notifyObj
{
    isPresent = YES;
    [self stopPresentTimer];
    [interstitial adapter:self WillPresent:notifyObj];
}
- (void)wapsInterstitialAdClosed:(NSNotification*)notifyObj
{
    [interstitial adapter:self didDismissScreen:notifyObj];
}

@end
