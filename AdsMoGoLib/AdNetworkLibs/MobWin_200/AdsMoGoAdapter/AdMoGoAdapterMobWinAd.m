//  AdMoGoAdapterMobWinAd.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.2.2
//  Created by pengxu on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.


#import "AdMoGoAdapterMobWinAd.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h" 
#import "AdMoGoAdNetworkAdapter+Helpers.h"

#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"

@implementation AdMoGoAdapterMobWinAd

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeMobWinAd IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMobWinAd;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type =[configData.ad_type intValue];
    CGSize size =CGSizeMake(0, 0);
    MobWinBannerSizeIdentifier mobwinSizeID;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            mobwinSizeID = MobWINBannerSizeIdentifier320x50;
            size =CGSizeMake(320, 50);
            break;
        case AdViewTypeRectangle:
            mobwinSizeID = MobWINBannerSizeIdentifier300x250;
            size =CGSizeMake(300, 250);
            break;
        case AdViewTypeMediumBanner:
            mobwinSizeID = MobWINBannerSizeIdentifier468x60;
            size =CGSizeMake(468, 60);
            break;
        case AdViewTypeLargeBanner:
            mobwinSizeID = MobWINBannerSizeIdentifier728x90;
            size =CGSizeMake(728, 90);
            break;
        default:
            break;
    }
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }

    adView = [MobWinBannerView instance];
    adView.adSizeIdentifier = mobwinSizeID;
    adView.rootViewController = [adMoGoDelegate viewControllerForPresentingModalView];
    adView.adIntegrateKey = @"ior0224ace";
    NSString *key = [self.ration objectForKey:@"key"];
    MGLog(MGT,@"%@",key);
    adView.adUnitID = key;
    

    adView.delegate = self;
    [adView startRequest];
    self.adNetworkView = adView;
    [adView release];
}

- (void)dealloc {
	[super dealloc];
}
- (void)bannerViewDidReceived{
    
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    MobWinBannerView *_adView = (MobWinBannerView *)self.adNetworkView;
    [_adView stopRequest];
    [adMoGoCore adapter:self didGetAd:@"mobwin"];
    [adMoGoCore adapter:self didReceiveAdView:adNetworkView];
}
- (void)bannerViewFailToReceived{
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    [adMoGoCore adapter:self didGetAd:@"mobwin"];
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)stopBeingDelegate {

    [self stopTimer];
    
    MobWinBannerView *_adView = (MobWinBannerView *)self.adNetworkView;
	if (_adView != nil) {
        [_adView stopRequest];
		[_adView setDelegate:nil];
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    [self stopBeingDelegate];
    
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}

@end
