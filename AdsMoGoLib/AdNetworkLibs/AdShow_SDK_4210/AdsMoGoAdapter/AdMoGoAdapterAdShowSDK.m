//
//  AdMoGoAdapterAdShowSDK.m
//  adsmogotest
//
//  Created by MOGO on 15-2-10.
//  Copyright (c) 2015年 MOGO. All rights reserved.
//

#import "AdMoGoAdapterAdShowSDK.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdShowBanner.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoDeviceInfoHelper.h"
@interface AdMoGoAdapterAdShowSDK()<AdShowBannerDelegate>{
    AdShowBanner *vpadnAd;
    BOOL isStop;
    BOOL isfailed;
    NSTimer *timer;
}
@end


@implementation AdMoGoAdapterAdShowSDK
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdShow;
}

+ (void)load {
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    isfailed = NO;
    [adMoGoCore adapter:self didGetAd:@"vpon"];
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    AdShowAdSize size = AdShowAdSizeBanner;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = AdShowAdSizeBanner;
            break;
        case AdViewTypeRectangle:
            size = AdShowAdSizeMediumRectangle;
            break;
        case AdViewTypeMediumBanner:
            size = AdShowAdSizeFullBanner;
            break;
        case AdViewTypeLargeBanner:
            size = AdShowAdSizeLeaderboard;
            break;
            
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }

    
    
    vpadnAd = [[AdShowBanner alloc] initWithAdSize:size origin:CGPointZero];
    vpadnAd.strBannerId = [self.ration objectForKey:@"key"];   // 填入您的BannerId
    vpadnAd.delegate = self;
    vpadnAd.platform = @"adshow";
    [vpadnAd setAdAutoRefresh:NO];
    UIViewController *rootViewCon = [self.adMoGoDelegate viewControllerForPresentingModalView];
    if (rootViewCon) {
        if (rootViewCon.navigationController) {
            rootViewCon = rootViewCon.navigationController;
        }
    }else{
        rootViewCon = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    if (rootViewCon) {
        [vpadnAd setRootViewController:rootViewCon];
    }

    [vpadnAd startGetAd:[self getTestIdentifiers]];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
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

- (void)stopBeingDelegate{
    
    
    
    [self stopTimer];
    
}

- (void)stopAd{
    isStop = YES;
    [self stopTimer];
}

- (void)stopTimer{
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (timer) {
            [timer invalidate];
            [timer release];
            timer = nil;
        }
        
    });
    
    
}

- (void)dealloc {
    [self stopTimer];
    [super dealloc];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [adMoGoCore adapter:self didFailAd:nil];
}

#pragma mark 通知有廣告可供拉取
- (void)onVpadnGetAd:(UIView *)bannerView{
    
}

#pragma mark 通知拉取廣告成功pre-fetch完成
- (void)onVpadnAdReceived:(UIView *)bannerView{
    if(isStop || isfailed){
        return;
    }
    isfailed = NO;
    [self stopTimer];
    
    
    [adMoGoCore adapter:self didReceiveAdView:bannerView];
}

#pragma mark 通知拉取廣告失敗
- (void)onVpadnAdFailed:(UIView *)bannerView didFailToReceiveAdWithError:(NSError *)error{
    if(isStop || isfailed){
        return;
    }
    isfailed = YES;
    [self stopTimer];
    
    MGLog(MGD, @"vpon did fail to receice ad error-->%@",error);
    
    [adMoGoCore adapter:self didFailAd:error];
}

#pragma mark 通知開啟AdShow廣告頁面
- (void)onVpadnPresent:(UIView *)bannerView{
    
}

#pragma mark 通知關閉AdShow廣告頁面
- (void)onVpadnDismiss:(UIView *)bannerView{

}

#pragma mark 通知離開publisher application
- (void)onVpadnLeaveApplication:(UIView *)bannerView{

}




@end
