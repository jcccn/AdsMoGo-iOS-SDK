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
#import "CSLib/CSConnect.h"
typedef NS_ENUM(NSUInteger, CSAdContent) {
    CSAdDefault,
    CSAdRequestSuccess,
    CSAdRequestFail,
    CSAdShowSuccess,
    CSAdShowFail,
};



@interface AdMoGoAdapterWAPSFullAd(){
    CSAdContent adstatus;
}
@end

@implementation AdMoGoAdapterWAPSFullAd

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeWAPS;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //指定获取连接状态的回调方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wapsSuccess:) name:CS_CP_INIT_SUCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wapsFailed:) name:CS_CP_INIT_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wapsFailed:) name:CS_CP_INIT_NULL object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wapsInterstitialAdShow:) name:CS_CP_SHOW_SUCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wapsInterstitialAdClosed:) name:CS_CP_CLOSED object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(wapsInterstitialAdClick:) name:CS_CP_CLICK object:nil];
    
    isReady = NO;
    isPresent = NO;
    adstatus = CSAdDefault;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    AdViewType type =[configData.ad_type intValue];
	if (type == AdViewTypeFullScreen || type == AdViewTypeiPadFullScreen) {
        
        NSString *appid = [[self.ration objectForKey:@"key"] objectForKey:App_ID];
        NSString *pid = [[self.ration objectForKey:@"key"] objectForKey:Pid];
        
        [CSConnect getConnect:appid pid:pid];
        [CSConnect initCP];
    
    }
    
    [self adapterDidStartRequestAd:self];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
    
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

    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (viewController == NULL) {
        viewController = [self rootViewControllerForPresent];
    }
    [CSConnect showCP:viewController];
    
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
    if (adstatus!=CSAdDefault) {
        return;
    }
    adstatus = CSAdRequestSuccess;
    isReady = YES;
    [self stopTimer];
    [self adapter:self didReceiveInterstitialScreenAd:notifyObj];
}

- (void)wapsFailed:(NSNotification*)notifyObj{
    if (adstatus!=CSAdDefault) {
        return;
    }
    if (isReady) {
        return;
    }
    adstatus = CSAdRequestFail;
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
