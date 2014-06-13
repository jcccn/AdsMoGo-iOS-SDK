//
//  AdMoGoAdAdapterFracta.m
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdAdapterFractaSDK.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h" 

#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "FtadSdk.h"

@implementation AdMoGoAdAdapterFractaSDK

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdFractal;
}

+ (void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    
    isStop = NO;
    [adMoGoCore adapter:self didGetAd:@"FractalSDK"];
    [adMoGoCore adDidStartRequestAd];
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    
    CGSize size = CGSizeZero;
    view = [[UIView alloc] init];
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = AD_SIZE_320x48;
            view.frame = CGRectMake(0.0, 0.0, 320.0, 48.0);
            break;
        case AdViewTypeMediumBanner:
            size = AD_SIZE_488x80;
             view.frame = CGRectMake(0.0, 0.0, 488.0, 80.0);
            break;
        case AdViewTypeLargeBanner:
            size = AD_SIZE_768x116;
             view.frame = CGRectMake(0.0, 0.0, 768.0, 116.0);
            break;
        case AdViewTypeRectangle:
            size = AD_SIZE_320x270;
            view.frame = CGRectMake(0.0, 0.0, 320.0, 270.0);
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    bannerView = [FtadBannerView newFtadBannerViewWithPointAndSize:CGPointMake(0, 0) size:size adIdentify:@"banner" delegate:self];
//    [self addSubview:bannerView];
    bannerView.isClose = NO;
    bannerView.rootViewController_ = [adMoGoDelegate viewControllerForPresentingModalView];
    [view addSubview:bannerView];
    /*2013*/
    [bannerView release];
    
    manager = [[FtadManager alloc] init];
    [manager setPublisherid:[self.ration objectForKey:@"key"]];
    manager.timeInterval = 0;
    [manager addFtadBannerView:bannerView];
    [manager start];
    self.adNetworkView = view;
    /*2013*/
    [view release];
    
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopAd{
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

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)stopBeingDelegate{
   /*2013*/ 
//    if(bannerView != nil) {
//        bannerView.adstatus = nil;
//    }
  /*2013*/
    UIView *_view = self.adNetworkView;
    if (_view) {
        FtadBannerView *ftadBannerView = (FtadBannerView *)[[_view subviews] lastObject];
        if (ftadBannerView) {
           ftadBannerView.adstatus = nil;
        }
    }
}

- (void)dealloc {
    [manager stop];
    [manager removeFtadBannerView:bannerView];
    [manager release];
    manager  = nil;
    [FtadSdk releaseSdkConfig];
    [super dealloc];
}

-(void)didFtadReceiveAdFail:(NSString*)adIdentify{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:nil];
}
//
//
-(void)didFtadReceiveAdSuccess:(NSString*)adIdentify{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:view];
}
//
//
-(void)didFtadRefreshAd:(NSString*)adIdentify{
    
}
//
//
-(void)didFtadClick:(NSString*)adIdentify{
    if (isStop) {
        return;
    }
    [adMoGoCore specialSendRecordNum];
}
//
//
-(void)willFtadViewClosed:(NSString*)adIdentify{

}
//
//
-(void)willFtadFullScreenShow:(NSString*)adIdentify{

}
//
//
-(void)didFtadFullScreenShow:(NSString*)adIdentify{

}

//
//
-(void)willFtadFullScreenClose:(NSString*)adIdentify{

}
//
//
-(void)didFtadFullScreenClose:(NSString*)adIdentify{

}

@end
