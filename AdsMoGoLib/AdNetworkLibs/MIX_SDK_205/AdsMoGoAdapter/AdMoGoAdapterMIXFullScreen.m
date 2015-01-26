//
//  AdMoGoAdapterMIXFullScreen.m
//  wanghaotest
//
//  Created by MOGO on 13-5-31.
//
//

#import "AdMoGoAdapterMIXFullScreen.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
@interface AdMoGoAdapterMIXFullScreen()
-(void)loadNextAdapter:(MIXView *)view;
-(void)interstitialAdFail:(NSError *)error;
-(void)interstitialAdSuccess:(MIXView *)view;
@end

@implementation AdMoGoAdapterMIXFullScreen
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMIX;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    isReady = NO;
    isSuccess = NO;
    isLoadNextAdapter = NO;
    /*
     获取广告类型
     */
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    AdViewType type =[configData.ad_type intValue];
    
	if (type == AdViewTypeFullScreen||
        type == AdViewTypeiPadFullScreen) {
        id key = [self.ration objectForKey:@"key"];
        if ([key isKindOfClass:[NSString class]]) {
            adUnitId = key;
        }else if ([key isKindOfClass:[NSDictionary class]]) {
            adUnitId = [key objectForKey:@"adUnitId"];
        }
        
    }
    else{
        [self interstitialAdFail:nil];
    }
}

-(void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];
    [self stopTimer];
}

-(void)stopBeingDelegate{

}

-(void)dealloc{
    
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
    [self interstitialAdFail:nil];
}


- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
//    UIViewController *viewController = [self rootViewControllerForPresent];
    [self adapterDidStartRequestAd:self];
    
    mixview = [MIXView initWithID:adUnitId];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
        //展示推广橱窗及广告
        [MIXView showAdWithDelegate:self];
}

//加载推广橱窗失败时调用
- (void)mixViewDidFailToShowAd:(MIXView *)view withPlace:(NSString *)place{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self interstitialAdFail:nil];
}

//加载推广橱窗成功时调用
- (void)mixViewDidShowAd:(MIXView *)view withPlace:(NSString *)place{
    
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self interstitialAdSuccess:view];
    
}

//推广橱窗点击出现内容窗口时调用
- (void)mixViewDidClickedAd:(MIXView *)view withPlace:(NSString *)place{
    if (isStop) {
        return;
    }
     [self specialSendRecordNum];
    
    ////停止推广橱窗请求及展示
    [MIXView dismissAd];
    [self loadNextAdapter:view];
}

//推广橱窗的关闭按钮被点击时调用
- (void)mixViewDidClosed:(MIXView *)view withPlace:(NSString *)place{
    if (isStop) {
        return;
    }
    [self loadNextAdapter:view];
}

//没有推广橱窗返回时调用
- (void)mixViewNoAdWillPresent:(MIXView *)view withPlace:(NSString *)place{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self interstitialAdFail:nil];
}


//预加载广告完成时调用
- (void)mixViewDidCacheAd:(MIXView *)view withPlace:(NSString *)place{
    if (!isReady) {
        isReady =YES;
    }
}

//预加载广告失败时调用
- (void)mixViewDidFailToCacheAdWithError:(MIXErrorCode)errorCode withPlace:(NSString *)place{
    isReady =NO;
}


-(void)loadNextAdapter:(MIXView *)view{
    if (!isLoadNextAdapter) {
        isLoadNextAdapter = YES;
        [self adapter:self didDismissScreen:view];
    }
}

-(void)interstitialAdFail:(NSError *)error{
//    if (isError) {
//        return;
//    }
//    else{
//        isError = YES;
//        [interstitial adapter:self didFailAd:nil];
//    }
    if (!isSuccess && !isError) {
        isError = YES;
        [self adapter:self didFailAd:nil];

    }
}


-(void)interstitialAdSuccess:(MIXView *)view{
    if (!isSuccess && !isError) {
        isSuccess = YES;
        [self adapter:self didReceiveInterstitialScreenAd:view];
        [self adapter:self didShowAd:view];
    }
}

@end
