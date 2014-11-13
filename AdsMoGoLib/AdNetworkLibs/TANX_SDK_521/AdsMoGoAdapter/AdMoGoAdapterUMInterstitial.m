//
//  AdMoGoAdapterUMInterstitial.m
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import "AdMoGoAdapterUMInterstitial.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"

@implementation AdMoGoAdapterUMInterstitial

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeUM;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}
- (void)getAd {
    
}

- (void)stopBeingDelegate {
    [self stopTimer];
    if (dialog.delegate) {
        dialog.delegate = nil;
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
    if (dialog.delegate) {
        dialog.delegate = nil;
    }
    isStop = YES;
    [self stopBeingDelegate];
}


- (void)showAlertView{
    
}


- (void)dealloc {
    [self stopTimer];
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return YES;
}

- (void)loadAdTimeOut:(NSTimer*)theTimer{
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    if (dialog.delegate) {
        dialog.delegate = nil;
    }
    [self adapter:self didFailAd:nil];
}

- (BOOL)ispreloadPlatform{
    return  NO;
}

- (void)presentInterstitial{
    
    isReady = NO;
    isSuccess = NO;
    isFail = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    AdViewType type =[configData.ad_type intValue];
    UIViewController* viewController = [self rootViewControllerForPresent];
    NSString *slotID = [[self.ration objectForKey:@"key"] objectForKey:@"SlotID"];
    
    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
            [self adapterDidStartRequestAd:self];
            dialog = [[MMUInterstitialView alloc] initWithSlotId:slotID controller:viewController mask:YES];
            dialog.delegate = (id<MMUInterstitialViewDelegate>)self;
            [dialog load];
            id _timeInterval = [self.ration objectForKey:@"to"];
            if ([_timeInterval isKindOfClass:[NSNumber class]]) {
                timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
            }
            else{
                timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
            }
            
            break;
        default:
            [self isFail:nil];
            break;
    }
    
//    if (dialog) {
//        [dialog load];
//    }
}
#pragma mark delegate 

- (void)loadFinished:(MMUInterstitialView*)interstitialView{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self isSuccess];
}
- (void)loadFailed:(MMUInterstitialView*)interstitialView error:(NSError*)error{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self isFail:error];
}
- (void)InterstitialViewDidClose:(MMUInterstitialView*)interstitialView{
    if (isStop) {
        return;
    }
    [self adapter:self didDismissScreen:nil];
}
- (void)interstitialViewDidClicked:(MMUInterstitialView *)interstitialView{
    [self sendAdFullClick];
}


- (void)isSuccess{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [self adapter:self didReceiveInterstitialScreenAd:nil];
        [self adapter:self didShowAd:nil];
    }
}

- (void)isFail:(NSError *)error{
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [self adapter:self didFailAd:nil];
        
    }
}


- (void)sendAdFullClick{
    if (isStop) {
        return;
    }
    [self specialSendRecordNum];
}
@end
