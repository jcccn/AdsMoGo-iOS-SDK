//
//  AdMoGoAdapterGuomob.m
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 13-4-10.
//
//

#import "AdMoGoAdapterGuomob.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKBannerNetworkRegistry.h"
@implementation AdMoGoAdapterGuomob

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeGuomob;
}

+ (void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeGuomob IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}


- (void)getAd {
    isSuccess = NO;
    isFail = NO;
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    AdViewType type =[configData.ad_type intValue];
    
    CGSize size =CGSizeZero;
    switch (type) {
        case AdViewTypeNormalBanner:
            size = CGSizeMake(320, 50);
            break;
        case AdViewTypeLargeBanner:
            size = CGSizeMake(728, 90);
            break;
        default:
            [self stopBeingDelegate];
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
    adView = [GuomobAdSDK initWithAppId:[self.ration objectForKey:@"key"] delegate:self];
    adView.frame=CGRectMake(0, 0, size.width, size.height);
    [adView loadAd:YES];
    self.adNetworkView = adView;

}

- (void)stopBeingDelegate {
    [self stopTimer];
    ((GuomobAdSDK *)self.adNetworkView).delegate = nil;
  
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];
}
- (void)dealloc {
    [self stopTimer];
    [super dealloc];
}

- (void)loadBannerAdSuccess:(BOOL)success{
    if (isStop) {
        return;
    }
    [self stopTimer];
    if (success) {
        [self isSuccess];
    }
}

- (void)BannerConnectionDidFailWithError:(NSError *)error{
    MGLog(MGT,@"Guomob Ad Banner Error %@",error);
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self isFail:error];
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
    /*******/
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)isSuccess{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
    }
}

- (void)isFail:(NSError *)error{
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [adMoGoCore adapter:self didFailAd:error];
    }
}
@end
