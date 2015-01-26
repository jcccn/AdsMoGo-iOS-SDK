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
#import "WPLib/AppConnect.h"
#if iscocos2d
    #import "WPLib/WapsPopAdController.h"
#endif

@implementation AdMoGoAdapterWAPSFullAd

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
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    AdViewType type =[configData.ad_type intValue];
    [WPLog setLogThreshold:LOG_DEBUG];
	if (type == AdViewTypeFullScreen ) {
        
        NSString *appid = [[self.ration objectForKey:@"key"] objectForKey:App_ID];
        NSString *pid = [[self.ration objectForKey:@"key"] objectForKey:Pid];
        [AppConnect getConnect:appid pid:pid];
        [AppConnect initPop];
    
    }
    
    [self adapterDidStartRequestAd:self];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //指定获取连接状态的回调方法
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wapsSuccess:) name:WP_POPAD_INIT_SUCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wapsFailed:) name:WP_POPAD_INIT_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wapsInterstitialAdShow:) name:WP_POPAD_SHOW_SUCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wapsInterstitialAdClosed:) name:WP_POPAD_CLOSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wapsInterstitialAdClick:) name:WP_POPAD_CLICKED object:nil];
    
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
    UIViewController *viewController = [self rootViewControllerForPresent];
    [AppConnect showPop:viewController];
    
#endif
    detachPresentTimer = [[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(isPresented:) userInfo:nil repeats:NO] retain];
}

#pragma mark TimerOut
/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

- (void)isPresented:(NSTimer*)theTimer {
    [self stopPresentTimer];
    if (!isPresent) {
        [self adapter:self didDismissScreen:nil];
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
    [self adapter:self didReceiveInterstitialScreenAd:notifyObj];
}

- (void)wapsFailed:(NSNotification*)notifyObj{
    if (isReady) {
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}

- (void)wapsInterstitialAdShow:(NSNotification*)notifyObj
{
    isPresent = YES;
    [self stopPresentTimer];
    [self adapter:self willPresent:notifyObj];
    [self adapter:self didShowAd:notifyObj];
}
- (void)wapsInterstitialAdClosed:(NSNotification*)notifyObj
{
    [self adapter:self didDismissScreen:notifyObj];
}


-(void)wapsInterstitialAdClick:(NSNotification*)notifyObj{
     [self specialSendRecordNum];
}

@end
