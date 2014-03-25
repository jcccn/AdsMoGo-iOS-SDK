//
//  AdMoGoAdapterInmobiSDKFullScreen.m
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-11-21.
//
//

#import "AdMoGoAdapterInmobiSDKFullScreen.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"

@implementation AdMoGoAdapterInmobiSDKFullScreen

//+ (NSDictionary *)networkType {
//	return [self makeNetWorkType:AdMoGoAdNetworkTypeInMobi IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeInMobi;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    isReady = NO;
    canRemove = YES;

    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    
    AdViewType type =[configData.ad_type intValue];

	if (type == AdViewTypeFullScreen||
        type == AdViewTypeiPadFullScreen) {
        
//        [InMobi setLogLevel:IMLogLevelNone];
        [InMobi setLogLevel:IMLogLevelDebug];
        [InMobi initialize:[self.ration objectForKey:@"key"]];
        
        interstitialAd = [[IMInterstitial alloc] initWithAppId:[self.ration objectForKey:@"key"]];
        interstitialAd.delegate = self;
        [interstitialAd loadInterstitial];
        [interstitial adapterDidStartRequestAd:self];
//        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut60 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }else{
        [interstitial adapter:self didFailAd:nil];
    }
}

-(void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}

-(void)stopBeingDelegate{
    
    if(interstitialAd && canRemove){
        NSLog(@"%s",__FUNCTION__);
        interstitialAd.delegate = nil;
        [interstitialAd release],interstitialAd = nil;
    }
}

-(void)dealloc{
    
    if(interstitialAd && canRemove){
        interstitialAd.delegate = nil;
        [interstitialAd release],interstitialAd = nil;
    }
    
    [super dealloc];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [interstitial adapter:self didFailAd:nil];
}


- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    // 呈现插屏广告
//    UIViewController *viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    if (interstitialAd.state == kIMInterstitialStateReady) {
        [interstitialAd presentInterstitialAnimated:YES];
    }else{
        
        NSLog(@"%s ad is not ready",__FUNCTION__);
        
    }
    
}
#pragma mark -
#pragma mark Inmobi delegate

/**
 * Sent when an interstitial ad request succeeded.
 * @param ad The IMInterstitial instance which finished loading.
 */
- (void)interstitialDidReceiveAd:(IMInterstitial *)ad{
    if(isStop){
        return;
    }
    [self stopTimer];
    
    isReady = YES;
    [interstitial adapter:self didReceiveInterstitialScreenAd:nil];
}

/**
 * Sent when an interstitial ad request failed
 * @param ad The IMInterstitial instance which failed to load.
 * @param error The IMError associated with the failure.
 */
- (void)interstitial:(IMInterstitial *)ad
didFailToReceiveAdWithError:(IMError *)error{
    NSLog(@"inMobi error-->%@",error);
    if(isStop){
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [interstitial adapter:self didFailAd:error];

}

/**
 * Sent just before presenting an interstitial.  After this method finishes the
 * interstitial will animate onto the screen.  Use this opportunity to stop
 * animations and save the state of your application in case the user leaves
 * while the interstitial is on screen (e.g. to visit the App Store from a link
 * on the interstitial).
 * @param ad The IMInterstitial instance which will present the screen.
 */
- (void)interstitialWillPresentScreen:(IMInterstitial *)ad{
    if(isStop){
        return;
    }
    canRemove = NO;
    [interstitial adapter:self WillPresent:ad];

}

/**
 * Sent before the interstitial is to be animated off the screen.
 * @param ad The IMInterstitial instance which will dismiss the screen.
 */
- (void)interstitialWillDismissScreen:(IMInterstitial *)ad{
    NSLog(@"%s",__FUNCTION__);
}

/**
 * Sent just after dismissing an interstitial and it has animated off the screen.
 * @param ad The IMInterstitial instance which was responsible for dismissing the screen.
 */
- (void)interstitialDidDismissScreen:(IMInterstitial *)ad{
    if(isStop){
        return;
    }
    canRemove = YES;
    [interstitial adapter:self didDismissScreen:ad];

}
/**
 * Callback sent just before the application goes into the background because
 * the user clicked on a link in the ad that will launch another application
 * (such as the App Store). The normal UIApplicationDelegate methods like
 * applicationDidEnterBackground: will immediately be called after this.
 * @param ad The IMInterstitial instance that is launching another application.
 */
- (void)interstitialWillLeaveApplication:(IMInterstitial *)ad{
    NSLog(@"%s",__FUNCTION__);
}
/**
 * Called when the interstitial is tapped or interacted with by the user
 * Optional data is available to publishers to act on when using
 * monetization platform to render promotional ads.
 * @param ad The IMInterstitial instance which was responsible for this action.
 * @param dictionary The NSDictionary object which was passed from the ad.
 */
-(void)interstitialDidInteract:(IMInterstitial *)ad withParams:(NSDictionary *)dictionary{
    NSLog(@"%s",__FUNCTION__);
}
/**
 * Called when the interstitial failed to display.
 * This should normally occur if the state != kIMInterstitialStateReady.
 * @param ad The IMInterstitial instance responsible for this error.
 * @param error The IMError associated with this failure.
 */
- (void)interstitial:(IMInterstitial *)ad didFailToPresentScreenWithError:(IMError *)error{
    NSLog(@"%s",__FUNCTION__);
}

@end
