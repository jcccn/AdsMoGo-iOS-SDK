//
//  AdMoGoAdadpterAdermobInterstital.m
//  wanghaotest
//
//  Created by MOGO on 13-5-24.
//
//

#import "AdMoGoAdadpterAdermobInterstital.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"

@implementation AdMoGoAdadpterAdermobInterstital

//+ (NSDictionary *)networkType {
//	return [self makeNetWorkType:AdMoGoAdNetworkTypeAdermob IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdermob;
}
+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
//    isReady = NO;
    isPresent = NO;
    isStopTimer = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    
    AdViewType type =[configData.ad_type intValue];
   
	if (type == AdViewTypeFullScreen ||
        type == AdViewTypeiPadFullScreen) {
        BOOL testMode = [[self.ration objectForKey:@"testmodel"] boolValue];
        if(testMode){
            aderIntersitital = [[AderInterstitial alloc] initWithAppId:[self.ration objectForKey:@"key"]
                                                                AdSize:ADER_INTERSTITIALAD_SIZE_100
                                                              andModel:MODEL_TEST];
        }else{
            aderIntersitital = [[AderInterstitial alloc] initWithAppId:[self.ration objectForKey:@"key"]
                                                                AdSize:ADER_INTERSTITIALAD_SIZE_100
                                                              andModel:MODEL_RELEASE];
        }
        
    }
    
    
    // 设置插屏广告的Delegate
    aderIntersitital.delegate = self;
    // 加载⼀一条插屏广告
    [aderIntersitital loadRequest];
    [interstitial adapterDidStartRequestAd:self];
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut30 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}

- (void)stopBeingDelegate{
    if (aderIntersitital) {
        aderIntersitital.delegate = nil;
    }
}


- (void)stopAd{
    [self stopTimer];
}

- (void)stopTimer{
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

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    [super loadAdTimeOut:theTimer];
    [self stopTimer];
    [interstitial adapter:self didFailAd:nil];
}

- (void)dealloc {
    MGLog(MGT,@"ader intersitital dealloc");
    [self stopTimer];
    if (aderIntersitital) {
        aderIntersitital.delegate = nil;
        [aderIntersitital release];
        aderIntersitital = nil;
    }
	[super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return aderIntersitital.isReady;
}

- (void)presentInterstitial{
    // 在需要呈现插屏广告前，先通过isReady方法检查广告是否就绪
    
        // 呈现插屏广告
    
    UIViewController* viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    if (viewController.navigationController != nil &&
        viewController.parentViewController != nil) {
        viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    [aderIntersitital presentFromRootViewController:viewController];
}

//插屏广告请求成功，可以显示
- (void)aderInterstitialDidReceiveAd{
    [self stopTimer];
    [interstitial adapter:self didReceiveInterstitialScreenAd:aderIntersitital];
}

/*
 接受SDK返回的错误报告
 code 1: 参数错误
 code 2: 服务端错误
 code 3: 应用被冻结
 code 4: 无合适广告
 code 5: 应用账户不存在
 code 6: 频繁请求
 code 7: 广告为空
 code 101: 网络请求失败
 case 102: 广告关闭
 */
//插屏广告请求发生异常
- (void)aderInterstitialDidReceiveError:(NSError *)error{
    [self stopTimer];
    [interstitial adapter:self didFailAd:error];
}

#pragma mark 广告显示相关
//将要显示插屏广告
- (void)aderInterstitialWillPresentScreen{
    [interstitial adapterAdModal:self WillPresent:nil];
}

//将要移除插屏广告
- (void)aderInterstitialWillDismissScreen{
    
}

//插屏广告已被移除
- (void)aderInterstitialDidDismissScreen{
    
    [self performSelectorOnMainThread:@selector(loadNextAdapter)
                               withObject:nil
                            waitUntilDone:NO];
}

- (void)loadNextAdapter{
     [interstitial adapter:self didDismissScreen:nil];
}

- (BOOL)aderInterstitialOpenLocation{
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    BOOL islocation = [configData islocationOn];
    return islocation;
}
@end
