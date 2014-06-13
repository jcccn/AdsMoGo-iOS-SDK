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

#ifndef k_dianru_btn_size
#define k_dianru_btn_size 250
#endif

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
    [self adapterDidStartRequestAd:self];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    AdViewType type = [configData.ad_type intValue];
    
    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
            break;
            
        default:
            [self adapter:self didFailAd:nil];
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
    [self adapter:self didFailAd:nil];
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
    return [self rootViewControllerForPresent];
}

- (void)didReceiveAdView:(UIView *)adView{
    MGLog(MGT,@"%s",__func__);
    callNum++;
    if (callNum < 2) {
        return;
    }
    if(isStop){
        return;
    }
    if (isreceived) {
        return;
    }
    isreceived = YES;
    [self stopTimer];
    
    UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    adView.bounds = uiViewController.view.bounds;
    [uiViewController.view addSubview:adView];
    
    [self addAdClickListener:adView];
    
    [self adapter:self didReceiveInterstitialScreenAd:adView];
    
    [self adapter:self didShowAd:adView];
    
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
        [self adapter:self didDismissScreen:nil];
        isDianruDisappear = YES;
    }
}

#pragma mark -
#pragma mark adsMogo ad click count
- (void)addAdClickListener:(UIView *) adView{
    
    NSArray *array = [adView subviews];
    for (UIView* subView in array) {
        
        if ([subView isKindOfClass:[UIButton class]] && subView.frame.size.width >= k_dianru_btn_size) {
            [(UIButton *)subView addTarget:self
                                    action:@selector(adDidClick:)
                          forControlEvents:UIControlEventTouchDown];
            
            break;
            
        }
        
    }
    
}

- (void)adDidClick:(id)sender{
    
    [self specialSendRecordNum];
    
}

@end
