//
//  AdMoGoAdapterRmob.m
//  wanghaotest
//
//  Created by MOGO on 14-10-28.
//
//

#import "AdMoGoAdapterRmob.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdMoGoAdapterRmob
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeRmob;
}

+(void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {

    
    isStop = NO;
    isStopTimer = NO;
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    [adMoGoCore adapter:self didGetAd:@"rmob"];
    
    AdViewType type =[configData.ad_type intValue];
    CGRect rect = CGRectZero;
    switch (type) {
        case AdViewTypeNormalBanner:
            rect = CGRectMake(0,0,320, 48);
            break;
        case AdViewTypeiPadNormalBanner:
            rect = CGRectMake(0,0,320,50);
            break;
        case AdViewTypeLargeBanner:
            rect = CGRectMake(0,0,728,90);
            break;
        case AdViewTypeMediumBanner:
            rect = CGRectMake(0,0,468,60);
            break;
        default:
            MGLog(MGD, @"rmob 对这种广告形式不支持");
            break;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:rect];
    self.adNetworkView = view;
    [view release];
    
    
    NSString *adzoneid = [[ration objectForKey:@"key"] objectForKey:@"adzoneid"];
    NSString *publisherID = [[ration objectForKey:@"key"] objectForKey:@"publisher ID"];
    BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
    if (testMode) {
        [RmobSDK startAdService:self.adNetworkView appID:publisherID adzoneid:adzoneid adFrame:rect mode:ModeTest];
    }else{
        [RmobSDK startAdService:self.adNetworkView appID:publisherID adzoneid:adzoneid adFrame:rect mode:ModeRelease];
    }
    
    [RmobSDK setDelegate:self];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        //timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        timer = [[NSTimer scheduledTimerWithTimeInterval:60 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
    
    
}

- (void)stopBeingDelegate {
    [RmobSDK setDelegate:nil];
    [RmobSDK stopAdService];
    
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    [self stopTimer];
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

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)dealloc {
    
    [super dealloc];
}


//开启定位  默认值YES
- (BOOL)rmobOpenLocation
{
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    BOOL isLocationOn = [configData islocationOn];
    return  isLocationOn;
}


//成功收到广告
- (void)didSucceedToReceiveAd:(NSInteger)count
{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
    
}

//收到错误信息
- (void) didReceiveError:(NSError *)error
{
    NSLog(@"Received Error is : %@",error);
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    [adMoGoCore adapter:self didFailAd:error];
}

//将要弹出新的视图
- (void)rmobAdWillPresentViewController
{
    NSLog(@"rmobAdWillPresentViewController.");
    [self helperNotifyDelegateOfFullScreenModal];
}

//Dismiss弹出的视图
- (void)rmobAdDidDismissViewController
{
    NSLog(@"rmobAdDidDismissViewController.");
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}


@end
