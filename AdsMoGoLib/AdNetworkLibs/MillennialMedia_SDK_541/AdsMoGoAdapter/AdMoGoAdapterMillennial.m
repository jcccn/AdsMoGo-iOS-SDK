//
//  File: AdMoGoAdapterMillennial.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterMillennial.h"
//#import "AdMoGoView.h"
//#import "AdMoGoConfig.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

#define kMillennialAdFrame (CGRectMake(0, 0, 320, 53))

@interface AdMoGoAdapterMillennial (){
    AdMoGoConfigData *configData;
}


@end


@implementation AdMoGoAdapterMillennial

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeMillennial IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMillennial;
}

+(void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    [adMoGoCore adapter:self didGetAd:@"millennial"];

    NSString *apID = [self.ration objectForKey:@"key"];

    
    // Notification will fire when an ad is tapped.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adWasTapped:)
                                                 name:MillennialMediaAdWasTapped
                                               object:nil];
    
    // Notification will fire when an ad modal will appear.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adModalWillAppear:)
                                                 name:MillennialMediaAdModalWillAppear
                                               object:nil];
    
    // Notification will fire when an ad modal did appear.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adModalDidAppear:)
                                                 name:MillennialMediaAdModalDidAppear
                                               object:nil];
    
    // Notification will fire when an ad modal will dismiss.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adModalWillDismiss:)
                                                 name:MillennialMediaAdModalWillDismiss
                                               object:nil];
    
    // Notification will fire when an ad modal did dismiss.
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adModalDidDismiss:)
                                                 name:MillennialMediaAdModalDidDismiss
                                               object:nil];
    

    BOOL islocation = [configData islocationOn];
    MMRequest *request = nil;
    if (islocation) {
        NSArray *location_ary = [configData.curLocation componentsSeparatedByString:@","];
        id latitude;
        id longitude;
        latitude = [location_ary objectAtIndex:1];
        longitude = [location_ary objectAtIndex:0];
        if (latitude && [latitude isKindOfClass:[NSString class]] && longitude && [longitude isKindOfClass:[NSString class]]) {
            CLLocation *currentLocation = [[[CLLocation alloc]
                                            initWithLatitude:[latitude doubleValue]
                                            longitude:[longitude doubleValue]] autorelease];
             request = [MMRequest requestWithLocation:currentLocation];
        }
        else{
            request = [MMRequest request];
        }
    }else{
        request = [MMRequest request];
    }
    
    
    
    
    
    AdViewType type =[configData.ad_type intValue];
    
    CGRect frame = CGRectZero;
    switch (type) {
        case AdViewTypeLargeBanner:
            frame = CGRectMake(0,0,728,90);
            break;
        case AdViewTypeNormalBanner:
        case AdViewTypeMediumBanner:
        case AdViewTypeiPadNormalBanner:
            frame = CGRectMake(0,0,320,50);
            break;
        case AdViewTypeRectangle:
            frame = CGRectMake(0,0,300,250);
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    // Replace YOUR_APID with the APID provided to you by Millennial Media
    MMAdView *banner = [[MMAdView alloc] initWithFrame:frame apid:apID
                                    rootViewController:[adMoGoDelegate viewControllerForPresentingModalView]];
    self.adNetworkView = banner;
    [banner release];
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    [banner getAdWithRequest:request onCompletion:^(BOOL success, NSError *error) {
        if (isStop) {
            return;
        }
        [self stopTimer];
        if (success) {
            MGLog(MGT,@"BANNER AD REQUEST SUCCEEDED");
            [adMoGoCore adapter:self didReceiveAdView:adNetworkView];
        }
        else {
            MGLog(MGT,@"BANNER AD REQUEST FAILED WITH ERROR: %@", error);
            [adMoGoCore adapter:self didFailAd:error];
        }
    }];
}

- (void)stopBeingDelegate {
    MGLog(MGT,@"MM stopBeingDelegate");
    [self stopTimer];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
//	MMAdView *adView = (MMAdView *)self.adNetworkView;
//	if (adView != nil) {
//        adView.refreshTimerEnabled = NO;
//		adView.delegate = nil;
//	}
//    if (fullAdView) {
//        fullAdView.delegate = nil;
//        [fullAdView release];
//        fullAdView = nil;
//    }
    
}

- (void)stopAd{
    isStop = YES;
    [self stopTimer];
}

- (void)dealloc {
    MGLog(MGT,@"dealloc mm");
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
    
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}



#pragma mark MMSDK Notifications methods

- (void)adModalWillAppear:(NSNotification *)notification {
    
    if (isStop) {
        return;
    }
    
    [self helperNotifyDelegateOfFullScreenModal];
    
}



- (void)adModalDidAppear:(NSNotification *)notification {

}


- (void)adModalWillDismiss:(NSNotification *)notification {
    
}

- (void)adWasTapped:(NSNotification *)notification {
    if (isStop) {
        return;
    }
}

- (void)adModalDidDismiss:(NSNotification *)notification {
    
    if (isStop) {
        return;
    }
    
    [self helperNotifyDelegateOfFullScreenModalDismissal];
    
}


@end