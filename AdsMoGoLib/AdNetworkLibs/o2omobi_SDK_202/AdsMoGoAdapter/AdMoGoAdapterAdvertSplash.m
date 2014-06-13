//
//  AdMoGoAdapterAdvertSplash.m
//  wanghaotest
//
//  Created by Chasel on 4/23/14.
//
//

#import "AdMoGoAdapterAdvertSplash.h"
#import "BOAD.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
@implementation AdMoGoAdapterAdvertSplash

+ (AdMoGoAdNetworkType)networkType{
    return AdMogoAdNetworkTypeAdvert;
}

+ (void)load{
    [[AdMoGoAdSDKSplashNetworkRegistry sharedRegistry] registerClass:self];
}
- (void)getAd{
    
    
    
    
    isFail = NO;
    isSuccess = NO;
    
    isStop = NO;
    isLoaded = NO;
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:splashAds.config_key];
    
    AdViewType type =[configData.ad_type intValue];
    
    NSString *apikey = nil;
    NSString *apiSecret = nil;
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSDictionary class]]) {
        apikey  = [key objectForKey:@"appKey"];
        apiSecret = [key objectForKey:@"appSecret"];
    }
    else{
        [self.splashAds adSplashFail:self withError:nil];
        return;
    }

	if (type == AdViewTypeSplash) {
        if ([configData islocationOn] == FALSE) {
//            [AdChinaLocationManager setLocationServiceEnabled:NO];
        }
        [BOAD setAppId:apikey appScrect:apiSecret];
        [BOAD setLogEnabled:YES]; //Open DEBUG
        intersti = [[BOADInterstitial alloc] init];
        intersti.delegate = self;
        UIWindow *window = [splashAds getWindow];
        UIImage *backImage = [UIImage imageNamed:@"Default"];
        [intersti loadStartAdUsingWindow:window defaultImage:backImage];
        [self.splashAds adapterDidStartRequestSplashAd:self];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if (_timeInterval && [_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut12 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
}


/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self.splashAds adSplashFail:self withError:nil];
}

- (void)stopBeingDelegate{
    
}

- (void)dealloc{
    if (intersti) {
        intersti.delegate = nil;
        [intersti release];
    }
    [super dealloc];
}

- (void)adSuccess:(id) _awSplash{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [self.splashAds adSplashSuccess:self withSplash:_awSplash];
//        if ([[[UIDevice currentDevice] systemVersion] integerValue]>=7&&!([UIApplication sharedApplication].statusBarHidden)) {
//            [[UIApplication sharedApplication] setStatusBarHidden:YES];
//        }
    }
}

- (void)adFailWith:(NSError *)error{
    MGLog(MGT,@"%s",__func__);
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [self.splashAds adSplashFail:self withError:error];
    }
    
}

-(void)stopTimer{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}


#pragma mark DoMob DMSplashAdControllerDelegate
- (void)boadInterstitialWillLoadAd:(BOADInterstitial *)interstitial {
    // 加载开始
    NSLog(@"%s",__FUNCTION__);
}
- (void)boadInterstitialDidLoadAd:(BOADInterstitial *)_interstitial {
    // 加载完毕
    [self stopTimer];
    UIView *splashBackView = [self.splashAds getBackgroundView];
    splashBackView.hidden = YES;
    [self adSuccess:_interstitial];
    [_interstitial presentFromViewController:[splashAds getWindow].rootViewController];
}
- (void)boadInterstitial:(BOADInterstitial *)_interstitial didFailToReceiveAdWithError:(BOADError *)error {
    // 加载失败
    [self stopTimer];
     [self adFailWith:nil];
}
- (void)boadInterstitialWillPresentScreen:(BOADInterstitial *)_interstitial {
    // 即将显示
   [self.splashAds adSplash:self WillPresent:_interstitial];
}
- (void)boadInterstitialDidPresentScreen:(BOADInterstitial *)interstitial {
    // 已经显示
}
- (void)boadInterstitialWillDismissScreen:(BOADInterstitial *)interstitial {
    // 即将消失
}
- (void)boadInterstitialDidDismissScreen:(BOADInterstitial *)_interstitial {
    // 已经消失
    [self.splashAds adSplash:self didDismiss:_interstitial];
}
- (void)boadInterstitialDidTapAd:(BOADInterstitial *)_interstitial {
    // 点击广告
    if ([self.splashAds respondsToSelector:@selector(sendClickCountWithAdAdpter:)]) {
        [self.splashAds sendClickCountWithAdAdpter:self];
    }
    
//    [interstitial specialSendRecordNum];
}
@end
