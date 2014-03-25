//
//  File: AdMoGoAdapterIAd.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterIAd.h"
#import "AdMoGoAdNetworkConfig.h"
//#import "AdMoGoView.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdMoGoAdapterIAd

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeIAd IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	if(NSClassFromString(@"ADBannerView") != nil) {
//		[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//	}
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeIAd;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    /*
     获取广告类型
     原来代码：AdViewType type = adMoGoView.adType;
     */
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    
    
//    AdViewType type = adMoGoView.adType;
    BOOL isBanner = YES;
    if ( (type == AdViewTypeRectangle)||(type == AdViewTypeMediumBanner) ) {
        isBanner = NO;
    }
    if (!isBanner) {
        //MGLog(MGT,@"iAd does not support AdViewTypeRectangle and AdViewTypeMediumBanner");
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
    
    [adMoGoCore adapter:self didGetAd:@"iad"];
    ADBannerView *iAdView = nil;
    if ([ADBannerView instancesRespondToSelector:@selector(initWithAdType:)]) {
        iAdView = [[ADBannerView alloc] initWithAdType:ADAdTypeBanner];
    }else{
        iAdView = [[ADBannerView alloc] initWithFrame:CGRectZero];
        
        kADBannerContentSizeIdentifierPortrait =
        &ADBannerContentSizeIdentifierPortrait != nil ?
        ADBannerContentSizeIdentifierPortrait :
        ADBannerContentSizeIdentifier320x50;
        kADBannerContentSizeIdentifierLandscape =
        &ADBannerContentSizeIdentifierLandscape != nil ?
        ADBannerContentSizeIdentifierLandscape :
        ADBannerContentSizeIdentifier480x32;
        iAdView.requiredContentSizeIdentifiers = [NSSet setWithObjects:
                                                  kADBannerContentSizeIdentifierPortrait,
                                                  kADBannerContentSizeIdentifierLandscape,
                                                  nil];
        UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
        
        if (UIDeviceOrientationIsLandscape(orientation)) {
            iAdView.currentContentSizeIdentifier = kADBannerContentSizeIdentifierLandscape;
        }
        else {
            iAdView.currentContentSizeIdentifier = kADBannerContentSizeIdentifierPortrait;
        }
    }
	
	[iAdView setDelegate:self];
	
	self.adNetworkView = iAdView;
    
	[iAdView release];
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
	ADBannerView *iAdView = (ADBannerView *)self.adNetworkView;
	if (iAdView != nil) {
		iAdView.delegate = nil;
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
    [self stopBeingDelegate];
    [self stopTimer];
    isStop = YES;
}

- (void)rotateToOrientation:(UIInterfaceOrientation)orientation {
	ADBannerView *iAdView = (ADBannerView *)self.adNetworkView;
	if (iAdView == nil) return;
	if (UIInterfaceOrientationIsLandscape(orientation)) {
		iAdView.currentContentSizeIdentifier = kADBannerContentSizeIdentifierLandscape;
	}
	else {
		iAdView.currentContentSizeIdentifier = kADBannerContentSizeIdentifierPortrait;
	}
	// ADBanner positions itself in the center of the super view, which we do not
	// want, since we rely on publishers to resize the container view.
	// position back to 0,0
	CGRect newFrame = iAdView.frame;
	newFrame.origin.x = newFrame.origin.y = 0;
	iAdView.frame = newFrame;
}

- (BOOL)isBannerAnimationOK:(AMBannerAnimationType)animType {
	if (animType == AMBannerAnimationTypeFadeIn) {
		return NO;
	}
	return YES;
}

- (void)dealloc {
	[super dealloc];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}

#pragma mark IAdDelegate methods

- (void)bannerViewDidLoadAd:(ADBannerView *)banner {
    
    if (isStop) {
        return;
    }
    [self stopTimer];
	// ADBanner positions itself in the center of the super view, which we do not
	// want, since we rely on publishers to resize the container view.
	// position back to 0,0
	CGRect newFrame = banner.frame;
	newFrame.origin.x = newFrame.origin.y = 0;
	banner.frame = newFrame;
	
	[adMoGoCore adapter:self didReceiveAdView:banner];
}

- (void)bannerView:(ADBannerView *)banner didFailToReceiveAdWithError:(NSError *)error {
    if (isStop) {
        return;
    }
    [self stopTimer];
    if(banner){
        banner.delegate = nil;
    }
	[adMoGoCore adapter:self didFailAd:error];
}

- (BOOL)bannerViewActionShouldBegin:(ADBannerView *)banner willLeaveApplication:(BOOL)willLeave {
    if (isStop) {
        return NO;
    }
	[self helperNotifyDelegateOfFullScreenModal];
	return YES;
}

- (void)bannerViewActionDidFinish:(ADBannerView *)banner {
    if (isStop) {
        return;
    }
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
