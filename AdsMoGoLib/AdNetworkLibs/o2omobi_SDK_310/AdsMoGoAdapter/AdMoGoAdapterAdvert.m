//
//  AdMoGoAdapterAdvert.m
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import "AdMoGoAdapterAdvert.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKBannerNetworkRegistry.h"
@implementation AdMoGoAdapterAdvert


+ (AdMoGoAdNetworkType)networkType{
    return AdMogoAdNetworkTypeAdvert;
}

+ (void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}



-(void)getAd{
    isSuccess = NO;
    isFail = NO;
    isStop = NO;
    //start request count
    [adMoGoCore adDidStartRequestAd];
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    AdViewType type =[configData.ad_type intValue];
    CGSize size =CGSizeZero;
    BOADAdSize adSize ;
    switch (type) {
        case AdViewTypeNormalBanner:
            size = CGSizeMake(320, 50);
            adSize =BOADAdSizeBanner;
            break;
        case AdViewTypeMediumBanner:
            size = CGSizeMake(468, 60);
            adSize =BOADAdSizeFullBanner;
            break;
        case AdViewTypeRectangle:
            size = CGSizeMake(300, 250);
            adSize =BOADAdSizeMediumRectangle;
            break;
        case AdViewTypeLargeBanner:
            size =CGSizeMake(728, 90);
             adSize =BOADAdSizeLeaderboard;
            break;
        default:
            adSize =BOADAdSizeBanner;
            [self stopBeingDelegate];
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    NSString *apikey = nil;
    NSString *apiSecret = nil;
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSDictionary class]]) {
        apikey  = [key objectForKey:@"appKey"];
        apiSecret = [key objectForKey:@"appSecret"];
    }
    else{
        [adMoGoCore adapter:self didFailAd:nil];
    }
    [BOAD setAppId:apikey     appScrect:apiSecret];
    [BOAD setLogEnabled:NO]; //Open DEBUG
    bannerView = [[BOADBannerView alloc] initWithAdSize:adSize];
    bannerView.delegate = self;// 可以设置委托对象，监听广告状态
    bannerView.manualRefresh=YES;
    [bannerView loadAd];
    self.adNetworkView=bannerView;
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }   
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    MGLog(MGD, @"百灵欧拓横幅广告超时");
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}


-(void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];    
}
-(void)stopBeingDelegate{
    if (bannerView) {
        [bannerView release],bannerView=nil;
    }
    [self stopTimer];
}
-(void)stopTimer{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}
#pragma mark --BannerDelegate 

#pragma mark - BOADBannerViewDelegate
- (void)boadBannerViewWillLoadAd:(BOADBannerView *)bannerView {
    MGLog(MGD, @"百灵欧拓横幅广告加载开始");
    [adMoGoCore adapter:self didGetAd:@"o2omobi"];
}
- (void)boadBannerViewDidLoadAd:(BOADBannerView *)bannerView {
    MGLog(MGD, @"百灵欧拓横幅广告加载完毕");
    if (isStop) {
        return;
    }
    isSuccess =YES;
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
}
- (void)boadBannerViewDidTapAd:(BOADBannerView *)bannerView {
    MGLog(MGD, @"百灵欧拓横幅广告点击广告");
    // 点击广告
//    [adMoGoCore sendRecordNum];   //set click count
}
- (void)boadBannerView:(BOADBannerView *)banner didFailToReceiveAdWithError:(BOADError *)error {
    MGLog(MGD, @"百灵欧拓横幅广告加载失败");
    NSLog(@"error --%@",error);
    if (isSuccess) {
        // 加载失败
        if (isStop) {
            return;
        }
        isSuccess =NO;
        [self stopTimer];
        [adMoGoCore adapter:self didFailAd:nil];
    }
}

-(void)dealloc{
    if (bannerView) {
        [bannerView release],bannerView=nil;
    
    }
    [super dealloc];
}
@end
