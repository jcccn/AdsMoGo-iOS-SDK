//
//  AdMoGoAdapterAdShowFullScreen.m
//  adsmogotest
//
//  Created by MOGO on 15-2-10.
//  Copyright (c) 2015年 MOGO. All rights reserved.
//

#import "AdMoGoAdapterAdShowFullScreen.h"
#import "AdShowInterstitial.h"
@interface AdMoGoAdapterAdShowFullScreen()<AdShowInterstitialDelegate>
{
    AdShowInterstitial *vpadnInterstitial;
    BOOL isReady;
    BOOL isStop;
    NSTimer *timer;
}

@end

@implementation AdMoGoAdapterAdShowFullScreen
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdShow;
}

+ (void)load {
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isReady = NO;
    isStop = NO;
    vpadnInterstitial = [[AdShowInterstitial alloc] init];
    vpadnInterstitial.strBannerId = [self.ration objectForKey:@"key"];   // 填入您的Interstitial BannerId
    vpadnInterstitial.platform = @"adshow";
    vpadnInterstitial.delegate = self;
    [vpadnInterstitial getInterstitial:[self getTestIdentifiers]];
    [self adapterDidStartRequestAd:self];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }

}

-(void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}

-(void)stopBeingDelegate{
    
    if(vpadnInterstitial){
        vpadnInterstitial.delegate = nil;
        [vpadnInterstitial release];
        vpadnInterstitial = nil;
    }
}

-(void)dealloc{
    
    if(vpadnInterstitial){
        vpadnInterstitial.delegate = nil;
        [vpadnInterstitial release];
        vpadnInterstitial = nil;
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
    MGLog(MGD,@"inmobi插屏广告请求超时");
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

-(NSArray*)getTestIdentifiers
{
    return @[
#if DEBUG_COMMON
             @"D63EAD74-D089-4E57-AD14-3A62250C54FD",
             @"F9A66821-63A5-4AA2-AC74-1C4624853B54",
             @"736541B6-ECC3-4527-8D97-B37E9DFA02F6"
#endif
             ];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    // 呈现插屏广告
    if (isReady) {
        [vpadnInterstitial show];
        
        MGLog(MGD,@"inmobi插屏广告将要展示");
        [self adapter:self willPresent:nil];
        MGLog(MGD,@"inmobi插屏广告已经展示");
        [self adapter:self didShowAd:nil];

    }else{
        MGLog(MGT,@"%s ad is not ready",__FUNCTION__);
        MGLog(MGD,@"adshow插屏广告还没有准备好");
    }
}


#pragma mark 通知取得插屏廣告成功pre-fetch完成
- (void)onVpadnInterstitialAdReceived:(UIView *)bannerView{
    if(isStop){
        return;
    }
    [self stopTimer];
    
    isReady = YES;
    [self adapter:self didReceiveInterstitialScreenAd:nil];
    
}
#pragma mark 通知取得插屏廣告失敗
- (void)onVpadnInterstitialAdFailed:(UIView *)bannerView{
    
    if(isStop){
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}
#pragma mark 通知關閉AdShow廣告頁面
- (void)onVpadnInterstitialAdDismiss:(UIView *)bannerView{
    [self adapter:self didDismissScreen:bannerView];
}


@end
