//
//  File: AdMoGoAdapterAirAd.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.2.1
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterAirAd.h"
//#import "AdMoGoView.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h" 
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdMoGoAdapterAirAd

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeAirAd IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAirAd;
}


+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];

    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
    /*
     获取广告类型
     原来代码：AdViewType type = adMoGoView.adType;
     */
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    //    AdViewType type = adMoGoView.adType;
    AdViewType type =[configData.ad_type intValue];
    
    if (type == AdViewTypeNormalBanner ||
        type == AdViewTypeiPadNormalBanner) {
        
        [airADView setAppID:[self.ration objectForKey:@"key"]];
        
        //设置是否需要取得GPS信息，为得到高质量的广告，建议打开。
        [airADView setGPSOn:YES];
        
        airADView * adView = [[airADView alloc] init];
        [adView setFrame:CGRectMake(0.0, 0.0, 320.0, 54.0)];
        [adView setDelegate:self];
        [adView setRefreshMode:REFRESH_MODE_MANUAL];
        
        UIView *myView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 54)];
        [myView addSubview:adView];
        
        self.adNetworkView = myView;
        [adView requestAd];
    }
	
}

- (void)stopBeingDelegate {
    NSArray *array = [self.adNetworkView subviews];
    if (array && array.count > 0) {
        airADView *adView = (airADView *)[[self.adNetworkView subviews] objectAtIndex:0];
        if (adView) {
            adView.delegate = nil;
            [adView removeFromSuperview];
        }
    }
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    [self stopTimer];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)dealloc {
    
	[super dealloc];
}

#pragma mark AirAd Delegate

// 当接收到一个广告的时候，会发送该请求。广告在后台会自动刷新.以此作为一次成功请求。
- (void)airADDidReceiveAD:(airADView*)view {

}

//当遇到以下情况,会发送此请求:
//1.IP地址非法.在一些无法访问airAD广告的地区,会返回此信息.
//2.网络无相应.
//3.传输参数非法,比如,非正确的App_ID.
- (void)airADView:(airADView *)view didFailToReceiveAdWithError:(NSError *)error {
    
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [adMoGoCore adapter:self didGetAd:@"airad"];
    [adMoGoCore adapter:self didFailAd:error];
}


//当Banner显示完毕时,发送此请求.以此作为广告完成一次有效展示.
- (void)airADImpressionDidFinish:(airADView *)adView{
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [adMoGoCore adapter:self didGetAd:@"airad"];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
}

//当广告完全载入完毕时,发送此请求.以此作为广告完成一次有效点击.
- (void)airADClickDidFinish:(airADView *)adView{

}

//广告点击后,展示对应触发事件
- (void)airADWillShowContent:(airADView *)adView{
    [adMoGoCore stopTimer];
}

- (void)airADWillHideContent:(airADView *)adView{
     [adMoGoCore fireTimer];

}



- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}
@end