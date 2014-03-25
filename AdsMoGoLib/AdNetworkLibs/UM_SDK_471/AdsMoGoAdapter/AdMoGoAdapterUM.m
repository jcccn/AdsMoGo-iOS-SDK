//
//  AdMoGoAdapterUM.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//  Created by pengxu on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdapterUM.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#define kAdMoGoTANXClientID @"ClientID"
#define kAdMoGoTANXSlotID @"SlotID"

@implementation AdMoGoAdapterUM



+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeUM;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    CGSize size = CGSizeZero;
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    AdViewType type = [configData.ad_type intValue];
    
    switch (type) {
        case AdViewTypeNormalBanner:
            size = CGSizeMake(320, 50);
            break;
        case AdViewTypeiPadNormalBanner:
            size = CGSizeMake(320, 50);
            break;
        case AdViewTypeMediumBanner:
            size = CGSizeMake(480, 75);
            break;
        default:
            [adMoGoCore adapter:self didGetAd:@"umappunion"];
            [adMoGoCore adapter:self didFailAd:nil];
            return;
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
    
    adView = [[UMUFPBannerView alloc] initWithFrame:CGRectMake(0, 0, size.width, size.height) appKey:[[self.ration objectForKey:@"key"] objectForKey:kAdMoGoTANXClientID] slotId:[[self.ration objectForKey:@"key"] objectForKey:kAdMoGoTANXSlotID] currentViewController:[self.adMoGoDelegate viewControllerForPresentingModalView]];
    adView.delegate = (id<UMUFPBannerViewDelegate>)self;
    self.adNetworkView = adView;
    adView.mIntervalDuration = 700.0f;
    [adView requestPromoterDataInBackground];
    [adView release];
}

- (void)UMUFPBannerView:(UMUFPBannerView *)banner didLoadDataFinish:(NSInteger)promotersAmount {
    
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    [adMoGoCore adapter:self didGetAd:@"um"];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
}

- (void)UMUFPBannerView:(UMUFPBannerView *)banner didLoadDataFailWithError:(NSError *)error {
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    [adMoGoCore adapter:self didGetAd:@"um"];
    [adMoGoCore adapter:self didFailAd:error];
}

- (void) dealloc {
    [super dealloc];
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}

- (void)stopBeingDelegate {
    [self stopTimer];
    UMUFPBannerView *umadView = (UMUFPBannerView *)adNetworkView;
    if(umadView != nil){
        umadView.delegate = nil;
    }
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
    isStop = YES;
    [self stopBeingDelegate];
    
    [adMoGoCore adapter:self didFailAd:nil];
}
@end
