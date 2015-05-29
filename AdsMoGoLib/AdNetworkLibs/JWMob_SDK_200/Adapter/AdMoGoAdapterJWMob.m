//
//  AdMoGoAdapterJWMob.m
//  wanghaotest
//
//  Created by MOGO on 15-4-24.
//
//

#import "AdMoGoAdapterJWMob.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import <JWMobAdSDK/JWBannerAdView.h>
@interface AdMoGoAdapterJWMob()<JWBannerAdDelegate>{
    AdMoGoConfigData *configData;
    UIView *adView;
    NSTimer *timer;
    BOOL isStopTimer;
    BOOL isStop;
}
@end
@implementation AdMoGoAdapterJWMob
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeJWMob;
}

+ (void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStopTimer = NO;
    isStop = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    CGSize size = CGSizeZero;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = CGSizeMake(320.0f, 50.0f);
            break;
        case AdViewTypeiPhoneRectangle:
            size = CGSizeMake(300.0f, 250.0f);
            break;
        case AdViewTypeLargeBanner:
            size = CGSizeMake(720.0f, 90.0f);;
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }

    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSString class]]) {
        adView = [[UIView alloc] initWithFrame:CGRectMake(0.0,0.0, size.width, size.height)];
        
        [JWBannerAdView createBannerAdWithID:key
                                    delegate:self
                               enableLogging:NO
                                      isTest:NO];
        [JWBannerAdView showBannerAd:adView];
        
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
    else{
        [adMoGoCore adapter:self didFailAd:nil];
    }
}

-(void)stopBeingDelegate{
    [JWBannerAdView hiddenBannerAd];
}

- (void)stopAd{
    [self stopBeingDelegate];
    [adView removeFromSuperview];
    adView = nil;
}

- (void)dealloc {
    [self stopBeingDelegate];
    [super dealloc];
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

- (void)stopTimer {
    if (!isStopTimer) {
        isStopTimer = YES;
    }else{
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

#pragma mark - JWBannerAdDelegate
/*!
 @method
 @abstract 横幅广告成功展示时调用本方法
 */
- (void)onShowBannerScreenAd{
    if (isStop) {
        return;
    }
    [self stopTimer];
    UIView *view= [adView.subviews firstObject];
    CGRect frame = view.frame;
    frame.origin.x = 0.0f;
    frame.origin.y = 0.0f;
    view.frame = frame;
    [adMoGoCore adapter:self didReceiveAdView:adView];
}

/*!
 @method
 @abstract 横幅广告展示失败时调用本方法
 @param errorCode (错误码)
 */
- (void)didFailReceiveBannerAd:(NSString *)errorCode{
    if (isStop) {
        return;
    }
    [self stopTimer];
    MGLog(MGE, @"JWMob error %@",errorCode);
    [adMoGoCore adapter:self didFailAd:nil];
}

/*!
 @method
 @abstract 横幅广告隐藏时调用本方法
 */
- (void)onHiddenBannerScreenAd{

}
@end
