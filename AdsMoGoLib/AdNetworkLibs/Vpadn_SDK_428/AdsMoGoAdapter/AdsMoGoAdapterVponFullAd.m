//
//  AdsMoGoAdapterVponFullAd.m
//  TestMOGOSDKAPI
//
//  Created by Daxiong on 14-3-25.
//  Copyright (c) 2014年 Daxiong. All rights reserved.
//

#import "VpadnInterstitial.h"

#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdsMoGoAdapterVponFullAd.h"

@interface AdsMoGoAdapterVponFullAd ()<VpadnInterstitialDelegate>{
    
    BOOL isReady;
    BOOL isStop;
    
    VpadnInterstitial *vponInterstitial;
    
    NSTimer *timer;
    
}

@end

@implementation AdsMoGoAdapterVponFullAd
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdOnCN;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isReady = NO;
    isStop = NO;
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    AdViewType type =[configData.ad_type intValue];
    
	if (type == AdViewTypeFullScreen || type==AdViewTypeiPadFullScreen) {
        
        vponInterstitial = [[VpadnInterstitial alloc] init];
        vponInterstitial.strBannerId = [self.ration objectForKey:@"key"];   // 填入您的Interstitial BannerId
        
        
        //platform
        NSString *countryCode = nil;
        //如果需要自行设置vpon Platform属性 可以在 {appName}-Prefix.pch 文件中宏定义 vpon_custom_platform
        //如：#define vpon_custom_platform @"TW"
        //注：定义值为国家代码双字母简写 目前vpon只支持 CN 和 TW 的设置
        //如果不定义 则交由adsMogo® SDK根据真实环境处理
        
#ifdef vpon_custom_platform
        countryCode = vpon_custom_platform;
#else
        if ([self.ration objectForKey:@"countryCode"] != [NSNull null]) {
            countryCode = [self.ration objectForKey:@"countryCode"];
        }else{
            countryCode = @"cn";
        }
#endif
        
        vponInterstitial.platform = [[countryCode lowercaseString] isEqualToString:@"cn"]? @"CN" : @"TW";

        //use loaction
        id islocation = [configData.config_extra objectForKey:@"location_on"];
        [vponInterstitial setLocationOnOff:[islocation intValue]==1];
        //delegate
        vponInterstitial.delegate = self;
        //start get ad
        [vponInterstitial getInterstitial:[self getTestIdentifiers]];
        
        
        [self adapterDidStartRequestAd:self];
        
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        
        
    }else{
        
        [self adapter:self didFailAd:nil];
        
    }
    
}

// 請新增此function到您的程式內 如果為測試用 則在下方填入UUID
-(NSArray*)getTestIdentifiers
{
    return [NSArray arrayWithObjects:
#if DEBUG_COMMON
            @"0E15EF21-2C1A-44D8-A814-13127775C826",// add your test UUID
            @"0D3B2E75-24E3-4257-B402-4474E0F25B8D",
            @"DF29F01B-B45E-49B4-AF4B-BE9129D46E34",
            @"F9A66821-63A5-4AA2-AC74-1C4624853B54",
            @"D77B1589-CE48-4FD7-A6CB-0798BD3A257E",
#endif
            nil];
}

#pragma mark -
#pragma mark adapter method
- (void)stopBeingDelegate{
    if (self->vponInterstitial) {
        self->vponInterstitial.delegate = nil;
        [self->vponInterstitial release],self->vponInterstitial = nil;
    }
}

- (void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];
}

- (void)dealloc{
    [self stopTimer];
    
    if (self->vponInterstitial) {
        self->vponInterstitial.delegate = nil;
        [self->vponInterstitial release],self->vponInterstitial = nil;
    }
    
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    // 呈现插屏广告
    
    if (isReady) {
        [vponInterstitial show];
        [self adapter:self didShowAd:nil];
    }

}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [super loadAdTimeOut:theTimer];
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

- (void)stopTimer {
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    
        if (timer) {
            [timer invalidate];
            [timer release];
            timer = nil;
        }
        
    });
    
}

#pragma mark -
#pragma mark VponInterstitialDelegate method

#pragma mark 通知取得插屏廣告成功pre-fetch完成
- (void)onVpadnInterstitialAdReceived:(UIView *)bannerView{
    
    if (isStop || isReady) {
        return;
    }
    
    [self stopTimer];
    
    isReady = YES;
    
    [self adapter:self didReceiveInterstitialScreenAd:bannerView];
    
}
#pragma mark 通知取得插屏廣告失敗
- (void)onVpadnInterstitialAdFailed:(UIView *)bannerView{
    
    if (isStop || isReady) {
        return;
    }
    
    [self stopTimer];
    
    [self adapter:self didFailAd:nil];
    
}
#pragma mark 通知關閉vpadn廣告頁面
- (void)onVpadnInterstitialAdDismiss:(UIView *)bannerView{
    if (isStop) {
        return;
    }
    
    [self adapter:self didDismissScreen:bannerView];
}

@end
