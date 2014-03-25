//
//  File: AdMoGoAdapterZestADZ.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterZestADZ.h"
#import "AdMoGoAdNetworkConfig.h"
//#import "AdMoGoView.h"
#import "ZestadzView.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"

@implementation AdMoGoAdapterZestADZ

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeZestADZ IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeZestADZ;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    [adMoGoCore adapter:self didGetAd:@"zestadz"];
    
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
	ZestadzView *zestView = [ZestadzView requestAdWithDelegate:self];
	self.adNetworkView = zestView;
}

- (void)stopBeingDelegate {
    [self stopTimer];
}

- (void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];
}
-(void)stopTimer{
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
    
    [super loadAdTimeOut:theTimer];
    
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}
- (void)dealloc {
	[super dealloc];
}

#pragma mark ZestadzDelegate required methods.
- (NSString *)clientId {
	return [self.ration objectForKey:@"key"];
}

- (UIViewController *)currentViewController {
    
    if (isStop) {
        return nil;
    }
    
	return [adMoGoDelegate viewControllerForPresentingModalView];
}

#pragma mark ZestadzDelegate notification methods
- (void)didReceiveAd:(ZestadzView *)adView {
    
    if (isStop) {
        return;
    }
    [self stopTimer];
	[adMoGoCore adapter:self didReceiveAdView:adView];
}

- (void)didFailToReceiveAd:(ZestadzView *)adView {
    
    if (isStop) {
        return;
    }
    [self stopTimer];
	[adMoGoCore adapter:self didFailAd:nil];
}

- (void)willPresentFullScreenModal {
    if (isStop) {
        return;
    }
    [adMoGoCore stopTimer];
	[self helperNotifyDelegateOfFullScreenModal];
}

- (void)didDismissFullScreenModal {
    if (isStop) {
        return;
    }
    [adMoGoCore fireTimer];
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

#pragma mark ZestadzDelegate config methods
- (UIColor *)adBackgroundColor {
    return nil;
}

- (NSString *)keywords {
    
    if (isStop) {
        return @"iphone ipad ipod";
    }
    
	if ([adMoGoDelegate respondsToSelector:@selector(keywords)]) {
		return [adMoGoDelegate keywords];
	}
	return @"iphone ipad ipod";
}
@end