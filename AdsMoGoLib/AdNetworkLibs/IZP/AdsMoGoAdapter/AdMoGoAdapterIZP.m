//
//  File: AdMoGoAdapterAdwo.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterIZP.h"
//#import "AdMoGoView.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h" 
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdMoGoAdapterIZP
static BOOL isFirst = YES;
static IZPView *adView = nil;

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeIZP IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeIZP;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
//    AdViewType type = adMoGoView.adType;
    
    /*
     获取广告类型
     原来代码：AdViewType type = adMoGoView.adType;
     */
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    
    
    Model model;
//    if (networkConfig.testMode) {
    if ([configData istestMode]) {
        model = MODEL_TEST;
    }
    else {
        model = MODEL_RELEASE;
    }
    if (isFirst) {
        [IZPView setPID:[self.ration objectForKey:@"key"] adType:AD_TYPE_BANNER model:model];
        isFirst = NO;
    }
    if (type == AdViewTypeNormalBanner) {
        if (adView == nil) {
            adView = [[IZPView alloc] initWithFrame:CGRectMake(0, 0, 320, 48)];
        }
    }
    else if (type == AdViewTypeLargeBanner) {
        if (adView == nil) {
            adView = [[IZPView alloc] initWithFrame:CGRectMake(0, 0, 728, 90)];
        }
    }
    [adView start];
    [adView setDelegate:self];
    self.adNetworkView = adView;

//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopBeingDelegate {
    IZPView *adView = (IZPView *)self.adNetworkView;
    [adView pause];
    if(adView != nil)
    {
        [adView setDelegate:nil];
    }
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    [self stopTimer];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)dealloc {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
	[super dealloc];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didGetAd:@"izp"];
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)didReceiveFreshAd:(IZPView*)view adCount:(NSInteger)count {
    
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [adMoGoCore adapter:self didGetAd:@"izp"];
    [adMoGoCore adapter:self didReceiveAdView:view];
}
 
- (void)didStopFullScreenAd:(IZPView*)view {
 
}

- (void)willLeaveApplication:(IZPView*)adView {

}

-(BOOL)shouldRequestFreshAd:(IZPView*)view {
    return YES;
}
-(BOOL)shouldShowFreshAd:(IZPView*)view {
    return YES;
}

-(void)didShowFreshAd:(IZPView*)view {

}


- (void) errorReport:(NSInteger)code erroInfo:(NSString*) info {
    
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    IZPView *adView = (IZPView *)self.adNetworkView;
    [adView pause];
    [adMoGoCore adapter:self didGetAd:@"izp"];
    [adMoGoCore adapter:self didFailAd:nil];
}

@end