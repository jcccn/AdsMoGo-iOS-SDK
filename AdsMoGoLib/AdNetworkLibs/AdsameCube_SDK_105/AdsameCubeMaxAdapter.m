//
//  AdsameCubeMaxAdapter.m
//  wanghaotest
//
//  Created by mogo on 14-2-20.
//
//

#import "AdsameCubeMaxAdapter.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
@implementation AdsameCubeMaxAdapter
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdsameCubeMax;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isloadfail = NO;
    isStop = NO;
    isSuccess = NO;
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type =[configData.ad_type intValue];

    float width = 0.0f;
    float height = 0.0f;
    switch (type) {
        case AdViewTypeNormalBanner:

            width = 320.0f;
            height = 50.0f;
            break;
        case AdViewTypeMediumBanner:
            width = 568.0f;
            height = 32.0f;
            break;
        case AdViewTypeLargeBanner:
            width = 768.0f;
            height = 66.0f;
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
    }
    
    NSString *PublishID = nil;
    NSString *CID = nil;
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSDictionary class]]) {
        PublishID = [key objectForKey:@"PublishID"];
        CID = [key objectForKey:@"CID"];
    }else{
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
    
    //初始化广告服务
    [AdsameCubeMaxSDK initWithPublishID:PublishID delegate:self];
    UIView *adBanner = [AdsameCubeMaxSDK getBannerWithCID:[CID integerValue] width:width height:height delegate:self];
    CGRect frame = adBanner.frame;
    frame.origin = CGPointZero;
    adBanner.frame = frame;
    UIView *superBannerView = [[UIView alloc] initWithFrame:frame];
    [superBannerView addSubview:adBanner];
    self.adNetworkView = superBannerView;
    [superBannerView release];
    
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
    if (isStop) {
        return;
    }
    if (!isloadfail) {
        isloadfail = YES;
        [adMoGoCore adapter:self didFailAd:nil];
    }
}

- (void)stopBeingDelegate {
    UIView *view = (UIView *)[[self.adNetworkView subviews] firstObject];
    if (view != NULL) {
        [view removeFromSuperview];
        view = NULL;
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
    isStop = YES;
    [self stopBeingDelegate];
}
- (void)dealloc {
    NSLog(@"%s",__func__);
    [super dealloc];
}

- (void)adSuccess{
    if (isSuccess==isloadfail && !isSuccess) {
        isSuccess = YES;
        [self stopTimer];
        [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
    }
}



- (void)adfail{
    if (isSuccess == isloadfail && !isloadfail) {
        [self stopTimer];
        isloadfail = YES;
        [adMoGoCore adapter:self didFailAd:nil];
    }
}

#pragma -mark AdsameCubeMaxDelegate
-(void)onAdsDataReady{
    NSLog(@"%s",__func__);
    if (isStop) {
        return;
    }
    [self adSuccess];
}

-(void)onAdsLoadingFailed{
    NSLog(@"%s",__func__);
    if (isStop) {
        return;
    }
    [self adfail];
}

-(void)onAdsSwitching{
     NSLog(@"%s",__func__);
}

-(void)onAdsImpressed{
    NSLog(@"%s",__func__);
}

-(Boolean)onAdsClicked:(NSString *)clickUrl{
    return FALSE;
}

@end
