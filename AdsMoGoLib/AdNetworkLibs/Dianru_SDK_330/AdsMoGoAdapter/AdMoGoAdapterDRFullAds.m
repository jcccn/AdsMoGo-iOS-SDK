//
//  AdMoGoAdapterDianruFullAds.m
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 13-12-31.
//
//

#import "AdMoGoAdapterDRFullAds.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"

#ifndef k_dianru_btn_size
#define k_dianru_btn_size 250
#endif

@implementation AdMoGoAdapterDRFullAds


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeDR;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    
    isStop = NO;
    isStopTimer = NO;
    callNum = 0;
    isPresnt = NO;
    isreceived = NO;
    isDianruDisappear = NO;
    isclicked = NO;
    [self adapterDidStartRequestAd:self];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    AdViewType type = [configData.ad_type intValue];
    
    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
            break;
            
        default:
            [self adapter:self didFailAd:nil];
            return;
            break;
    }
    
    [TalkingDataSDK init];
    
    MGLog(MGT,@"dianru full timer %@",timer);
   
    
}

- (BOOL)isReadyPresentInterstitial{
    return YES;
}

- (void)presentInterstitial{

    
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSString class]] && key != nil) {
        DR_INIT(key, NO, nil);
        UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
        DR_SHOW(DR_INSERSCREEN, uiViewController.view, self);
    }else{
        [self adapter:self didFailAd:nil];
        return;
    }
   

    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopBeingDelegate{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopAd{
    
    [self stopBeingDelegate];
    isStop = YES;
}

- (void)dealloc{
    [self stopTimer];
    [super dealloc];
}

- (void)stopTimer{
    
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

- (void)loadAdTimeOut:(NSTimer *)theTimer{
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}
#pragma mark - YQLDelegate
/*
 请求广告条数
 如果广告条数大于0，那么code=0，代表成功
 反之code = -1
 */
- (void)dianruDidDataReceivedView:(UIView *)view
                       dianruCode:(int)code{
    //注意 有可能obj是空
    [self stopTimer];
    if(code == -1){
        // 失败
         [self adapter:self didFailAd:nil];
    }else{
        // 成功
        [self adapter:self didReceiveInterstitialScreenAd:nil];
    }
}

/*
 广告弹出时回调
 view有可能是空注意保护
 */
- (void)dianruDidViewOpenView:(UIView *)view{
    if (view) {
        //        [self.view addSubview:view];
        //然后想怎么加怎么加
    }else{
    
    }
}

/*
 点击广告关闭按钮的回调，不代表广告从内存中释放
 */
- (void)dianruDidMainCloseView:(UIView *)view{
    NSLog(@"close %@", view);
    [self adapter:self didDismissScreen:nil];
}

/*
 广告释放时回调，从内从中释放
 */
- (void)dianruDidViewCloseView:(UIView *)view{
//    if (self.drBgView) [self.drBgView removeFromSuperview];
    
    
}

/*
 曝光回调
 */
- (void)dianruDidReportedView:(UIView *)view
                   dianruData:(id)data{
    [self adapter:self didShowAd:view];
}

/*
 点击广告回调
 */
- (void)dianruDidClickedView:(UIView *)view
                  dianruData:(id)data{
    [self specialSendRecordNum];
}

/*
 点击跳转回调
 */
- (void)dianruDidJumpedView:(UIView *)view
                 dianruData:(id)data{

}





@end
