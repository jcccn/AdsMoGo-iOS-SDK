//
//  AdMoGoAdapterPuchBox.m
//  wanghaotest
//
//  Created by MOGO on 14-9-29.
//
//

#import "AdMoGoAdapterChance.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"

@interface AdMoGoAdapterChance (){
    
    BOOL isStop;
    
}

@end
@implementation AdMoGoAdapterChance

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypePuchBox;
}

+ (void)load {
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd {
    
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    AdViewType type =[configData.ad_type intValue];
    
    CGRect frame = CGRectZero;
    
    switch (type) {
            case AdViewTypeNormalBanner:
            frame.size = CSBannerSize_iPhone;
            break;
            case AdViewTypeLargeBanner:
            frame.size = CSBannerSize_iPad;
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
    }
    
    NSString *mPunchBoxID = nil;
    NSString *mAdMobiID = nil;
    NSString *mPlacementID = nil;
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSDictionary class]]) {
        mPunchBoxID = [key objectForKey:@"mPunchBoxID"];
        mAdMobiID = [key objectForKey:@"mAdMobiID"];
        mPlacementID = [key objectForKey:@"placementID"];
    }else{
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
    
    if (!startedSession) {
        startedSession = YES;
        [ChanceAd startSession:mPunchBoxID];
    }
    
    
    CSADRequest *pbRequest = [CSADRequest request];
    
    if (mPlacementID && (id)mPlacementID != [NSNull null]) {
        pbRequest.placementID = mPlacementID;
    }
    
    CSBannerView *bannerView = [[CSBannerView alloc] initWithFrame:frame];
    bannerView.delegate = self;
    [bannerView loadRequest:pbRequest];
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
    if ([subview isKindOfClass:[CSBannerView class]]) {
        CSBannerView *pbbannerview = (CSBannerView *)subview;
        pbbannerview.delegate = nil;
    }
    [self.adNetworkView performSelectorOnMainThread:@selector(removeFromSuperview) withObject:nil waitUntilDone:0.5f];
    self.adNetworkView = nil;
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



// 收到Banner广告
- (void)csBannerViewDidReceiveAd:(CSBannerView *)csBannerView{
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
}

// Banner广告数据错误
- (void)csBannerView:(CSBannerView *)csBannerView
      receiveAdError:(CSRequestError *)requestError{
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    NSLog(@"puchbox error %@",requestError);
    [adMoGoCore adapter:self didFailAd:nil];
}


// 将要展示Banner广告
- (void)csBannerViewWillPresentScreen:(CSBannerView *)csBannerView{
    
}


// 移除Banner广告
- (void)csBannerViewDidDismissScreen:(CSBannerView *)csBannerView{
    
}





@end
