//
//  AdMoGoAdapterLimeiInterstitial.m
//  wanghaotest
//
//  Created by MOGO on 13-9-11.
//
//

#import "AdMoGoAdapterLimeiInterstitial.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"

@implementation AdMoGoAdapterLimeiInterstitial
//+ (NSDictionary *)networkType{
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeLMMOB IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load{
//    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeLMMOB;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    isReady = NO;
    isStopTimer = NO;
    iserror = NO;
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSString class]]) {
        iMFullScreen=[[immobView alloc] initWithAdUnitID:key];
        iMFullScreen.delegate = self;
        [iMFullScreen immobViewRequest];
        [self adapterDidStartRequestAd:self];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
    else{
        [self adapter:self didFailAd:nil];
        return;
    }
}

- (void)stopBeingDelegate{
    if (iMFullScreen) {
        iMFullScreen.delegate = nil;
    }
}


- (void)stopAd{
    [self stopTimer];
}

- (void)stopTimer{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}

- (void)dealloc {
    
    if (iMFullScreen) {
        iMFullScreen.delegate = nil;
        [iMFullScreen release];
        iMFullScreen = nil;
    }
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    UIViewController *viewController = [self rootViewControllerForPresent];
    
    if (viewController) {
        [viewController.view addSubview:iMFullScreen];
        [iMFullScreen immobViewDisplay];
        [self adapter:self didShowAd:nil];
    }
}



/**
 *email phone sms 等所需要
 */
- (UIViewController *)immobViewController{
    return [self rootViewControllerForPresent];
}



/**
 *用于实时回调通知当前的广告状态
 */
- (void) immobViewDidReceiveAd:(immobView*)immobView{
    if (!isReady) {
        isReady = YES;
        [self stopTimer];
        [self adapter:self didReceiveInterstitialScreenAd:immobView];
    }
}

- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode{
    if (!iserror) {
        iserror = YES;
        [self stopTimer];
        [self performSelectorOnMainThread:@selector(loadFail)
                               withObject:nil
                            waitUntilDone:NO];

    }
}




/**
 * Called when an ad is clicked and about to return to the application.
 * 当（全屏）广告被点击或者被关闭，将要返回返回主程序见面时被调用。
 *
 */
- (void) onDismissScreen:(immobView *)immobView{
    [self performSelectorOnMainThread:@selector(loadNextAdapter)
                           withObject:nil
                        waitUntilDone:NO];
}


/**
 * Called when an ad is clicked and going to start a new page that will leave the application
 * 当广告调用一个新的页面并且会导致离开目前运行程序时被调用。如：调用本地地图程序。
 *
 */
- (void) onLeaveApplication:(immobView *)immobView{

}

/**
 * Called when an page is created in front of the app.
 * 当广告页面被创建并且显示在覆盖在屏幕上面时调用本方法。
 */
- (void) onPresentScreen:(immobView *)immobView{

}

- (void)loadNextAdapter{
    [self adapter:self didDismissScreen:nil];
}

- (void)loadFail{
     [self adapter:self didFailAd:nil];
}
@end
