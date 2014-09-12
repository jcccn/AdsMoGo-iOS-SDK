//
//  AdMoGoAdapterChartboost.m
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-12-3.
//
//

#import "AdMoGoAdapterChartboost.h"
#import "AdMoGoAdNetworkRegistry.h"

#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"
#import "Chartboost.h"
@implementation AdMoGoAdapterChartboost

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeChartboost;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    isReady = NO;
    
    NSString *appId = [[self.ration objectForKey:@"key"] objectForKey:@"AppID"];
    NSString *appSignature = [[self.ration objectForKey:@"key"] objectForKey:@"AppSignature"];
    [Chartboost startWithAppId:appId appSignature:appSignature delegate:self];
    [[Chartboost sharedChartboost] cacheInterstitial:CBLocationMainMenu];
    [self adapterDidStartRequestAd:self];

    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopAd{
     isStop = YES;
    [self stopTimer];
       
}
- (void)stopBeingDelegate{
    Chartboost *boost = [Chartboost sharedChartboost];
    if (self == boost.delegate) {
        boost.delegate = nil;
    }
}

- (void)dealloc{
    [self stopTimer];
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    if ([[Chartboost sharedChartboost] hasCachedInterstitial:CBLocationMainMenu]){
        [[Chartboost sharedChartboost] showInterstitial:CBLocationMainMenu];
    }
}

// Called when an interstitial has failed to come back from the server
- (void)didFailToLoadInterstitial:(NSString *)location{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
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
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

#pragma  -----

/// All of the delegate methods below are optional.
/// Implement them only when you need to more finely control Chartboost's behavior.

/// Called before requesting an interestitial from the back-end
- (BOOL)shouldRequestInterstitial:(CBLocation)location
{
    NSLog(@"shouldRequestInterstitial");
    return YES;
}

// Called when an interstitial has been displayed on the screen.
- (void)didDisplayInterstitial:(CBLocation)location
{
    NSLog(@"didDisplayInterstitial");
}

/// Called when an interstitial has been received, before it is presented on screen
/// Return NO if showing an interstitial is currently innapropriate, for example if the user has entered the main game mode.
- (BOOL)shouldDisplayInterstitial:(CBLocation)location
{
    NSLog(@"shouldDisplayInterstitial");
    if (isStop) {
        return NO;
    }
    [self adapter:self willPresent:location];
    [self adapter:self didShowAd:location];
    return YES;
    
}

/// Called when an interstitial has been received and cached.
- (void)didCacheInterstitial:(CBLocation)location
{
    if (isStop) {
        return;
    }
    if (isReady) {
        return;
    }
    isReady = YES;

    [self stopTimer];
    [self adapter:self didReceiveInterstitialScreenAd:cb];
}

/// Called when an interstitial has failed to come back from the server
- (void)didFailToLoadInterstitial:(CBLocation)location  withError:(CBLoadError)error
{
    NSLog(@"didFailToLoadInterstitial error%u",error);
}

/// Called when a click is registered, but the user is not fowrwarded to the App Store
- (void)didFailToRecordClick:(CBLocation)location withError:(CBLoadError)error
{
    NSLog(@"didFailToRecordClick error%u", error);
}

/// Called when the user dismisses the interstitial
/// If you are displaying the add yourself, dismiss it now.
- (void)didDismissInterstitial:(CBLocation)location
{
    [self adapter:self didDismissScreen:location];
    NSLog(@"didDismissInterstitial");
}

/// Same as above, but only called when dismissed for a close
- (void)didCloseInterstitial:(CBLocation)location
{
    NSLog(@"didCloseInterstitial");
}

/// Same as above, but only called when dismissed for a click
- (void)didClickInterstitial:(CBLocation)location
{
    [self specialSendRecordNum];
}

///// Implement this method to control the blocking for an age gate.
///// If the method returns NO, the callback should not be used
- (BOOL)shouldPauseClickForConfirmation
{
    NSLog(@"shouldPauseClickForConfirmation");
    return NO;
}

@end
