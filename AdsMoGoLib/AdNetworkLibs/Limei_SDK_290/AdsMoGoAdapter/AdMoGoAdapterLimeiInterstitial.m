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
         UIViewController *viewController = [self rootViewControllerForPresent];
        iMFullScreen = [[immobView alloc] initWithAdUnitId:key adUnitType:interstitial rootViewController:viewController userInfo:nil];
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
        [iMFullScreen immobViewDestroy];
        [iMFullScreen release];
        iMFullScreen = nil;
    }
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    if (iMFullScreen.isAdReady) {
        UIViewController *viewController = [self rootViewControllerForPresent];
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


- (void)loadNextAdapter{
    [self adapter:self didDismissScreen:nil];
}

- (void)loadFail{
     [self adapter:self didFailAd:nil];
}


/*!
 @method
 @abstract  用于实时回调通知当前的广告状态
 @discussion 用于实时回调通知当前的广告状态。
 @param immobView 当前的实例对象
 */
- (void) immobViewDidReceiveAd:(immobView*)immobView{
    if (!isReady) {
        isReady = YES;
        [self stopTimer];
        [self adapter:self didReceiveInterstitialScreenAd:immobView];
    }
}
/*!
 @method
 @abstract  返回immobView执行过程中的error信息
 @discussion 用于实时回调通知当前的广告状态。
 @param immobView 当前的实例对象
 @param errorCode 服务器返回的错误码
 */
- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode{
    if (!iserror) {
        iserror = YES;
        [self stopTimer];
        [self performSelectorOnMainThread:@selector(loadFail)
                               withObject:nil
                            waitUntilDone:NO];
        
    }
}

/*!
 @method
 @abstract  用于通知账户设置情况
 @discussion 用于通知账户设置情况,如果email账号未设置,此方法会被调用到。
 @param immobView 当前的实例对象
 */
- (void) emailNotSetupForAd:(immobView *)immobView{

}




/*!
 @method
 @abstract  广告从界面上移除或被关闭时被调用
 @discussion 广告从界面上移除或被关闭时被调用
 @param immobView 当前的实例对象
 */
- (void) onDismissScreen:(immobView *)immobView{
    [self performSelectorOnMainThread:@selector(loadNextAdapter)
                           withObject:nil
                        waitUntilDone:NO];
}

/*!
 @method
 @abstract  当广告调用一个新的页面并且会导致离开目前运行程序时被调用,如:打开appStore
 @discussion 当广告调用一个新的页面并且会导致离开目前运行程序时被调用,如:打开appStore
 @param immobView 当前的实例对象
 */
- (void) onLeaveApplication:(immobView *)immobView{

}


/*!
 @method
 @abstract  广告页面被创建或显示在覆盖在屏幕上面时调用本方法
 @discussion 广告页面被创建或显示在覆盖在屏幕上面时调用本方法
 @param immobView 当前的实例对象
 */
- (void) onPresentScreen:(immobView *)immobView{

}
@end
