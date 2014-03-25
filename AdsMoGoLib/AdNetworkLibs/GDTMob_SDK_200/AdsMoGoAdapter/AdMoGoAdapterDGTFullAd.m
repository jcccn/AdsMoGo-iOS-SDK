//
//  AdMoGoAdapterDGTFullAd.m
//  wanghaotest
//
//  Created by Chasel on 14-2-24.
//
//

#import "AdMoGoAdapterDGTFullAd.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"


@implementation AdMoGoAdapterDGTFullAd

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeGDTMob;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    isReady = NO;
    canRemove = YES;
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    
    AdViewType type =[configData.ad_type intValue];
    
	if (type == AdViewTypeFullScreen||
        type == AdViewTypeiPadFullScreen) {
        NSMutableDictionary *keys=[self.ration objectForKey:@"key"];
        NSString  * appid=nil;
        NSString  * pid=nil;
        if (keys) {
            appid=[keys objectForKey:@"appid"];
            pid=[keys objectForKey:@"pid"];
        }
        _interstitialObj = [[GDTMobInterstitial alloc] initWithAppkey:appid placementId:pid];
        _interstitialObj.delegate = self; //设置委托
        _interstitialObj.isGpsOn = NO; //【可选】设置GPS开关
        //预加载广告
        [_interstitialObj loadAd];
        [interstitial adapterDidStartRequestAd:self];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }else{
        [interstitial adapter:self didFailAd:nil];
    }
}

-(void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}

-(void)stopBeingDelegate{
    
    if(_interstitialObj && canRemove){
        NSLog(@"%s",__FUNCTION__);
        _interstitialObj.delegate = nil;
        [_interstitialObj release],_interstitialObj = nil;
    }
}

-(void)dealloc{
    
    if(_interstitialObj && canRemove){
        _interstitialObj.delegate = nil;
        [_interstitialObj release],_interstitialObj = nil;
    }
    
    [super dealloc];
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
    [self stopTimer];
    [self stopBeingDelegate];
    [interstitial adapter:self didFailAd:nil];
}


- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    // 呈现插屏广告
    if (_interstitialObj.isReady==YES) {
        UIViewController *vc = [[[UIApplication sharedApplication] keyWindow] rootViewController];
        [_interstitialObj presentFromRootViewController:vc];
    }else{
        NSLog(@"%s ad is not ready",__FUNCTION__);
    }
    
}

#pragma mark  AdMoGo


/**
 *  广告预加载成功回调
 *  详解:当接收服务器返回的广告数据成功后调用该函数
 */
- (void)interstitialSuccessToLoadAd:(GDTMobInterstitial *)_interstitial
{
    if(isStop){
        return;
    }
    [self stopTimer];
    
    isReady = YES;
    [interstitial adapter:self didReceiveInterstitialScreenAd:nil];

}

/**
 *  广告预加载失败回调
 *  详解:当接收服务器返回的广告数据失败后调用该函数
 */
- (void)interstitialFailToLoadAd:(GDTMobInterstitial *)_interstitial
{
    if(isStop){
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [interstitial adapter:self didFailAd:nil];

}

/**
 *  插屏广告将要展示回调
 *  详解: 插屏广告即将展示回调该函数
 */
- (void)interstitialWillPresentScreen:(GDTMobInterstitial *)_interstitial
{
    if(isStop){
        return;
    }
    canRemove = NO;
    [interstitial adapter:self WillPresent:nil];

}

/**
 *  插屏广告视图展示成功回调
 *  详解: 插屏广告展示成功回调该函数
 */
- (void)interstitialDidPresentScreen:(GDTMobInterstitial *)interstitial
{
   NSLog(@"%s",__FUNCTION__);
}

/**
 *  插屏广告展示结束回调
 *  详解: 插屏广告展示结束回调该函数
 */
- (void)interstitialDidDismissScreen:(GDTMobInterstitial *)_interstitial
{
    NSLog(@"%s",__FUNCTION__);
    if(isStop){
        return;
    }
    canRemove = YES;
    [interstitial adapter:self didDismissScreen:nil];
}

/**
 *  应用进入后台时回调
 *  详解: 当点击下载应用时会调用系统程序打开，应用切换到后台
 */
- (void)interstitialApplicationWillEnterBackground:(GDTMobInterstitial *)interstitial
{
   NSLog(@"%s",__FUNCTION__);
}



@end
