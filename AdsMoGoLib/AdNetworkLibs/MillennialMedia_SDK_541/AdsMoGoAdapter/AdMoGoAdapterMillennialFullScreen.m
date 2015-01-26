//
//  AdMoGoAdapterMillennialFullScreen.m
//  wanghaotest
//
//  Created by MOGO on 13-1-24.
//
//

#import "AdMoGoAdapterMillennialFullScreen.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

#define kMillennialAdFrame (CGRectMake(0, 0, 320, 53))

@interface AdMoGoAdapterMillennialFullScreen (){
    AdMoGoConfigData *configData;
}


@end


@implementation AdMoGoAdapterMillennialFullScreen



+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMillennial;
}

+(void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    isReady = NO;
    
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
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
        
    AdViewType type =[configData.ad_type intValue];
    savedType = type;
    if (type == AdViewTypeFullScreen ||
        type == AdViewTypeiPadFullScreen) {
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
        apID = [self.ration objectForKey:@"key"];
        //Replace YOUR_APID with the APID provided to you by Millennial Media
//        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut60 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        [self adapterDidStartRequestAd:self];
        [MMInterstitial fetchWithRequest:request
                                    apid:apID
                            onCompletion:^(BOOL success, NSError *error) {
                                if (isStop) {
                                    return;
                                }
                                [self stopTimer];
                                if (success) {
                                    isReady = YES;
                                    [self adapter:self didReceiveInterstitialScreenAd:nil];
                                }
                                else {
                                   [self adapter:self didFailAd:error];
                                }
                            }];
       
        
    }
    else{
        [self adapter:self didFailAd:nil];
    }
    
}

- (void)stopBeingDelegate {
    [self stopTimer];
    [[NSNotificationCenter defaultCenter]  removeObserver:self];
}

- (void)stopAd{
    isStop = YES;
    [self stopTimer];
}

- (void)dealloc {
    
    //    [fullAdView release];
    //    fullAdView = nil;
	
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
    [self adapter:self didFailAd:nil];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{

    if ([MMInterstitial isAdAvailableForApid:apID]) {
        [MMInterstitial displayForApid:apID
                    fromViewController:[self rootViewControllerForPresent]
                       withOrientation:0
                          onCompletion:^(BOOL success, NSError *error) {
                              if (success) {
                                  [self adapter:self didShowAd:nil];
                              }
                          }];
    }
}

#pragma mark MMAdDelegate methods



- (void)adModalWillAppear:(NSNotification *)notification {
    if (isStop) {
        return;
    }
    [self adapter:self willPresent:nil];
}

- (void)adModalDidAppear:(NSNotification *)notification {

}

- (void)adModalWillDismiss:(NSNotification *)notification {

}

- (void)adModalDidDismiss:(NSNotification *)notification {
    if (isStop) {
        return;
    }
    [self adapter:self didDismissScreen:nil];
}

- (void)adWasTapped:(NSNotification *)notification{
    [self specialSendRecordNum];
}


@end