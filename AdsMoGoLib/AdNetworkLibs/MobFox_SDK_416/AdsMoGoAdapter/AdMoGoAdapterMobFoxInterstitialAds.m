//
//  AdMoGoAdapterMobFoxInterstitialAds.m
//  wanghaotest
//
//  Created by MOGO on 13-7-18.
//
//

#import "AdMoGoAdapterMobFoxInterstitialAds.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdMoGoAdapterMobFoxInterstitialAds

//+ (NSDictionary *)networkType{
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeMobFox IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load{
//    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMobFox;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    isReady = NO;
    isStopTimer= NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    
    
    AdViewType type =[configData.ad_type intValue];
    
    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
            break;
        default:
            [interstitial adapter:self didFailAd:nil];
            return;
            break;
    }

    
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSDictionary class]]) {
        id _requestURL = [key objectForKey:@"requestURL"];
        if (_requestURL && [_requestURL isKindOfClass:[NSString class]]) {
            if (![(NSString *)_requestURL isEqualToString:@""] && [self isMatch:_requestURL]) {
                requestURL = _requestURL;
            }
            else{
                requestURL = @"http://my.mobfox.com/vrequest.php";
            }
        }
        else{
            requestURL = @"http://my.mobfox.com/vrequest.php";
        }
        id _publisherID = [key objectForKey:@"publisherId"];
        if (_publisherID && [_publisherID isKindOfClass:[NSString class]]) {
            publisherID = (NSString *)_publisherID;
        }
    }
    
    interstitialViewController = [[MobFoxVideoInterstitialViewController alloc] init];
    
    // Assign delegate
    interstitialViewController.delegate = self;
    
    // Defaults to NO. Set to YES to get locationAware Adverts
    BOOL islocation = [configData islocationOn];
    if (islocation) {
        interstitialViewController.locationAwareAdverts = YES;
    }else{
        interstitialViewController.locationAwareAdverts = NO;
    }
    UIViewController *rootviewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    // Add view. Note when it is created is transparent, with alpha = 0.0 and hidden
    // Only when an ad is being presented it become visible
    mainView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, rootviewController.view.frame.size.width, rootviewController.view.frame.size.height)];
    [mainView addSubview:interstitialViewController.view];
    interstitialViewController.requestURL = requestURL;
    [interstitialViewController requestAd];
    [interstitial adapterDidStartRequestAd:self];
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut60 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}

- (void)stopTimer {
    if (!isStopTimer) {
        isStopTimer = YES;
    }else{
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}


- (void)stopBeingDelegate {
    isStop = YES;
    [self stopTimer];
    if(interstitialViewController){
        interstitialViewController.delegate = nil;
    }
}

- (void)stopAd{
    if (interstitialViewController) {
        interstitialViewController.requestURL = nil;
    }
    
    [self stopBeingDelegate];
    isStop = YES;
    
}

- (void)dealloc {
    if(interstitialViewController){
        [interstitialViewController release];
        interstitialViewController = nil;
    }
    
    [super dealloc];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [interstitial adapter:self didFailAd:nil];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    if (isReady) {
        if (isStop) {
            return;
        }
        
         UIViewController *rootviewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
        [rootviewController.view addSubview:mainView];
        [mainView release];
        [interstitialViewController presentAd:_advertType];
    }
}

- (NSString *)publisherIdForMobFoxVideoInterstitialView:(MobFoxVideoInterstitialViewController *)videoInterstitial{
    return publisherID;
}

- (void)mobfoxVideoInterstitialViewDidLoadMobFoxAd:(MobFoxVideoInterstitialViewController *)videoInterstitial advertTypeLoaded:(MobFoxAdType)advertType{
    if (isStop) {
        return;
    }
    [self stopTimer];
    _advertType = advertType;
    if (isReady) {
        return;
    }else{
        isReady = YES;
    }
    if (isStop) {
        return;
    }
    [interstitial adapter:self didReceiveInterstitialScreenAd:nil];
    
}

- (void)mobfoxVideoInterstitialView:(MobFoxVideoInterstitialViewController *)banner didFailToReceiveAdWithError:(NSError *)error{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [interstitial adapter:self didFailAd:error];
}

- (void)mobfoxVideoInterstitialViewActionWillPresentScreen:(MobFoxVideoInterstitialViewController *)videoInterstitial{

}

- (void)mobfoxVideoInterstitialViewWillDismissScreen:(MobFoxVideoInterstitialViewController *)videoInterstitial{

}

- (void)mobfoxVideoInterstitialViewDidDismissScreen:(MobFoxVideoInterstitialViewController *)videoInterstitial{
    if (isStop) {
        return;
    }
    if (mainView) {
        [mainView removeFromSuperview];
    }
    [interstitial adapter:self didDismissScreen:videoInterstitial];
}

- (void)mobfoxVideoInterstitialViewActionWillLeaveApplication:(MobFoxVideoInterstitialViewController *)videoInterstitial{

}

- (BOOL)isMatch:(NSString *)string{
    NSString *expression = @"(https?|ftp|file)://[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|]";
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSRange ran = [match rangeAtIndex:0];
    if(ran.length>0 && ran.location==0){
        return YES;
    }else{
        return NO;
    }
}

@end
