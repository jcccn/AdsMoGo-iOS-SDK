//
//  AdMoGoAdapterGuomobInterstitial.m
//  wanghaotest
//
//  Created by MOGO on 13-9-27.
//
//

#import "AdMoGoAdapterGuomobInterstitial.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"
@implementation AdMoGoAdapterGuomobInterstitial

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeGuomob;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeGuomob IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}


- (void)getAd {
    isReady = NO;
    isSuccess = NO;
    isFail = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    
    AdViewType type =[configData.ad_type intValue];

    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
            
            interstitialAD=[[GMInterstitialAD alloc] initWithId:[self.ration objectForKey:@"key"]];
            interstitialAD.delegate=self; //必须实现
            [interstitialAD loadInterstitialAd:YES];
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
    if (interstitialAD.delegate) {
        interstitialAD.delegate = nil;
    }
    
    if([interstitialAD superview])
    {
        [interstitialAD removeFromSuperview];
    }
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)stopAd{
    if (interstitialAD.delegate) {
        interstitialAD.delegate = nil;
    }
    isStop = YES;
    [self stopBeingDelegate];
}

- (void)dealloc {
    [self stopTimer];
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)loadAdTimeOut:(NSTimer*)theTimer{
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    if (interstitialAD.delegate) {
        interstitialAD.delegate = nil;
    }
    [interstitial adapter:self didFailAd:nil];
}

- (void)presentInterstitial{
    
    
    if([interstitialAD superview])
    {
        [interstitialAD removeFromSuperview];
    }
    UIViewController* viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    
    [viewController.view addSubview:interstitialAD];
        
}

- (void)loadInterstitialAdSuccess:(BOOL)success{
    if (isStop) {
        return;
    }
    [self stopTimer];
    
    if (success) {
        isReady = YES;
        [self isSuccess];
    }else{
        [self isFail:nil];
    }
}

- (void)InterstitialConnectionDidFailWithError:(NSError *)error{
    [self isFail:error];
}

- (void)closeInterstitialAD{
    if (isStop) {
        return;
    }
     [interstitial adapter:self didDismissScreen:nil];
}

- (void)isSuccess{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [interstitial adapter:self didReceiveInterstitialScreenAd:nil];
    }
}

- (void)isFail:(NSError *)error{
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [interstitial adapter:self didFailAd:nil];

    }
}

@end
