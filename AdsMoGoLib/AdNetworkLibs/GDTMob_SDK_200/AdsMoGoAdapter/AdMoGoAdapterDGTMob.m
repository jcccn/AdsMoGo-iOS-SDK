//
//  AdMoGoAdapterDGTMob.m
//  TestMOGOSDKAPI
//
//  Created by Daxiong on 14-1-14.
//  Copyright (c) 2014年 Daxiong. All rights reserved.
//
#import "GDTMobBannerView.h"
#import "AdMoGoAdNetworkRegistry.h"
//#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdapterDGTMob.h"

@interface AdMoGoAdapterDGTMob()<GDTMobBannerViewDelegate>{
    
    BOOL isStop;
    AdMoGoConfigData *configData;
    NSTimer *timer;
}

@end

@implementation AdMoGoAdapterDGTMob
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeGDTMob;
}

+ (void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    [adMoGoCore adapter:self didGetAd:@"GDTMob"];
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    CGSize size = CGSizeZero;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = GDTMOB_AD_SIZE_320x50;
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    NSString *appid = [[self.ration objectForKey:@"key"] objectForKey:@"appid"];
    NSString *pid = [[self.ration objectForKey:@"key"] objectForKey:@"pid"];
    
    GDTMobBannerView *bannerView = [[GDTMobBannerView alloc] initWithFrame:CGRectMake(0,
                                                                                      0,
                                                                                      size.width,
                                                                                      size.height)
                                                                    appkey:appid
                                                               placementId:pid];
    
//    NSLog(@"current-->%@",[adMoGoDelegate viewControllerForPresentingModalView]);
    
    self.adNetworkView = bannerView;
    [bannerView release];
    bannerView.delegate = self; // 设置Delegate
    bannerView.currentViewController = [adMoGoDelegate viewControllerForPresentingModalView]; //设置当前的ViewController
    bannerView.interval = 0; //【可选】设置刷新频率;默认30秒,0s 不刷新
    bannerView.isTestMode = [[self.ration objectForKey:@"testmodel"] boolValue]; //【可选】设置测试模式;默认NO
    bannerView.isGpsOn = [configData islocationOn]; //【可选】开启GPS定位;默认关闭
    [bannerView loadAdAndShow]; //加载广告并展示
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}

- (void)stopBeingDelegate{
    GDTMobBannerView *bannerView = (GDTMobBannerView *)self.adNetworkView;
    if (bannerView) {
        bannerView.delegate = nil;
        bannerView.currentViewController = nil;
    }
}

- (void)stopAd{
    isStop = YES;
    [self stopTimer];
    [self stopBeingDelegate];
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
- (void)loadAdTimeOut:(NSTimer*)theTimer {

    if (isStop) {
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}
#pragma mark -
#pragma mark GDTMobBannerViewDelegate

// 请求广告条数据成功后调用
//
// 详解:当接收服务器返回的广告数据成功后调用该函数
- (void)bannerViewDidReceived{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
}

// 请求广告条数据失败后调用
//
// 详解:当接收服务器返回的广告数据失败后调用该函数
- (void)bannerViewFailToReceived:(int)errCode{
    if (isStop) {
        return;
    }
    NSLog(@"%s errCode-->%d",__FUNCTION__,errCode);
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:nil];
    
}

//// 全屏广告弹出时调用
////
//// 详解:当广告栏被点击，弹出内嵌全屏广告时调用
//- (void)bannerViewDidPresentScreen{}

//// 全屏广告关闭时调用
//// 详解:当弹出内嵌全屏广告关闭，返回广告栏界面时调用
//- (void)bannerViewDidDismissScreen{}

//// 应用进入后台时调用
////
//// 详解:当点击应用下载或者广告调用系统程序打开，
//// 应用将被自动切换到后台
//- (void)bannerViewWillLeaveApplication{}

@end
