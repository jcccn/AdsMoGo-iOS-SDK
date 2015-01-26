//
//  File: AdMoGoAdapterYouMi.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterYouMi.h"
#import "YouMiView.h"
#import "YouMiConfig.h"
#import "AdMoGoView.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

#define kAdMoGoYoumiAppIDKey @"AppID"
#define kAdMoGoYoumiAppSecretKey @"AppSecret"
static BOOL isCreated = NO;
@implementation AdMoGoAdapterYouMi

//+ (NSDictionary *)networkType {
//    
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeYouMi IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeYouMi;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
	[adMoGoCore adapter:self didGetAd:@"youmi"];
	
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData  *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type =[configData.ad_type intValue];
    
//    AdViewType type = adMoGoView.adType;
    YouMiBannerContentSizeIdentifier youMiSizeID;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            youMiSizeID = YouMiBannerContentSizeIdentifier320x50;
            break;
        case AdViewTypeRectangle:
            youMiSizeID = YouMiBannerContentSizeIdentifier300x250;
            break;
        case AdViewTypeMediumBanner:
            youMiSizeID = YouMiBannerContentSizeIdentifier468x60;
            break;
        case AdViewTypeLargeBanner:
            youMiSizeID = YouMiBannerContentSizeIdentifier728x90;
            break;
        default:
            break;
    }
    
    
    
    if (!isCreated) {
        
        
        isCreated = YES;
        NSString *appID = [[self.ration objectForKey:@"key"] objectForKey:kAdMoGoYoumiAppIDKey];
        NSString *appSecret = [[self.ration objectForKey:@"key"] objectForKey:kAdMoGoYoumiAppSecretKey];
        
        [YouMiConfig launchWithAppID:appID appSecret:appSecret];
        
        
        BOOL islocation = [configData islocationOn];
        if (islocation == NO) {
            [YouMiConfig setShouldGetLocation:NO];
        }
        
        if ([configData istestMode]) {
            [YouMiConfig setIsTesting:YES];
        }
        else {
            [YouMiConfig setIsTesting:NO];
        }
        
    }
    
    
    
    YouMiView *adView = [[YouMiView alloc] initWithContentSizeIdentifier:youMiSizeID
                                                                delegate:self];
    
    
    
    
    
    adView.indicateBackgroundColor = [self helperBackgroundColorToUse];
    adView.textColor = [self helperTextColorToUse];
    adView.indicateRounded = YES;
    self.adNetworkView = adView;
    
    [adView start];
    [adView release];
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
	YouMiView *adView = (YouMiView *)self.adNetworkView;
	if (adView != nil) {
		adView.delegate = nil;
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

#pragma mark YouMiView Delegate 
- (void)didReceiveAd:(YouMiView *)adView {
    
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [adMoGoCore adapter:self didReceiveAdView:adView];
}

- (void)didFailToReceiveAd:(YouMiView *)adView  error:(NSError *)error {
    
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [adMoGoCore adapter:self didFailAd:error];
}

- (void)didPresentScreen:(YouMiView *)adView {
    if (isStop) {
        return;
    }
    [self helperNotifyDelegateOfFullScreenModal];
}

- (void)didDismissScreen:(YouMiView *)adView {
    if (isStop) {
        return;
    }
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}
@end