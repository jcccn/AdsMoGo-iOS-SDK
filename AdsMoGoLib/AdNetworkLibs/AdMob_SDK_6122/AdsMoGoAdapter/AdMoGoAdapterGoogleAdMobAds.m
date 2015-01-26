//
//  File: AdMoGoAdapterGoogleAdMobAds.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterGoogleAdMobAds.h"
#import "AdMoGoAdNetworkConfig.h"
//#import "AdMoGoView.h"
#import "GADBannerView.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKBannerNetworkRegistry.h"

@implementation AdMoGoAdapterGoogleAdMobAds


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdMob;
}

+ (void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


// converts UIColor to hex string, ignoring alpha.
- (NSString *)hexStringFromUIColor:(UIColor *)color {
	CGColorSpaceModel colorSpaceModel =
	CGColorSpaceGetModel(CGColorGetColorSpace(color.CGColor));
	if (colorSpaceModel == kCGColorSpaceModelRGB
		|| colorSpaceModel == kCGColorSpaceModelMonochrome) {
		const CGFloat *colors = CGColorGetComponents(color.CGColor);
		CGFloat red = 0.0, green = 0.0, blue = 0.0;
		if (colorSpaceModel == kCGColorSpaceModelRGB) {
			red = colors[0];
			green = colors[1];
			blue = colors[2];
			// we ignore alpha here.
		} else if (colorSpaceModel == kCGColorSpaceModelMonochrome) {
			red = green = blue = colors[0];
		}
		return [NSString stringWithFormat:@"%02X%02X%02X",
                (int)(red * 255), (int)(green * 255), (int)(blue * 255)];
	}
	return nil;
}

- (NSObject *)delegateValueForSelector:(SEL)selector {
	return ([adMoGoDelegate respondsToSelector:selector]) ?
	[adMoGoDelegate performSelector:selector] : nil;
}

- (void)getAd {
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
	GADRequest *request = [[GADRequest request] retain];
	NSObject *value;
	
	NSMutableDictionary *additional = [NSMutableDictionary dictionary];
    
    /*
     获取广告类型
     原来代码：AdViewType type = adMoGoView.adType;
     */
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
	
	
	
	CLLocation *location =
	(CLLocation *)[self delegateValueForSelector:@selector(locationInfo)];
	
    if (location == nil) {
        
        NSArray *location_ary = [configData.curLocation componentsSeparatedByString:@","];
        id latitude;
        id longitude;
        latitude = [location_ary objectAtIndex:1];
        longitude = [location_ary objectAtIndex:0];
        if (latitude && [latitude isKindOfClass:[NSString class]] && longitude && [longitude isKindOfClass:[NSString class]]) {
            if ([latitude intValue] == 0 && [longitude intValue] == 0) {
                return;
            }
            
            /*2013*/
            location = [[[CLLocation alloc]
                        initWithLatitude:[latitude doubleValue] 
                        longitude:[longitude doubleValue]] autorelease];
        }
     }
    
	if ([configData islocationOn] && (location)) {
		[request setLocationWithLatitude:location.coordinate.latitude
							   longitude:location.coordinate.longitude
								accuracy:location.horizontalAccuracy];
	}
	
	NSString *string =
	(NSString *)[self delegateValueForSelector:@selector(gender)];
	
	if ([string isEqualToString:@"m"]) {
		request.gender = kGADGenderMale;
	} else if ([string isEqualToString:@"f"]) {
		request.gender = kGADGenderFemale;
	} else {
		request.gender = kGADGenderUnknown;
	}
	
	if ((value = [self delegateValueForSelector:@selector(dateOfBirth)])) {
		request.birthday = (NSDate *)value;
	}
	
	if ((value = [self delegateValueForSelector:@selector(keywords)])) {
		request.keywords = [NSMutableArray arrayWithArray:(NSArray *)value];
	}
    
    /*
     2013
    */
    BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
    if (testMode) {
        request.testDevices = [NSArray arrayWithObjects:GAD_SIMULATOR_ID,nil];
    }
	
    
    AdViewType type = [configData.ad_type intValue];
    
    GADAdSize size = kGADAdSizeBanner;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = kGADAdSizeBanner;
            break;
        case AdViewTypeRectangle:
        case AdViewTypeiPhoneRectangle:
            size = kGADAdSizeMediumRectangle;
            break;
        case AdViewTypeMediumBanner:
            size = kGADAdSizeFullBanner;
            break;
        case AdViewTypeLargeBanner:
            size = kGADAdSizeLeaderboard;
            break;
        default:
            [adMoGoCore adapter:self didGetAd:@"admob"];
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }

	GADBannerView *view = [[GADBannerView alloc] initWithAdSize:size];
	
	view.adUnitID = [self publisherId];
	view.delegate = self;
	view.rootViewController =
	[adMoGoDelegate viewControllerForPresentingModalView];

    self.adNetworkView = view;
     /*2013*/
    [view release];
	[view loadRequest:request];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)stopBeingDelegate {
    /*2013*/
	GADBannerView *_adMobView = (GADBannerView *)self.adNetworkView;
    if (_adMobView != nil) {
        [_adMobView performSelector:@selector(setDelegate:) withObject:nil];
        //adMobView.delegate = nil;
        [_adMobView performSelector:@selector(setRootViewController:) withObject:nil];
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
    isStop = YES;
    [self stopTimer];
}
- (void)dealloc {
    [self stopTimer];
    [super dealloc];
}
#pragma mark Ad Request Lifecycle Notifications
- (void)adViewDidReceiveAd:(GADBannerView *)adView {
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didGetAd:@"admob"];
	[adMoGoCore adapter:self didReceiveAdView:adView];
}
- (void)adView:(GADBannerView *)adView
didFailToReceiveAdWithError:(GADRequestError *)error {
    
    MGLog(MGE,@"admob error-->%@",error);
    
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didGetAd:@"admob"];
	[adMoGoCore adapter:self didFailAd:error];
}

#pragma mark Click-Time Lifecycle Notifications
- (void)adViewWillPresentScreen:(GADBannerView *)adView {
    
    if (isStop) {
        return;
    }
    
	[self helperNotifyDelegateOfFullScreenModal];
}
- (void)adViewDidDismissScreen:(GADBannerView *)adView {
    
    if (isStop) {
        return;
    }
    
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

#pragma mark parameter gathering methods
- (SEL)delegatePublisherIdSelector {

	return @selector(admobPublisherID);
}

- (NSString *)publisherId {
    
    if (isStop) {
        return @"";
    }
    
	SEL delegateSelector = [self delegatePublisherIdSelector];
	if ((delegateSelector) &&
		([adMoGoDelegate respondsToSelector:delegateSelector])) {
		return [adMoGoDelegate performSelector:delegateSelector];
	}
	return [self.ration objectForKey:@"key"];
}

@end