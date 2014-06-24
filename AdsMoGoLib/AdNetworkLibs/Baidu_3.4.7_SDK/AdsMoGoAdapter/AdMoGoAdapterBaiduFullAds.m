//
//  AdMoGoAdapterBaiduFullAds.m
//  TestV1.3.1
//
//  Created by wang hao on 13-9-17.
//
//

#import "AdMoGoAdapterBaiduFullAds.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"


#define kAdMoGoBaiduAppInterstitialIDKey @"AppID"
#define kAdMoGoBaiduAppInterstitialSecretKey @"AppSEC"

@interface AdMoGoAdapterBaiduFullAds()<UIGestureRecognizerDelegate>{
    
    int clickCount;
    
}

@end

@implementation AdMoGoAdapterBaiduFullAds

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeBaiduMobAd;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

//+ (NSDictionary *)networkType{
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeBaiduMobAd IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load{
//    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

- (void)getAd{
    
    clickCount = 0;
    isStop = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    isLocationOn = [configData islocationOn];
    baiduInterstitial = [[BaiduMobAdInterstitial alloc] init];
    baiduInterstitial.delegate = self;
    baiduInterstitial.interstitialType = BaiduMobAdViewTypeInterstitialRefresh;
    [baiduInterstitial load];
    [self adapterDidStartRequestAd:self];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO];
    }
    else{
        timer = [NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] ;
    }
}

- (void)stopTimer{
    @synchronized(self){
        if (timer) {
            [timer invalidate];
            timer = nil;
        }
    }
    
}
-(void)stopBeingDelegate{
    isStop = YES;
    if(baiduInterstitial){
        baiduInterstitial.delegate = nil;
        [baiduInterstitial release],baiduInterstitial = nil;
    }

}
- (BOOL)isReadyPresentInterstitial{
    return baiduInterstitial.isReady;
}

- (void)presentInterstitial{
    UIViewController *viewController = [self rootViewControllerForPresent];
    [baiduInterstitial presentFromRootViewController:viewController];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}
-(void)dealloc{
    isStop = YES;
    [super dealloc];
}
#pragma mark BaiduMobAdInterstitialDelegate 
/**
 *  应用在mounion.baidu.com上的id
 */
- (NSString *)publisherId{
    NSString *publishId = [[self.ration objectForKey:@"key"] objectForKey:@"AppID"];
    return publishId;
}

/**
 *  应用在mounion.baidu.com上的计费名
 */
- (NSString*) appSpec{
    NSString *appSpec = [[self.ration objectForKey:@"key"] objectForKey:@"AppSEC"];
    return appSpec;

}

/**
 *  渠道id
 */
- (NSString*) channelId{
    return @"13b50d6f";
}



/**
 *  启动位置信息
 */
-(BOOL) enableLocation{
    return isLocationOn;
}

/**
 *  广告预加载成功
 */
- (void)interstitialSuccessToLoadAd:(BaiduMobAdInterstitial *)_interstitial{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didReceiveInterstitialScreenAd:baiduInterstitial];
}

/**
 *  广告预加载失败
 */
- (void)interstitialFailToLoadAd:(BaiduMobAdInterstitial *)_interstitial{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}

/**
 *  广告即将展示
 */
- (void)interstitialWillPresentScreen:(BaiduMobAdInterstitial *)_interstitial{
    if (isStop) {
        return;
    }
    [self adapter:self willPresent:baiduInterstitial];
}

/**
 *  广告展示成功
 */
- (void)interstitialSuccessPresentScreen:(BaiduMobAdInterstitial *)_interstitial{
    if (isStop) {
        return;
    }
//    [[UIApplication sharedApplication].delegate performSelector:@selector(logViewTreeForMainWindow) withObject:nil];
    [self adapter:self didShowAd:_interstitial];
    [self addAdsMogoAdClickDelegate:[UIApplication sharedApplication].keyWindow];
}

/**
 *  广告展示失败
 */
- (void)interstitialFailPresentScreen:(BaiduMobAdInterstitial *)_interstitial withError:(BaiduMobFailReason) reason{
   
    [self stopTimer];
    if (isStop) {
        return;
    }
    [self adapter:self didFailAd:nil];
}

/**
 *  广告展示结束
 */
- (void)interstitialDidDismissScreen:(BaiduMobAdInterstitial *)_interstitial{
    if (isStop) {
        return;
    }
    if (clickCount >= 2) {
        [self specialSendRecordNum];
    }
    
    [self adapter:self didDismissScreen:_interstitial];
}

#pragma mark -
#pragma mark add click delegate
- (void)addAdsMogoAdClickDelegate:(UIView *)parentView{
    
    for (UIView *adView in [parentView subviews]) {
        
        NSString *className = [NSString stringWithUTF8String:object_getClassName(adView)];

        if ([className isEqualToString:@"BaiduMobInterstitialAdView"]) {
            
            UITapGestureRecognizer *tapAction = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(adDidClikAction:)];
            tapAction.delegate = self;
            [adView addGestureRecognizer:tapAction];
            [tapAction release];
            
        }
        
    }
    
}

- (void)adDidClikAction:(id)sender{
    clickCount ++;
}

#pragma mark -
#pragma mark UIGestureRecognizerDelegate method
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    
    return YES;
    
}



@end
