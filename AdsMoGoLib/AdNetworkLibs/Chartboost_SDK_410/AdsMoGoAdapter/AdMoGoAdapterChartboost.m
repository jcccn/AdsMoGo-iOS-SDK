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
@implementation AdMoGoAdapterChartboost

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeChartboost;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

//+(NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeChartboost IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load {
//    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
//}

- (void)getAd {
    isStop = NO;
    isReady = NO;
    cb = [Chartboost sharedChartboost];
    cb.appId = [[self.ration objectForKey:@"key"] objectForKey:@"AppID"];
    cb.appSignature = [[self.ration objectForKey:@"key"] objectForKey:@"AppSignature"];
    cb.delegate =self;
    [cb startSession];
    [cb cacheInterstitial];
    [interstitial adapterDidStartRequestAd:self];
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}


- (void)stopAd{
     isStop = YES;
    [self stopTimer];
       
}
- (void)stopBeingDelegate{
    Chartboost *boost = [Chartboost sharedChartboost];
    if (self == boost.delegate) {
        boost.delegate = nil;
    }
}

- (void)dealloc{
    [self stopTimer];
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    Chartboost *boost = [Chartboost sharedChartboost];
    if ([boost hasCachedInterstitial]) {
        [boost showInterstitial];
    }
}

- (BOOL)shouldDisplayInterstitial:(NSString *)location{
    if (isStop) {
        return NO;
    }
    [interstitial adapter:self WillPresent:location];
    return YES;
}

// Called when an interstitial has been received and cached.
- (void)didCacheInterstitial:(NSString *)location
{
    if (isStop) {
        return;
    }
    isReady = YES;
    [self stopTimer];
    [interstitial adapter:self didReceiveInterstitialScreenAd:cb];
    
}

// Called when an interstitial has failed to come back from the server
- (void)didFailToLoadInterstitial:(NSString *)location{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [interstitial adapter:self didFailAd:nil];
}

- (void)didClickInterstitial:(NSString *)location{
    [interstitial specialSendRecordNum];
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
    [interstitial adapter:self didFailAd:nil];
}

- (void)didDismissInterstitial:(NSString *)location{
//    [self helperNotifyDelegateOfFullScreenAdModalDismissal];
    [interstitial adapter:self didDismissScreen:location];
}




@end
