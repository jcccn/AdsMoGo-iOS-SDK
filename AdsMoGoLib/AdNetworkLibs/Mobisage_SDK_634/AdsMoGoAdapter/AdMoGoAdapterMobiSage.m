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

    AdViewType type =[configData.ad_type intValue];
    NSString *publishID = [[self.ration objectForKey:@"key"] objectForKey:@"PublisherID"];
    [[MobiSageManager getInstance] setPublisherID:publishID];
    
    NSString *slotToken = [[self.ration objectForKey:@"key"] objectForKey:@"slotToken"];
//    NSLog(@"pulishID %@,slotToken %@",publishID,slotToken);
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            adView = [[MobiSageBanner alloc]initWithDelegate:self
                                                      adSize:Banner_iphone
                                                   slotToken:slotToken
                                                intervalTime:Ad_NO_Refresh
                                             switchAnimeType:noAnime];
            break;
        case AdViewTypeLargeBanner:
            adView = [[MobiSageBanner alloc] initWithDelegate:self
                                                       adSize:Banner_ipad
                                                    slotToken:slotToken
                                                 intervalTime:Ad_NO_Refresh
                                              switchAnimeType:noAnime];
            break;
        default:
            MGLog(MGD, @"mobiSage 对这种广告形式不支持");
            break;
    }
    
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    self.adNetworkView = adView;
    [adView release];
}

- (void)stopBeingDelegate {
    
    adView.delegate = nil;
    
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
    adView.delegate = nil;
	[super dealloc];
}


#pragma mark -
#pragma mark MobiSageBannerDelegate method

- (UIViewController *)viewControllerToPresent{
    return [self.adMoGoDelegate viewControllerForPresentingModalView];
}

//横幅广告成功展示时,触发此回调方法,用于统计广告展示数
- (void)mobiSageBannerSuccessToShowAd:(MobiSageBanner *)adBanner{
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

//横幅广告被点击时,触发此回调方法,用于统计广告点击数
- (void)mobiSageBannerClick:(MobiSageBanner *)adBanner{
    [adMoGoCore mobisageSendCLK:self];
}

//横幅广告展示失败时,触发此回调方法
- (void)mobiSageBannerFaildToShowAd:(MobiSageBanner*)adBanner withError:(NSError*) error{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:error];
}

//横幅广告点击后,打开 LandingSite 时,触发此回调方法,请勿释放横幅广告
- (void)mobiSageBannerPopADWindow:(MobiSageBanner*)adBanner{
    if (isStop) {
        return;
    }
    [adMoGoCore stopTimer];
    [self helperNotifyDelegateOfFullScreenModal];
}

//关闭 LandingSite 回到应用界面时,触发此回调方法
- (void)mobiSageBannerHideADWindow:(MobiSageBanner*)adBanner{
    if (isStop) {
        return;
    }
    [adMoGoCore fireTimer];
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
