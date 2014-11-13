//
//  AdMoGoAdapterLimeiInterstitial.m
//  wanghaotest
//
//  Created by MOGO on 13-9-11.
//
//

#import "AdMoGoAdapterLMBInterstitial.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"

@implementation AdMoGoAdapterLMBInterstitial


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeLMB;
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
        MBJoyView *tmpAd=[[MBJoyView alloc]  initWithUnitId:key mBJoyType:MBJoyTypeMediumRectangle rootViewController:viewController userInfo:@{MBJoyAccountname: @"your user's app"}];
//         MBJoyView *tmpAd=[[MBJoyView alloc]  initWithUnitId:@"d1ce616d93d301f4c23991f273242723" mBJoyType:MBJoyTypeMediumRectangle rootViewController:viewController userInfo:@{MBJoyAccountname: @"your user's app"}];
        self.ad=tmpAd;
        [tmpAd release];
        self.ad.delegate=self;
        
        [self.ad mBJoyRequest];
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
    self.ad.delegate = nil;
}


- (void)stopAd{
    isStop = YES;
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
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

- (void)dealloc {
    [self.ad removeFromSuperview];
    self.ad.delegate = nil;
    self.ad = nil;
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    if (self.ad.isReady) {
        [self.ad mBJoyDisplay];
        
        UIViewController *viewController = [self rootViewControllerForPresent];
        [viewController.view addSubview:self.ad];
    }else{
        
        NSLog(@"广告未加载成功.广告不可展示");
    }
}

/*!
 @method
 @abstract  用于实时回调通知当前的广告状态
 @discussion 用于实时回调通知当前的广告状态。
 @param MBJoyView 当前的实例对象
 */
- (void)mBJoyViewDidReceiveAd:(MBJoyView*)mBJoyView
{
    MGLog(MGD, @"力美插屏广告获取成功");
    if (isStop) {
        return;
    }
    
    if (!isReady) {
        isReady = YES;
        [self stopTimer];
        [self adapter:self didReceiveInterstitialScreenAd:mBJoyView];
    }
}

/*!
 @method
 @abstract  返回MBJoyView执行过程中的error信息
 @discussion 用于实时回调通知当前的广告状态。
 @param MBJoyView 当前的实例对象
 @param errorCode 服务器返回的错误码
 */
- (void)mBJoyView: (MBJoyView*) mBJoyView didFailToReceiveMBJoyAdWithError: (NSInteger) errorCode
{
    [mBJoyView mBJoyDestroy];
    MGLog(MGD, @"力美插屏广告获取成功获取失败");
    if (isStop) {
        return;
    }

    if (!iserror) {
        iserror = YES;
        [self stopTimer];
        [self adapter:self didFailAd:mBJoyView];
    }
}

/*!
 @method
 @abstract  广告从界面上移除或被关闭时被调用
 @param MBJoyView 当前的实例对象
 */
- (void)mBJoyOnDismissScreen:(MBJoyView *)mBJoyView
{
    MGLog(MGD, @"力美插屏广告被关闭");
    [self adapter:self didDismissScreen:mBJoyView];
}

/*!
 @method
 @abstract  当广告调用一个新的页面并且会导致离开目前运行程序时被调用,如:打开appStore
 @param MBJoyView 当前的实例对象
 */
- (void)mBJoyOnLeaveApplication:(MBJoyView *)mBJoyView
{
    MGLog(MGD, @"力美插屏广告被点击");
    [self specialSendRecordNum];
}

/*!
 @method
 @abstract  广告页面被创建或显示在覆盖在屏幕上面时调用本方法
 @param MBJoyView 当前的实例对象
 */
- (void)mBJoyOnPresentScreen:(MBJoyView *)mBJoyView
{
    MGLog(MGD, @"力美插屏广告将要被展示");
    [self adapter:self willPresent:mBJoyView];
    [self adapter:self didShowAd:mBJoyView];  //这句话不加入的话就会不停的展示
}

@end
