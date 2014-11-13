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
        DR_SHOW(DR_INSERSCREEN, uiViewController.view)
    }else{
        [self adapter:self didFailAd:nil];
    }
   
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dianruEnterNotify:) name:DR_ENTER object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dianruCloseNotify:) name:DR_CLOSE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(advertClickNotify:) name:DR_CLICK object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(dianruJumpNotify:) name:DR_JUMP object:nil];
    
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
#pragma mark - DianRuNotification

- (void)dianruEnterNotify:(NSNotification *)obj
{
    //注意 有可能obj是空
    [self stopTimer];
    if (obj) {
        UIView *view = [obj.userInfo objectForKey:@"view"];
        if (view) {
            [self stopTimer];
            [self adapter:self didReceiveInterstitialScreenAd:nil];
            [self adapter:self didShowAd:view];
        }else{
             [self adapter:self didFailAd:nil];
        }
    }else{
        [self adapter:self didFailAd:nil];
    }
}

- (void)dianruCloseNotify:(NSNotification *)obj
{
    NSLog(@"close %@", obj);
    [self adapter:self didDismissScreen:nil];
}

- (void)advertClickNotify:(NSNotification *)obj
{
    [self specialSendRecordNum];
}

- (void)dianruJumpNotify:(NSNotification *)obj
{
    
}





@end
