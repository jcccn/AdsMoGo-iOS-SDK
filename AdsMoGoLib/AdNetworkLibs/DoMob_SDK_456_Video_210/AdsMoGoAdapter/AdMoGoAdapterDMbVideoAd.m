//
//  AdMoGoAdapterDoMobVideoAd.m
//  wanghaotest
//
//  Created by MOGO on 15-3-31.
//
//

#import "AdMoGoAdapterDMbVideoAd.h"
#import "AdMoGoAdSDKVideoNetworkRegistry.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "IndependentVideoManager.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"
typedef enum  {
    AdInit = 1,
    AdSuccess = 2,
    AdFail = 3,
}DMVideoAdStatus;

@interface AdMoGoAdapterDMbVideoAd()<IndependentVideoManagerDelegate>{
    IndependentVideoManager *_manager;
    BOOL isvideoavailable;
    BOOL isStop;
    NSTimer *timer;
    BOOL isStopTimer;
    DMVideoAdStatus adstatus;
}
@end
@implementation AdMoGoAdapterDMbVideoAd
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeDMb;
}

+ (void)load {
    [[AdMoGoAdSDKVideoNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    adstatus = AdInit;
    isStopTimer = NO;
    isvideoavailable = NO;
    //获取用于展示插屏的UIViewController
    
    UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(!uiViewController){
        uiViewController = [self rootViewControllerForPresent];
    }
    
    if(uiViewController){
        NSString *publishId = nil;
        NSString *placementId = nil;
        id key = [self.ration objectForKey:@"key"];
        if ([key isKindOfClass:[NSDictionary class]]) {
            publishId  = [key objectForKey:@"PublisherId"];
            placementId = [key objectForKey:@"PlacementId"];
        }
        else{
            [self adapter:self didFailAd:nil];
        }
        if (_manager == nil) {
            _manager = [[IndependentVideoManager alloc] initWithPublisherID:publishId andUserID:nil];
        }
       
        _manager.delegate = self;
        // !!!:重要：如果需要禁用应用内下载，请将此值设置为YES。
        _manager.disableStoreKit = NO;
        _manager.rootViewController = uiViewController;
        [self adapterDidStartRequestAd:self];
        [_manager checkVideoAvailable];
        
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
    }
}

- (void)stopBeingDelegate{
    if (_manager) {
        _manager.delegate = nil;
        [_manager release];
        _manager = nil;
    }
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}

- (void)dealloc {
    [self stopBeingDelegate];
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isvideoavailable;
}

- (void)playVideoAd{
    [_manager presentIndependentVideo];
}

#pragma mark DoMob Delegate

/**
 *  开始加载数据。
 *  Independent video starts to fetch info.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidStartLoad:(IndependentVideoManager *)manager{
    [self adapter:self didShowAd:nil];
}
/**
 *  加载完成。
 *  Fetching independent video successfully.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidFinishLoad:(IndependentVideoManager *)manager{

}
/**
 *  加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
 *   Failed to load independent video.
 
 *
 *  @param manager IndependentVideoManager
 *  @param error   error
 */
- (void)ivManager:(IndependentVideoManager *)manager
failedLoadWithError:(NSError *)error{
    [self loadVideoFail];
}
/**
 *  被呈现出来时，回调该方法。
 *  Called when independent video will be presented.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerWillPresent:(IndependentVideoManager *)manager{
    [self adapter:self willPresent:manager];
}
/**
 *  页面关闭。
 *  Independent video closed.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidClosed:(IndependentVideoManager *)manager{
     [self adapter:self didDismissScreen:nil];
}

/**
 *  成功获取视频积分
 *  Complete independent video.
 *
 *  @param manager IndependentVideoManager
 *  @param totalPoint
 *  @param consumedPoint
 *  @param currentPoint
 */

- (void)ivCompleteIndependentVideo:(IndependentVideoManager *)manager
                    withTotalPoint:(NSNumber *)totalPoint
                     consumedPoint:(NSNumber *)consumedPoint
                      currentPoint:(NSNumber *)currentPoint{
    [self onVideoReward:@"DoMob"  reward:currentPoint];
}

/**
 *  获取视频积分出错
 *  Uncomplete independent video.
 *
 *  @param manager IndependentVideoManager
 *  @param error
 */

- (void)ivManagerUncompleteIndependentVideo:(IndependentVideoManager *)manager
                                  withError:(NSError *)error{

}


// 检查是否有视频可用
- (void)ivManager:(IndependentVideoManager *)manager
isIndependentVideoAvailable:(BOOL)available {
    isvideoavailable = available;
    if (available) {
        [self loadVideoSuccess];
    }else{
        if (isStopTimer) {
            [self loadVideoFail];
        }
    }
}

- (void)loadVideoSuccess{
    if (adstatus==AdInit) {
        adstatus = AdSuccess;
    }else{
        return;
    }
    [self stopTimer];
    [self adapter:self didReceiveInterstitialScreenAd:nil];
}

- (void)loadVideoFail{
    if (adstatus==AdInit) {
        adstatus = AdFail;
    }else{
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
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

/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [_manager checkVideoAvailable];
    
}

@end
