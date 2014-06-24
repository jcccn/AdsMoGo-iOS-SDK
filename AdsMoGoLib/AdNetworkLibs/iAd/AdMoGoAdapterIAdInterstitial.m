//
//  AdMoGoAdapterIAdInterstitial.m
//  wanghaotest
//
//  Created by mogo on 14-4-3.
//
//

#import "AdMoGoAdapterIAdInterstitial.h"

@implementation AdMoGoAdapterIAdInterstitial
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeIAd;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    adInterstitialAd = [[ADInterstitialAd alloc] init];
    adInterstitialAd.delegate = self;
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
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
    return adInterstitialAd.isLoaded;
}

- (void)presentInterstitial{
    UIViewController *viewContrller  = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    UIViewController *mainViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (mainViewController) {
        [adInterstitialAd presentFromViewController:mainViewController];
    }else{
        [adInterstitialAd presentFromViewController:viewContrller];
    }
    
}






-(void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}

-(void)stopBeingDelegate{
    
    if(adInterstitialAd){
        NSLog(@"%s",__FUNCTION__);
        adInterstitialAd.delegate = nil;
        [adInterstitialAd release],adInterstitialAd = nil;
    }
}

- (void)dealloc{
    [super dealloc];
}

/*!
 * @method interstitialAdDidUnload:
 *
 * @discussion
 * When this method is invoked, if the application is using -presentInView:, the
 * content will be unloaded from the container shortly after this method is
 * called and no new content will be loaded. This may occur either as a result
 * of user actions or if the ad content has expired.
 *
 * In the case of an interstitial presented via -presentInView:, the layout of
 * the app should be updated to reflect that an ad is no longer visible. e.g.
 * by removing the view used for presentation and replacing it with another view.
 */
- (void)interstitialAdDidUnload:(ADInterstitialAd *)interstitialAd{
    [interstitial adapter:self didDismissScreen:nil];
}

/*!
 * @method interstitialAd:didFailWithError:
 *
 * @discussion
 * Called when an error has occurred attempting to get ad content.
 *
 * @see ADError for a list of possible error codes.
 */
- (void)interstitialAd:(ADInterstitialAd *)interstitialAd didFailWithError:(NSError *)error{
    [self stopTimer];
    [interstitial adapter:self didFailAd:error];

}



/*!
 * @method interstitialAdWillLoad:
 *
 * @discussion
 * Called when the interstitial has confirmation that an ad will be presented,
 * but before the ad has loaded resources necessary for presentation.
 */
- (void)interstitialAdWillLoad:(ADInterstitialAd *)interstitialAd{

}

/*!
 * @method interstitialAdDidLoad:
 *
 * @discussion
 * Called when the interstitial ad has finished loading ad content. The delegate
 * should implement this method so it knows when the interstitial ad is ready to
 * be presented.
 */
- (void)interstitialAdDidLoad:(ADInterstitialAd *)interstitialAd{
    [self stopTimer];
    [interstitial adapter:self didReceiveInterstitialScreenAd:nil];
}

/*!
 * @method interstitialAdActionShouldBegin:willLeaveApplication:
 *
 * @discussion
 * Called when the user chooses to interact with the interstitial ad.
 *
 * The delegate may return NO to block the action from taking place, but this
 * should be avoided if possible because most ads pay significantly more when
 * the action takes place and, over the longer term, repeatedly blocking actions
 * will decrease the ad inventory available to the application.
 *
 * Applications should reduce their own activity while the advertisement's action
 * executes.
 */


/*!
 * @method interstitialAdActionDidFinish:
 * This message is sent when the action has completed and control is returned to
 * the application. Games, media playback, and other activities that were paused
 * in response to the beginning of the action should resume at this point.
 */
- (void)interstitialAdActionDidFinish:(ADInterstitialAd *)interstitialAd{

}

@end
