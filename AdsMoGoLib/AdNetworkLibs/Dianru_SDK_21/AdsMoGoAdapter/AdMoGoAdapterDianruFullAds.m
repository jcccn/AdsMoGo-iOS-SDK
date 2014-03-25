//
//  AdMoGoAdapterDianruFullAds.m
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 13-12-31.
//
//

#import "AdMoGoAdapterDianruFullAds.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"

@implementation AdMoGoAdapterDianruFullAds


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeDianru;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    
    isStop = NO;
    isStopTimer = NO;
    callNum = 0;
    isPresnt = NO;
    isreceived = NO;
    isDianruDisappear = NO;
    [interstitial adapterDidStartRequestAd:self];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];    
    AdViewType type = [configData.ad_type intValue];
    
    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
            break;
            
        default:
            [interstitial adapter:self didFailAd:nil];
            break;
    }
    
}

- (BOOL)isReadyPresentInterstitial{
    return YES;
}

- (void)presentInterstitial{
    if (isPresnt == YES) {
        return;
    }else{
        isPresnt = YES;
        [DianRuSDK requestAdmobileViewWithDelegate:self];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
}

- (void)stopBeingDelegate{
    
}

- (void)stopAd{
    
    [self stopBeingDelegate];
    isStop = YES;
}

- (void)dealloc{
    [self stopTimer];
    [super dealloc];
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

- (void)loadAdTimeOut:(NSTimer *)theTimer{
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [interstitial adapter:self didFailAd:nil];
}

#pragma mark - DianRuSDKDelegate
- (NSString *)applicationKey{
    return [self.ration objectForKey:@"key"];
}

- (int) adType{
    return 1;
}

//- (NSString *)keyWords
//{
//    return @"生活";
//}

- (UIViewController *)viewControllerForPresentingModalView{
    return [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
}

- (void)didReceiveAdView:(UIView *)adView{
    MGLog(MGT,@"%s",__func__);
    callNum++;
    if (callNum < 3) {
        return;
    }
    if(isStop){
        return;
    }
    if (isreceived) {
        return;
    }
    [self stopTimer];
    
    UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    adView.bounds = uiViewController.view.bounds;
    [uiViewController.view addSubview:adView];
    isreceived = YES;
    [interstitial adapter:self didReceiveInterstitialScreenAd:adView];
}

//- (int)adDisplayTime{
//    return 6;
//}

- (void)adDisappearResult:(BOOL)isDisappear
{
    if (isDianruDisappear) {
        return;
    }
    if (isDisappear == YES) {
        [interstitial adapter:self didDismissScreen:nil];
        isDianruDisappear = YES;
    }
}
@end
