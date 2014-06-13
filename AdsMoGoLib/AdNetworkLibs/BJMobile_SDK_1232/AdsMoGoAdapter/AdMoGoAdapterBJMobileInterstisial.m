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
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    
    AdViewType type =[configData.ad_type intValue];
    
    AdType adtype;
    
    BOOL isFullScreen = [self isFullScreen];
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
                    [self adapter:self didFailAd:nil];
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
                    [self adapter:self didFailAd:nil];
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
                    [self adapter:self didFailAd:nil];
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
                    [self adapter:self didFailAd:nil];
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
    
    [self adapterDidStartRequestAd:self];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (BOOL)isFullScreen{
    BOOL isFullScreen_ = NO;
    
    id delegateIns = [self performSelector:@selector(getDelegate) withObject:nil];
    if ([delegateIns respondsToSelector:_cmd]) {
        BOOL (*isFullScreenMethod)(id, SEL) = NULL;
        isFullScreenMethod = (BOOL (*)(id, SEL))[[delegateIns class] instanceMethodForSelector:_cmd];
        isFullScreen_ = isFullScreenMethod(delegateIns,_cmd);
    }
    
    
    return isFullScreen_;
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
    return isReady;
}

- (void)presentInterstitial{
    
    if (!isReady) {
        return;
    }

    [IZPAdShell startShowAd];
    UIWindow *window=[[UIApplication sharedApplication]keyWindow];
    [window.rootViewController.view addSubview:[IZPAdShell getAdView]];
    [self adapter:self didShowAd:nil];
    
}
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
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
    isReady = YES;
    
    [self adapter:self didReceiveInterstitialScreenAd:nil];

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
    [self adapter:self didFailAd:nil];
}

//点击广告回调
-(void)clickAdNotification{
    [self specialSendRecordNum];
}

//
-(void)pressedBackButtonNotification{
    [IZPAdShell removeRequestAd];
    [self adapter:self didDismissScreen:nil];
}



@end
