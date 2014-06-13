//
//  AdMoGoAdapterGreystripeFullScreen.m
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-12-20.
//
//

#import "AdMoGoAdapterGreystripeFullScreen.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdMoGoAdapterGreystripeFullScreen
//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeGreyStripe IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeGreyStripe;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (id)initWithAdMoGoDelegate:(id<AdMoGoDelegate>)delegate
                        view:(AdMoGoView *)view
                        core:(AdMoGoCore *)core
               networkConfig:(NSDictionary *)netConf{
	if((self = [super initWithAdMoGoDelegate:delegate view:view core:core networkConfig:netConf])) {
        
    }
	
	return self;
}

- (void)getAd {
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    [adMoGoCore adapter:self didGetAd:@"greystripe"];
    
    //init AdView size
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData =  [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    type = [configData.ad_type intValue];
    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
            gsFullAd = [[GSFullscreenAd alloc]initWithDelegate:self];
            [(GSFullscreenAd *)gsFullAd fetch];
            [self adapterDidStartRequestAd:self];
        break;
            default:
             [self adapter:self didFailAd:nil];
            return;
    }
    if (!gsFullAd) {
         [self adapter:self didFailAd:nil];
        return;
    }

    
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut60 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopBeingDelegate {
    isStop = YES;
}

- (void)stopAd{
    [gsFullAd setDelegate:nil];
    [self stopBeingDelegate];
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
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

- (void)dealloc {
    isStop = YES;
    
    [gsFullAd release];
    gsFullAd = nil;
	[super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return [gsFullAd isAdReady];
}

- (void)presentInterstitial{
    UIViewController *rootviewController = [self rootViewControllerForPresent];
    
    [gsFullAd displayFromViewController:rootviewController];
}


#pragma mark -
#pragma mark GreystripeDelegate notification methods

/**
 * The view controller that the banner ad's browser should be displayed from.
 * @warning This must be implemented for banner ads. This view controller cannot
 * be popped or removed from the view heiarchy while the browser is being displayed.
 */
- (UIViewController *)greystripeBannerDisplayViewController{
    if(isStop){
        return nil;
    }
    return [self rootViewControllerForPresent];
}


/**
 * The global unique identifier for the application.
 *
 * This must be set if it is not passed in on ad initialization.
 * @warning This can only be set once by the application. All subsquent setting of
 * the GUID will be ignored.
 */
- (NSString *)greystripeGUID{
    if(isStop){
        return nil;
    }
    return [self.ration objectForKey:@"key"];
}

/**
 * A BOOL indicating whether the first banner ad should be fetched automatically.
 *
 * The default value is YES.
 * @warning If this method is implemented, all subsequent setting of this property
 * will be ignored.
 */
- (BOOL)greystripeBannerAutoload{
    return YES;
}

/**
 * Sent when an ad has successfully been fetched and is ready to be displayed.
 *
 * @param a_ad The ad that succeeded.
 */
- (void)greystripeAdFetchSucceeded:(id<GSAd>)a_ad{
    
    if(isStop){
        return;
    }
    [self stopTimer];
//    [adMoGoCore adapter:self didReceiveAdView:nil];
    [self adapter:self didReceiveInterstitialScreenAd:a_ad];
}

/**
 Sent if the ad fetch request failed.
 
 The possible errors that may occur are:
 
 **kGSNoNetwork:** This error is dispatched when there is no available network connection.
 
 **kGSNoAd:** This error is dispatched when a blank ad is returned by the server.
 
 **kGSTimeout:** This error is dispatched when the request took too long to complete.
 
 **kGSServerError:** This error is dispatched when a server error occurs.
 
 **kGSInvalidApplicationIdentifier:** This error is dispatched when the GUID provided by the application is not a valid Greystripe GUID.
 
 **kGSAdExpired:** This error is dispatched when the ad that is fetched is expired and cannot be displayed.
 
 **kGSFetchLimitExceeded:** This error is dispatched after the SDK prevents a fetch from occurring when it is highly unlikely
 that an ad would be returned. This error can occur in high volume, low fill situations or when too
 many ad requests are made in a short period of time. This error will resolve itself after a short
 timeout. If you frequently receive this message you should reduce the frequency of your requests
 or use an alternate fallback method when no ad is available.
 
 **kGSUnknown:** This error is dispatched when the cause of the error is unknown.
 
 @param a_ad The ad that failed.
 @param a_error The GSAdError that occured during fetching.
 */
- (void)greystripeAdFetchFailed:(id<GSAd>)a_ad withError:(GSAdError)a_error{
    
    if(isStop){
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:[NSError errorWithDomain:@"greystripe" code:1000 userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:a_error] forKey:@"GSAdError"]]];
}

/**
 * Sent when the ad is clicked through to the browser or to an external app.
 *
 * @param a_ad The ad that clicked through.
 */
- (void)greystripeAdClickedThrough:(id<GSAd>)a_ad{
    
    if(isStop){
        return;
    }
    
    if(a_ad == gsFullAd){//count click
        [self specialSendRecordNum];
    }
}

/**
 * Sent when a fullscreen ad is about to take over the screen, or when the browser
 * is about to present modally for banner ads.
 */
- (void)greystripeWillPresentModalViewController{
    
    if(isStop){
        return;
    }
    //stop timer
//    [adMoGoCore stopTimer];
//    [self helperNotifyDelegateOfFullScreenModal];
    [self adapter:self willPresent:nil];
    [self adapter:self didShowAd:nil];
}

/**
 * Sent when the fullscreen ad's view controller or the browser view controller
 * is about to animate off screen. If a view controller needs to be pushed or
 * popped when the ad is dismissed, it should be done here.
 */
- (void)greystripeWillDismissModalViewController{
}

/**
 * Sent after the fullscreen ad's view controller or the browser view controller
 * has fully animated off screen. If the app wants to present a modal view controller after
 * an ad has been dismissed, it must be done in this method. Modal presentation will not work
 * from the greystripeWillDismissModalViewController method.
 */
- (void)greystripeDidDismissModalViewController{
    
    if(isStop){
        return;
    }
    [self adapter:self didDismissScreen:nil];
    //fire timer
//    [adMoGoCore fireTimer];
//    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

@end
