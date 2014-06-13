//
//  File: AdMoGoAdapterGreystripe.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.2.2
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterGreystripe.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdMoGoAdapterGreystripe

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeGreyStripe IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeGreyStripe;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
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
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    type = [configData.ad_type intValue];
    //init and fetch
    switch (type) {
        case AdViewTypeNormalBanner:
            gsAdView = [[GSMobileBannerAdView alloc]initWithDelegate:self];
            [(GSMobileBannerAdView *)gsAdView fetch];
            break;
        case AdViewTypeRectangle:
            gsAdView = [[GSMediumRectangleAdView alloc]initWithDelegate:self];
            [(GSMediumRectangleAdView *)gsAdView fetch];
            break;
        case AdViewTypeMediumBanner:
            //don't support
            [adMoGoCore adapter:self didFailAd:nil];
            break;
        case AdViewTypeLargeBanner:
            gsAdView = [[GSLeaderboardAdView alloc]initWithDelegate:self];
            [(GSLeaderboardAdView *)gsAdView fetch];
            break;
       
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    if(!gsAdView&&!gsFullAd){
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
        self.adNetworkView = gsAdView;
    /*2013*/
    [gsAdView release];
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
    isStop = YES;

    /*2013*/
    GSBannerAdView *_adview = (GSBannerAdView *)self.adNetworkView;
    if (_adview) {
        _adview.delegate = nil;
    }
    
}
    


- (void)stopAd{
    [self stopTimer];
    isStop = YES;
}



- (void)dealloc {
    isStop = YES;
    /*2013*/
//    [self stopBeingDelegate];
	[super dealloc];
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
    return [self.adMoGoDelegate viewControllerForPresentingModalView];
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
    

    if(type != AdViewTypeFullScreen && type != AdViewTypeiPadFullScreen && gsAdView){//show banner ad view.
        /*2013*/
//        [adMoGoCore adapter:self didReceiveAdView:gsAdView];
        /*2013*/
        [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
    }else if ((type == AdViewTypeFullScreen || type ==AdViewTypeiPadFullScreen) && gsFullAd == a_ad && [gsFullAd isAdReady]){ //show full screen ad.
        [gsFullAd displayFromViewController:[self.adMoGoDelegate viewControllerForPresentingModalView]];
        
        //count show time
        [adMoGoCore adapter:self didReceiveAdView:nil];
        
        //stop timer
        [adMoGoCore stopTimer];
        
    }else{//unknow
        [adMoGoCore adapter:self didFailAd:nil];
    }
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
    [adMoGoCore adapter:self didFailAd:[NSError errorWithDomain:@"greystripe" code:1000 userInfo:[NSDictionary dictionaryWithObject:[NSNumber numberWithInt:a_error] forKey:@"GSAdError"]]];
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
        [adMoGoCore specialSendRecordNum];
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
    [adMoGoCore stopTimer];
    [self helperNotifyDelegateOfFullScreenModal];
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
    //fire timer
    [adMoGoCore fireTimer];
    [self helperNotifyDelegateOfFullScreenModalDismissal];
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
    [adMoGoCore adapter:self didFailAd:nil];
}
@end