//
//  File: AdMoGoAdapterAdwo.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterBJMobile.h"
//#import "AdMoGoView.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h" 
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "IZPAdShell.h"
@implementation AdMoGoAdapterBJMobile
static BOOL isFirst = YES;

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeBJMobile;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    
    AdType adtype;
    switch (type) {
        case AdViewTypeNormalBanner:
            adtype = IPHONE_BANNER_320_50;
            break;
        case AdViewTypeLargeBanner:
            adtype = IPAD_BANNER_728_90;
            break;
        case AdViewTypeMediumBanner:
            adtype = IPAD_BANNER_468_60;
            break;
        case AdViewTypeRectangle:
            adtype = IPAD_RECTANGLE300_250;
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    NSString *adparam = [self.ration objectForKey:@"key"];
   
    [IZPAdShell setDelegate:self];
    [IZPAdShell setAdParam:adparam
                    adType:adtype
                 locationX:0
                 locationY:0];
    if ([configData istestMode]) {
        [IZPAdShell setRunModel:RUN_MODEL_TEST];
    }
    else {
         [IZPAdShell setRunModel:RUN_MODEL_RELEASE];
    }
    [IZPAdShell setadSwitchEffect:AD_SWITCH_RANDOM];
    [IZPAdShell startRequestAd];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopBeingDelegate {
    [IZPAdShell removeRequestAd];
}

- (void)stopAd{
    [IZPAdShell removeRequestAd];
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
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
	[super dealloc];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    
    [adMoGoCore adapter:self didFailAd:nil];
}
//广告开始请求回调
-(void)startAdNotification{
    [adMoGoCore adapter:self didGetAd:@"izp"];
}

//广告接收成功回调
-(void)receiveAdNotification{
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [IZPAdShell startShowAd];
    UIView *view = [IZPAdShell getAdView];

    [adMoGoCore adapter:self didReceiveAdView:view];
}

//广告接收失败回调
-(void)failToAdNotification{
    if (isStop) {
        return;
    }
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [IZPAdShell pauseRequestAd];
    [adMoGoCore adapter:self didFailAd:nil];
}

//点击广告回调
-(void)clickAdNotification{
    MGLog(MGT,@"%s",__func__);
    if (isStop) {
        return;
    }
}

//
-(void)pressedBackButtonNotification{
    MGLog(MGT,@"%s",__func__);

    [IZPAdShell removeRequestAd];
}

- (BOOL) canBeRemoveAd{
    return [IZPAdShell canBeRemoveAd];
}




@end