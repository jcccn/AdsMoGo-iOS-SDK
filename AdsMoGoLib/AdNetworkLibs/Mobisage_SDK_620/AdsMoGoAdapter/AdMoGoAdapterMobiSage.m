//  File: AdMoGoAdapterMobiSage.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//  Copyright 2011 AdsMogo.com. All rights reserved.


#import "AdMoGoAdapterMobiSage.h"
//#import "AdMoGoView.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKBannerNetworkRegistry.h"
#import  "MobiSageSDK.h"



@implementation AdMoGoAdapterMobiSage


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMobiSage;
}

+(void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    isStopTimer = NO;
    isSuccess = NO;
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
	[adMoGoCore adapter:self didGetAd:@"mobisage"];

    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }

    
    
    [[MobiSageManager getInstance] setPublisherID:[self.ration objectForKey:@"key"]];

     AdViewType type =[configData.ad_type intValue];
    UIView *view = nil;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            adView = [[MobiSageBanner alloc] initWithDelegate:self adSize:Banner_iphone];
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320.0, 50.0)];
            break;
        case AdViewTypeLargeBanner:
            adView = [[MobiSageBanner alloc] initWithDelegate:self adSize:Banner_ipad];
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0,728.0, 90.0)];
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }

    
    [view addSubview:adView];
    self.adNetworkView = view;
    [adView release];
    [view release];
    
    
}

- (void)stopBeingDelegate {
    MobiSageBanner *_adView = (MobiSageBanner *)[[self.adNetworkView subviews] lastObject];
	if (_adView != nil) {
        _adView.delegate = nil;
    }
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    [self stopTimer];
}

- (void)stopTimer {
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
    
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)dealloc {
    isStop = YES;
	[super dealloc];
}



#pragma mark -
#pragma mark MobiSageAdBannerDelegate method
/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site, in app purchase时需要使用当前广告所在的控制器。
 * 返回：一个视图控制器对象
 * 说明：如果没有实现此回调，将使用keyWindow.rootViewController
 */
- (UIViewController*)viewControllerToPresent{
    UIViewController *rootCon = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (rootCon == nil) {
        rootCon = [adMoGoDelegate viewControllerForPresentingModalView];
    }
    return rootCon;
}


/**
 *  adBanner被点击
 *  @param adBanner
 */
- (void)mobiSageBannerClick:(MobiSageBanner*)adBanner{
     [adMoGoCore mobisageSendCLK:self];
}


/**
 *  adBanner请求成功并展示广告
 *  @param adBanner
 */
- (void)mobiSageBannerSuccessToShowAd:(MobiSageBanner*)adBanner{
    if (isSuccess) {
        return;
    }
    isSuccess = YES;
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
}

/**
 *  adBanner请求失败
 *  @param adBanner
 */
- (void)mobiSageBannerFaildToShowAd:(MobiSageBanner*)adBanner{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:nil];
}

/**
 *  adBanner被点击后弹出LandingPage
 *  @param adBanner
 */
- (void)mobiSageBannerPopADWindow:(MobiSageBanner*)adBanner{
    if (isStop) {
        return;
    }
    [adMoGoCore stopTimer];
    [self helperNotifyDelegateOfFullScreenModal];
}

/**
 *  adBanner弹出的LandingPage被关闭
 *  @param adBanner
 */
- (void)mobiSageBannerHideADWindow:(MobiSageBanner*)adBanner{
    if (isStop) {
        return;
    }
    [adMoGoCore fireTimer];
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
