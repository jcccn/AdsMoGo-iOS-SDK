//
//  AdMoGoAdapterIZPInterstisial.m
//  wanghaotest
//
//  Created by mogo on 14-1-23.
//
//

#import "AdMoGoAdapterBJMobileInterstisial.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
@implementation AdMoGoAdapterBJMobileInterstisial
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeBJMobile;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    isReady = NO;
}

- (void)stopBeingDelegate {
    /*2013*/
     [IZPAdShell removeRequestAd];
    
}

- (void)stopAd{
    [self stopBeingDelegate];
    [self stopTimer];
    isStop = YES;
}

- (void)dealloc {
    MGLog(MGT,@"remove ad");
    
    [super dealloc];
    
}

- (BOOL)isReadyPresentInterstitial{
    return YES;
}

- (void)presentInterstitial{
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    
    
    AdViewType type =[configData.ad_type intValue];
    
    AdType adtype;
    
    BOOL isFullScreen = [interstitial isFullScreen];
    if (isFullScreen) {
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            switch (type) {
                case AdViewTypeFullScreen:
                    adtype=IPHONE_FULL_SCREEN_320_568;
                    break;
                case AdViewTypeiPadFullScreen:
                    adtype=IPAD_FULL_SCREEN_768_1024;
                    break;
                default:
                    [interstitial adapter:self didFailAd:nil];
                    return;
                    break;
            }
        }else{
            switch (type) {
                case AdViewTypeFullScreen:
                    adtype=IPHONE_FULL_SCREEN_568_320;
                    break;
                case AdViewTypeiPadFullScreen:
                    adtype=IPAD_FULL_SCREEN_1024_768;
                    break;
                default:
                    [interstitial adapter:self didFailAd:nil];
                    return;
                    break;
            }
        }
    }else{
        if (UIInterfaceOrientationIsPortrait([UIApplication sharedApplication].statusBarOrientation)) {
            switch (type) {
                case AdViewTypeFullScreen:
                    adtype=IPHONE_SQUARE_480_700;
                    break;
                case AdViewTypeiPadFullScreen:
                    adtype=IPAD_SQUARE_560_750;
                    break;
                default:
                    [interstitial adapter:self didFailAd:nil];
                    return;
                    break;
            }
        }else{
            switch (type) {
                case AdViewTypeFullScreen:
                    adtype=IPHONE_SQUARE_780_400;
                    break;
                case AdViewTypeiPadFullScreen:
                    adtype=IPAD_SQUARE_750_560;
                    break;
                default:
                    [interstitial adapter:self didFailAd:nil];
                    return;
                    break;
            }
        }
    }

    NSString *adparam = [self.ration objectForKey:@"key"];
    [IZPAdShell setDelegate:self];
    [IZPAdShell setAdParam:adparam
                    adType:adtype
                 locationX:0
                 locationY:0];
    if ([configData istestMode]) {
        [IZPAdShell setRunModel:RUN_MODEL_TEST];
    }
    else {
        [IZPAdShell setRunModel:RUN_MODEL_RELEASE];
    }
    [IZPAdShell setadSwitchEffect:AD_SWITCH_RANDOM];
    [IZPAdShell startRequestAd];
    
    [interstitial adapterDidStartRequestAd:self];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }

    
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
    [self stopBeingDelegate];
    [interstitial adapter:self didFailAd:nil];
}


//广告开始请求回调
-(void)startAdNotification{
    
}

//广告接收成功回调
-(void)receiveAdNotification{
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
   
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    [window.rootViewController.view addSubview:[IZPAdShell getAdView]];
    [interstitial adapter:self didReceiveInterstitialScreenAd:nil];

}

//广告接收失败回调
-(void)failToAdNotification{
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [IZPAdShell pauseRequestAd];
    [interstitial adapter:self didFailAd:nil];
}

//点击广告回调
-(void)clickAdNotification{
    [interstitial specialSendRecordNum];
}

//
-(void)pressedBackButtonNotification{
    [IZPAdShell removeRequestAd];
    [interstitial adapter:self didDismissScreen:nil];
}



@end
