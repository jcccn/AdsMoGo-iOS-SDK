//
//  File: AdMoGoAdapterJumpTap.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterJumpTap.h"
//#import "AdMoGoView.h"
//#import "AdMoGoConfig.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdMoGoAdapterJumpTap

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeJumpTap;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

//+ (NSDictionary *)networkType {
//    
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeJumpTap IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

- (void)getAd {
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    [adMoGoCore adapter:self didGetAd:@"jumptap"];
    
	JTAdWidget *widget = [[JTAdWidget alloc] initWithDelegate:self
										   shouldStartLoading:YES];
	widget.frame = CGRectMake(0, 0, 320, 50);
	widget.refreshInterval = 0; // do not self-refresh
	self.adNetworkView = widget;

	[widget release];
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
	// no way to set JTAdWidget's delegate to nil
    [self stopTimer];
}

- (void)stopAd{
    isStop = YES;
    [self stopTimer];
}

- (void)dealloc {
	[super dealloc];
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
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:nil];
}

#pragma mark JTAdWidgetDelegate methods

- (NSString *)publisherId:(id)theWidget {
    
    if (isStop) {
        return @"";
    }
    
//	NSString *pubId = networkConfig.pubId;
//	if (pubId == nil) {
//		NSDictionary *cred = networkConfig.credentials;
//		if (cred != nil) {
//			pubId = [cred objectForKey:@"publisherID"];
//		}
//	}
    id pubId = [self.ration objectForKey:@"key"];
    if (pubId && [pubId isKindOfClass:[NSString class]]) {
        
    }
    else {
        pubId = [[self.ration objectForKey:@"key"] objectForKey:@"PublisherID"];
    }
	return pubId;
}

- (NSString *)site:(id)theWidget {
    
    if (isStop) {
        return @"";
    }

    
//	NSString *siteId = nil;
//    NSDictionary *cred = networkConfig.credentials;
//    if (cred != nil) {
//        siteId = [cred objectForKey:@"siteID"];
//    }
    id siteId = [self.ration objectForKey:@"key"];
    if (siteId && [siteId isKindOfClass:[NSString class]]) {
        
    }
    else {
        siteId = [[self.ration objectForKey:@"key"] objectForKey:@"SiteID"];
    }
	return siteId;
}

- (NSString *)adSpot:(id)theWidget {
    
    if (isStop) {
        return @"";
    }

    
//	NSString *spotId = nil;
//    NSDictionary *cred = networkConfig.credentials;
//    if (cred != nil) {
//        spotId = [cred objectForKey:@"spotID"];
//    }
    id spotId = [self.ration objectForKey:@"key"];
    if (spotId && [spotId isKindOfClass:[NSString class]]) {
        
    }
    else {
        spotId = [[self.ration objectForKey:@"key"] objectForKey:@"SpotID"];
    }

	return spotId;
}

- (BOOL)shouldRenderAd:(id)theWidget {
    
    if (isStop) {
        return NO;
    }

	[adMoGoCore adapter:self didReceiveAdView:theWidget];
	return YES;
}

- (void)beginAdInteraction:(id)theWidget {
    
    if (isStop) {
        return;
    }
    
	[self helperNotifyDelegateOfFullScreenModal];
}

- (void)endAdInteraction:(id)theWidget {
    
    if (isStop) {
        return;
    }
    
	[self helperNotifyDelegateOfFullScreenModalDismissal];
}

- (void)adWidget:(id)theWidget didFailToShowAd:(NSError *)error {
    
    if (isStop) {
        return;
    }
    [self stopTimer];
	[adMoGoCore adapter:self didFailAd:error];
}

- (void)adWidget:(id)theWidget didFailToRequestAd:(NSError *)error {
    
    if (isStop) {
        return;
    }
    [self stopTimer];
	[adMoGoCore adapter:self didFailAd:error];
}

