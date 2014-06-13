//
//  AdMoGoAdapterWQ.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//  Created by pengxu on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoAdapterWQ.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoView.h"
#import "WQAdView.h"
#import "WQAdView+Platform.h"
#import "WQADViewBaseClass+platform.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoDeviceInfoHelper.h"

#define kAdMoGoWQAppID @"AppID"
#define kAdMoGoWQPublisherID @"PublisherID"
#define kAdMoGoWQAccountKey @"AccountKey"
static BOOL wqIsInit;


@implementation AdMoGoAdapterWQ

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeWQ IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//    wqIsInit = NO;
//}


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeWQ;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
    wqIsInit = NO;
}

- (void)getAd {
    
    isStop = NO;
    isFinish = NO;
    [adMoGoCore adDidStartRequestAd];
    [adMoGoCore adapter:self didGetAd:@"wq"];
        
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
     BOOL islocation = [configData islocationOn];
    UIView *view = nil;
   
    AdViewType type = [configData.ad_type intValue];
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
            break;
        case AdViewTypeLargeBanner:
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 704, 110)];
            break;
        case AdViewTypeMediumBanner:
            view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 508, 80)];
            break;
        default:
            [adMoGoCore adapter:self didGetAd:@"weiqian"];
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    
    
    
    if (islocation) {
        adView = [[WQAdView alloc] initWithLocationWithFrame:view.frame];
    }else{
        adView = [[WQAdView alloc] initWithFrame:view.frame];
    }
    
    AdMoGoDeviceInfoHelper *infoHelper = [[AdMoGoDeviceInfoHelper alloc] init];
    NSString *mogoVersion = [infoHelper getMoGoSDKVersion];
    
    [adView setAdPlatform:@"adsmogofc5deaf624fd1" AdPlatformVersion:mogoVersion];
    [infoHelper release];
    adView.storeKitEnabled = YES;
    adView.delegate = self;
    
    [view addSubview:adView];
    [adView release];
    
    NSString *slotID = nil;
    NSString *accountKey = nil;
    if ([[self.ration objectForKey:@"key"] isKindOfClass:[NSDictionary class]]) {
        slotID = [[self.ration objectForKey:@"key"] objectForKey:kAdMoGoWQAppID];
        accountKey = [[self.ration objectForKey:@"key"] objectForKey:kAdMoGoWQPublisherID];
    }
    MGLog(MGT,@"slotID %@",slotID);
    MGLog(MGT,@"accountKey %@",accountKey);
    UIViewController *ViewController = [self.adMoGoDelegate viewControllerForPresentingModalView];
    [adView startWithAdSlotID:slotID AccountKey:accountKey InViewController:ViewController];
    
    self.adNetworkView = view;
    [view release];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
         timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}



    
- (void) dealloc {
    
    [super dealloc];
}

- (void)stopBeingDelegate {
    MGLog(MGT,@"wq stopBeingDelegate");
    if (adView) {
        
        adView.delegate = nil;
        adView.hidden = YES;
        [adView removeFromSuperview];
        adView = nil;
    }
    
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
    
    [super loadAdTimeOut:theTimer];
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}
 
- (void)stopAd{
    MGLog(MGT,@"wq stopAd");
    isStop = YES;
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    } 
}

//广告查看成功调用
- (void)onWQAdViewed:(WQAdView*) adview{
    
   
}

//广告视图获取广告成功
- (void)onWQAdReceived:(WQAdView *)adview{
    MGLog(MGT,@"onWQAdViewed");
    if (isStop) {
        return;
    }
    if (!isFinish) {
        isFinish = YES;
        if (timer) {
            [timer invalidate];
            [timer release];
            timer = nil;
        }
        [adMoGoCore adapter:self didReceiveAdView:adNetworkView];
    }
}

//广告视图获取广告失败
- (void)onWQAdFailed:(WQAdView *)adview{
    MGLog(MGT,@"onWQAdFailed");
    if (isStop) {
        return;
    }
    if (!isFinish) {
        if (timer) {
            [timer invalidate];
            [timer release];
            timer = nil;
        }
        [adMoGoCore adapter:self didFailAd:nil];
    }
    
}

//广告点击时调用
- (void)onWQAdClicked:(WQAdView*) adview{
    

}

//广告视图将要关闭
- (void)onWQAdDismiss:(WQAdView *)adview{

}

//广告视图获取缓慢提醒
- (void)onWQAdLoadTimeout:(WQAdView*) adview{

}

//广告视图进入屏幕展示状态，请勿释放
-(void)onWQAdWillPresentScreen:(WQAdView *) adview{

}

//广告视图结束屏幕展示状态，可以释放
-(void)onWQAdDidDismissScreen:(WQAdView *) adview{

}



@end
