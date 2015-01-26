//
//  AdMoGoAdapterZhiXun.m
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 13-10-22.
//
//

#import "AdMoGoAdapterZhiXun.h"

@implementation AdMoGoAdapterZhiXun


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeZhiXun;
}
+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    isStopTimer = NO;
    isloadfail = NO;
    isSuccess = NO;
    [adMoGoCore adapter:self didGetAd:@"zhixun"];
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    UIViewController *viewController =[UIApplication sharedApplication].keyWindow.rootViewController;
    if (viewController==NULL) {
        [self stopAd];
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            zhiXun = [[AdSdk alloc] initAdWith320X50:viewController AppId:[self.ration objectForKey:@"key"] X:0 Y:0];
            break;
        case AdViewTypeLargeBanner:
            zhiXun = [[AdSdk alloc] initAdWith768X100:viewController AppId:[self.ration objectForKey:@"key"] X:0 Y:0];
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    self.adNetworkView = zhiXun;
    
    [zhiXun release];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adfinish) name:@"adArriveRecivedFinishNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aderror) name:@"adArriveRecivedErrorNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adclick) name:@"adArriveClickNotification" object:nil];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}

- (void)stopBeingDelegate{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopAd{
    isStop = YES;
    [self stopTimer];
    [self stopBeingDelegate];
}



- (void)dealloc{
    NSLog(@"%s",__func__);
    [self stopTimer];
    if (self.adNetworkView) {
        [self.adNetworkView removeFromSuperview];
        adNetworkView = nil;
        
        [zhiXun stopAd];
        [zhiXun removeFromSuperview];
        [zhiXun release];
        
    }
    [super dealloc];
}




// 成功加载广告后，回调该方法
-(void)adfinish{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:zhiXun];
    
    

}

// 加载广告失败后，回调该方法
-(void)aderror
{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self stopAd];
    [adMoGoCore adapter:self didFailAd:nil];
}

-(void)adclick
{
    
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

/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}

@end