- (BOOL)respondsToSelector:(SEL)selector {
    
    if (isStop) {
        return NO;
    }
    
	if (selector == @selector(location:)
		&& ![adMoGoDelegate respondsToSelector:@selector(locationInfo)]) {
		return NO;
	}
	else if (selector == @selector(query:)
			 && ![adMoGoDelegate respondsToSelector:@selector(keywords)]) {
		return NO;
	}
	else if (selector == @selector(category:)
			 && ![adMoGoDelegate respondsToSelector:@selector(jumptapCategory)]) {
		return NO;
	}
	else if (selector == @selector(adultContent:)
			 && ![adMoGoDelegate respondsToSelector:@selector(jumptapAdultContent)]) {
		return NO;
	}
	return [super respondsToSelector:selector];
}

#pragma mark JTAdWidgetDelegate methods -Targeting
- (NSString *)query:(id)theWidget {
    
    if (isStop) {
        return @"";
    }
    
	return [adMoGoDelegate keywords];
}

#pragma mark JTAdWidgetDelegate methods -General Configuration
- (NSDictionary*)extraParameters:(id)theWidget {
    
    if (isStop) {
        return nil; 
    }
    
	NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:10];
	if ([adMoGoDelegate respondsToSelector:@selector(dateOfBirth)]) {
		NSInteger age = [self helperCalculateAge];
		if (age >= 0)
			[dict setObject:[NSString stringWithFormat:@"%d",age] forKey:@"mt-age"];
	}
	if ([adMoGoDelegate respondsToSelector:@selector(gender)]) {
		NSString *gender = [adMoGoDelegate gender];
		if (gender != nil)
			[dict setObject:gender forKey:@"mt-gender"];
	}
	if ([adMoGoDelegate respondsToSelector:@selector(incomeLevel)]) {
		NSUInteger income = [adMoGoDelegate incomeLevel];
		NSString *level = nil;
		if (income < 15000) {
			level = @"000_015";
		}
		else if (income < 20000) {
			level = @"015_020";
		}
		else if (income < 30000) {
			level = @"020_030";
		}
		else if (income < 40000) {
			level = @"030_040";
		}
		else if (income < 50000) {
			level = @"040_050";
		}
		else if (income < 75000) {
			level = @"050_075";
		}
		else if (income < 100000) {
			level = @"075_100";
		}
		else if (income < 125000) {
			level = @"100_125";
		}
		else if (income < 150000) {
			level = @"125_150";
		}
		else {
			level = @"150_OVER";
		}
		[dict setObject:level forKey:@"mt-hhi"];
	}
	return dict;
}

- (UIColor *)adBackgroundColor:(id)theWidget {
    
    if (isStop) {
        return nil;
    }
    
	return [self helperBackgroundColorToUse];
}

- (UIColor *)adForegroundColor:(id)theWidget {
    
    if (isStop) {
        return nil;
    }

    
	return [self helperTextColorToUse];
}

#pragma mark JTAdWidgetDelegate methods -Location Configuration
- (BOOL)allowLocationUse:(id)theWidget {
    
    if (isStop) {
        return NO;
    }
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
	return [configData islocationOn];
}

- (CLLocation*)location:(id)theWidget {
    
    if (isStop) {
        return nil;
    }
    
	if (![adMoGoDelegate respondsToSelector:@selector(locationInfo)]) {
        CLLocation *location;
        
        AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
        
        AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
        
        NSArray *location_ary = [configData.curLocation componentsSeparatedByString:@","];
        id latitude;
        id longitude;
        latitude = [location_ary objectAtIndex:1];
        longitude = [location_ary objectAtIndex:0];
        if (latitude && [latitude isKindOfClass:[NSString class]] && longitude && [longitude isKindOfClass:[NSString class]]) {
            if ([latitude intValue] == 0 && [longitude intValue] == 0) {
                return nil;
            }
            location = [[CLLocation alloc] 
                        initWithLatitude:[latitude doubleValue] 
                        longitude:[longitude doubleValue]];
        }
        return location;
//		return [AdMoGoView sharedLocation];
	}
	return [adMoGoDelegate locationInfo];
}
@end