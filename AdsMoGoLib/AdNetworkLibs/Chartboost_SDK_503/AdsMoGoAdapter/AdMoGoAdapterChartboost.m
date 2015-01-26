//
//  AdMoGoAdapterChartboost.m
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-12-3.
//
//

#import "AdMoGoAdapterChartboost.h"
#import "AdMoGoAdNetworkRegistry.h"

#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"
#import <Chartboost/Chartboost.h>
@implementation AdMoGoAdapterChartboost

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeChartboost;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    isReady = NO;
    
    NSString *appId = [[self.ration objectForKey:@"key"] objectForKey:@"AppID"];
    NSString *appSignature = [[self.ration objectForKey:@"key"] objectForKey:@"AppSignature"];
    
    [Chartboost startWithAppId:appId appSignature:appSignature delegate:self];

    [self adapterDidStartRequestAd:self];

    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    if ([Chartboost hasInterstitial:CBLocationMainMenu]) {
        [self cacheInterstitialSucess];
    }else{
        [Chartboost cacheInterstitial:CBLocationMainMenu];
    }
}

- (void)stopAd{
     isStop = YES;
    [self stopTimer];
       
}
- (void)stopBeingDelegate{
//    Chartboost *boost = [Chartboost sharedChartboost];
//    if (self == boost.delegate) {
//        boost.delegate = nil;
//    }
    
}

- (void)dealloc{
    [self stopTimer];
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    if([Chartboost hasInterstitial:CBLocationMainMenu]){
        [Chartboost showInterstitial:CBLocationMainMenu];
    }
}

- (void)cacheInterstitialSucess
{
    if (isStop) {
        return;
    }
    if (isReady) {
        return;
    }
    isReady = YES;
    
    MGLog(MGD, @"Chartboost插屏缓存成功");
    [self stopTimer];
    [self adapter:self didReceiveInterstitialScreenAd:cb];
}

// Called when an interstitial has failed to come back from the server
- (void)didFailToLoadInterstitial:(NSString *)location{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

#pragma mark - Interstitial Delegate
- (BOOL)shouldRequestInterstitial:(CBLocation)location
{
    return YES;
}

- (BOOL)shouldDisplayInterstitial:(CBLocation)location
{
    MGLog(MGD, @"Chartboost插屏将要展示");
    if (isStop) {
        return NO;
    }
    [self adapter:self willPresent:location];
    [self adapter:self didShowAd:location];
    return YES;
}

- (void)didDisplayInterstitial:(CBLocation)location
{
    MGLog(MGD, @"Chartboost插屏已经展示");
}

- (void)didCacheInterstitial:(CBLocation)location
{
    [self cacheInterstitialSucess];
}

- (void)didFailToLoadInterstitial:(CBLocation)location
                        withError:(CBLoadError)error
{
    MGLog(MGD, @"Chartboost插屏加载失败");
}

- (void)didFailToRecordClick:(CBLocation)location
                   withError:(CBClickError)error
{
    MGLog(MGD, @"Chartboost插屏RecordClick失败");
}

- (void)didDismissInterstitial:(CBLocation)location
{
    MGLog(MGD, @"Chartboost插屏消失");
    [self adapter:self didDismissScreen:location];
}

- (void)didCloseInterstitial:(CBLocation)location
{
    MGLog(MGD, @"Chartboost插屏被关闭");
}

- (void)didClickInterstitial:(CBLocation)location
{
    MGLog(MGD, @"Chartboost插屏被点击");
    [self specialSendRecordNum];
}

@end
