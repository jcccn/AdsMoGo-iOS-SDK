//
//  AdMoGoAdapterPuchBox.m
//  wanghaotest
//
//  Created by MOGO on 13-9-28.
//
//

#import "AdMoGoAdapterPuchBox.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
//#import "AdMoGoAdSDKBannerNetworkRegistry.h"
static BOOL startedSession = NO;
@implementation AdMoGoAdapterPuchBox


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypePuchBox;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd {
    
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    AdViewType type =[configData.ad_type intValue];
    
    CGRect frame = CGRectZero;
    
    switch (type) {
        case AdViewTypeNormalBanner:
            frame.size = CGSizeMake(320, 50);
            break;
        case AdViewTypeLargeBanner:
            frame.size = CGSizeMake(728, 90);
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
    }
    
    NSString *mPunchBoxID = nil;
    NSString *mAdMobiID = nil;
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSDictionary class]]) {
        mPunchBoxID = [key objectForKey:@"mPunchBoxID"];
        mAdMobiID = [key objectForKey:@"mAdMobiID"];
    }else{
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }

    if (!startedSession) {
        startedSession = YES;
        [PunchBoxAd startSession:mPunchBoxID];
    }

    
    PBBannerView *bannerView = [[PBBannerView alloc] initWithFrame:frame];
    bannerView.delegate = self;
    [bannerView loadRequest:[PBADRequest request]];
    UIView *view = [[UIView alloc] initWithFrame:frame];
    [view addSubview:bannerView];
    [bannerView release];
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

- (void)loadAdTimeOut:(NSTimer*)theTimer{
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)stopBeingDelegate {
    [self stopTimer];
    id subview = [[self.adNetworkView subviews] firstObject];
    if ([subview isKindOfClass:[PBBannerView class]]) {
        PBBannerView *pbbannerview = (PBBannerView *)subview;
        pbbannerview.delegate = nil;
    }
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)stopAd{
    [self stopBeingDelegate];
}
- (void)dealloc {
    [self stopTimer];
    [super dealloc];
}


// 收到Banner广告
- (void)pbBannerViewDidReceiveAd:(PBBannerView *)pbBannerView{
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
}

// Banner广告数据错误
- (void)pbBannerView:(PBBannerView *)pbBannerView
      receiveAdError:(PBRequestError *)requestError{
    [self stopTimer];
    NSLog(@"puchbox error %@",requestError);
    [adMoGoCore adapter:self didFailAd:nil];
}

// 将要展示Banner广告
- (void)pbBannerViewWillPresentScreen:(PBBannerView *)pbBannerView{

}

// 移除Banner广告
- (void)pbBannerViewDidDismissScreen:(PBBannerView *)pbBannerView{

}



@end
