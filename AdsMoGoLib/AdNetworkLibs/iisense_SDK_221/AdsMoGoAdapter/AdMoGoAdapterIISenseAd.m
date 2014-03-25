//
//  AdMoGoAdapterIISenseAd.m
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 14-1-3.
//
//

#import "AdMoGoAdapterIISenseAd.h"

@implementation AdMoGoAdapterIISenseAd
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeZhongGanChuanMei;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd {
    NSLog(@"%s",__func__);
        //    [self retain];
    /*
     获取广告类型
     原来代码：AdViewType type = adMoGoView.adType;
     */
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type =[configData.ad_type intValue];

    if (type != AdViewTypeiPadNormalBanner && type != AdViewTypeNormalBanner && type != AdViewTypeRectangle && type != AdViewTypeMediumBanner && type != AdViewTypeLargeBanner) {
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
    
    banner = [[SNMAdView alloc] init];
    banner.requestURL = [[self.ration objectForKey:@"key"] objectForKey:@"requestURL"];
    banner.placementId = [[self.ration objectForKey:@"key"] objectForKey:@"appid"];
    banner.delegate = self;
    banner.refreshAnimation = UIViewAnimationTransitionFlipFromLeft;
    banner.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin;
    banner.adSensingSetting = NormalAdOnly;
    banner.adShowType = BannerAdOnly;
    banner.enableAutoAdRefresh = NO;
    [banner requestAd];

    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}


- (void)stopAd{
    NSLog(@"%s",__func__);
    [self stopTimer];
}

- (void)stopBeingDelegate {
    NSLog(@"%s",__func__);
    [self stopTimer];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)dealloc{
    [banner release], banner = nil;
    [super dealloc];
}

#pragma mark - AdSdkBannerViewDelegate
- (void)SNMAdViewDidLoadAdSdkAd:(SNMAdView *)adView
{
    [self stopTimer];
    NSLog(@"SNMAdViewDidLoadAdSdkAd%@",adView.bannerView);
    adView.bannerView.frame = CGRectMake(0, 0, adView.bannerView.frame.size.width, adView.bannerView.frame.size.height);
    [adMoGoCore adapter:self didReceiveAdView:adView.bannerView];
}

- (void)SNMAdViewDidLoadRefreshedAd:(SNMAdView *)adView
{
    
}

- (void)SNMAdView:(SNMAdView *)adView didFailToReceiveAdWithError:(NSError *)error
{    
    NSLog(@"众感传媒 error-->%@",error);
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:error];    
}

@end
