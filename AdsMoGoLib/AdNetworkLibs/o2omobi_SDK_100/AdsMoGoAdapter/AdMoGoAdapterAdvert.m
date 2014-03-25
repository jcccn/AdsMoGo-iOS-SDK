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


//AdMogoAdNetworkTypeAdvert

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
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type =[configData.ad_type intValue];
    
    CGSize size =CGSizeZero;
    switch (type) {
        case AdViewTypeNormalBanner:
            size = CGSizeMake(320, 50);
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

    NSString *apikey = nil;
    NSString *apiSecret = nil;
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSDictionary class]]) {
        apikey  = [key objectForKey:@"appKey"];
        apiSecret = [key objectForKey:@"appSecret"];
    }
    else{
        [interstitial adapter:self didFailAd:nil];
    }
    [BTAdvert registerWithAPIkey:apikey apiSecret:apiSecret];
   //聚合静态广告
    advertBanner = [[BTAdvertBannerStaticImage alloc] initWithDelegate:self];
    [advertBanner setFrame:CGRectMake(0.0,0.0,size.width,size.height)];
    [advertBanner start];
     self.adNetworkView=advertBanner;
    //聚合动态广告
//    BTAdvertBannerDynamicImage *dynamicImage = [[BTAdvertBannerDynamicImage alloc] initWithDelegate:self];
//	[dynamicImage setFrame:CGRectMake(0.0,0.0,size.width,size.height)];
//	[dynamicImage start];
//    self.adNetworkView=dynamicImage;
}

-(void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];    
}
-(void)stopBeingDelegate{
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

- (void)bannerWillGetAdvert:(BTAdverView *)adverView{
    
}
- (void)bannerDidGetAdvert:(BTAdverView *)adverView{
    if (isStop) {
        return;
    }
    isSuccess =YES;
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
}
- (void)bannerDidFailedGetAdvert:(BTAdverView *)adverView error:(NSError *)error{
    if (isStop) {
        return;
    }
    isSuccess =NO;
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:error];
}


-(void)dealloc{
    if (advertBanner) {
        [advertBanner release],advertBanner=nil;
    }
    [super dealloc];
}
@end
