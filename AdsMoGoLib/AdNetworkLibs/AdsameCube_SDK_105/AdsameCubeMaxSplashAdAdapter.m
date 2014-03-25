//
//  AdsameCubeMaxSplashAdAdapter.m
//  wanghaotest
//
//  Created by mogo on 14-2-24.
//
//

#import "AdsameCubeMaxSplashAdAdapter.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
@implementation AdsameCubeMaxSplashAdAdapter
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdsameCubeMax;
}

+ (void)load {
	[[AdMoGoAdSDKSplashNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isFail = NO;
    isSuccess = NO;
    
    isStop = NO;
    isLoaded = NO;
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:splashAds.config_key];
    
    AdViewType type =[configData.ad_type intValue];
    
	if (type == AdViewTypeSplash) {
        
        NSString *PublishID = nil;
        NSString *CID = nil;
        id key = [self.ration objectForKey:@"key"];
        if ([key isKindOfClass:[NSDictionary class]]) {
            PublishID = [key objectForKey:@"PublishID"];
            CID = [key objectForKey:@"CID"];
        }else{
            [adMoGoCore adapter:self didFailAd:nil];
            return;
        }
        
        
        [AdsameCubeMaxSDK initWithPublishID:PublishID delegate:self];
        
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

- (void)stopBeingDelegate {
    /*2013*/
    
    
}

- (void)stopAd{
    [self stopBeingDelegate];
    [self stopTimer];
    isStop = YES;
}

- (void)dealloc {
    NSLog(@"remove ad");
    
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
    [self adFailWith:nil];
}


- (void)adSuccess:(id) _awSplash{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [self.splashAds adSplashSuccess:self withSplash:_awSplash];
    }
}

- (void)adFailWith:(NSError *)error{
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [self.splashAds adSplashFail:self withError:error];
    }
}

-(void)onAdsDataReady{
    //显示全屏广告，返回TRUE表示成功，返回FALSE表示失败（比如未初始化或素材有问题等）
    //一般需要在onAdsDataReady之后调用才有效
    if (isSuccess == YES || isFail ==YES) {
        // 防止在进入app 后多次展示开屏
        return;
    }
    Boolean status = [AdsameCubeMaxSDK showFullScreenAds];
    if (status) {
        [self adSuccess:nil];
    }else{
        [self adFailWith:nil];
    }
}

-(void)onAdsLoadingFailed{
    NSLog(@"%s",__func__);
    
}

-(void)onAdsSwitching{
    NSLog(@"%s",__func__);
}

-(void)onAdsImpressed{
    NSLog(@"%s",__func__);
   
}

-(Boolean)onAdsClicked:(NSString *)clickUrl{
    NSLog(@"%s",__func__);
    if ([self.splashAds respondsToSelector:@selector(sendClickCountWithAdAdpter:)]) {
        [self.splashAds sendClickCountWithAdAdpter:self];
    }
    return FALSE;
}

-(void)onFullScreenAdsClosed{
    [self.splashAds  adSplash:self didDismiss:Nil];
}
@end
