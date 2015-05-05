//
//  AdMoGoAdapterBaiduSplash.m
//  wanghaotest
//
//  Created by mogo on 13-11-15.
//
//

#import "AdMoGoAdapterBaiduSplash.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"
#import "BaiduMobAdSplash.h"
@implementation AdMoGoAdapterBaiduSplash

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeBaiduMobAd;
}

+ (void)load{
    [[AdMoGoAdSDKSplashNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd{
    isFail = NO;
    isSuccess = NO;
    splash = [[BaiduMobAdSplash alloc] init];
    splash.delegate = self;
    splash.canSplashClick = YES;
    [splash loadAndDisplayUsingKeyWindow:[splashAds getWindow]];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}

- (void)stopTimer{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}
-(void)stopBeingDelegate{
    if(splash){
        splash.delegate = nil;
        [splash release],splash = nil;
    }
    
}


- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    
    [super loadAdTimeOut:theTimer];
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [self adFailWith:nil];
}
-(void)dealloc{
    [super dealloc];
}
#pragma mark BaiduMobAdInterstitialDelegate
/**
 *  应用在union.baidu.com上的APPID
 */
- (NSString *)publisherId{
    NSString *publishId = [[self.ration objectForKey:@"key"] objectForKey:@"AppID"];
    return publishId;
}



/**
 *  渠道id
 */
- (NSString*) channelId{
    return @"13b50d6f";
}

/**
 *  广告展示成功
 */
- (void)splashSuccessPresentScreen:(BaiduMobAdSplash *)splash{
    [self stopTimer];
    [self adSuccess:splash];
}

/**
 *  广告展示失败
 */
- (void)splashlFailPresentScreen:(BaiduMobAdSplash *)splash withError:(BaiduMobFailReason) reason{
    [self stopTimer];
    [self adFailWith:nil];
}

/**
 *  广告展示结束
 */
- (void)splashDidDismissScreen:(BaiduMobAdSplash *)splash{
    [self.splashAds adSplash:self didDismiss:splash];
}


- (void)adSuccess:(id) _awSplash{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [self.splashAds adSplashSuccess:self withSplash:_awSplash];
    }
}

- (void)adFailWith:(NSError *)error{
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [self.splashAds adSplashFail:self withError:error];
    }
}

@end
