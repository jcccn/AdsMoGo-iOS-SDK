//
//  AdMoGoAdapterZhiXunInterstitial.m
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 13-10-23.
//
//

#import "AdMoGoAdapterZhiXunInterstitial.h"

@implementation AdMoGoAdapterZhiXunInterstitial
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeZhiXun;
}


+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    isStopTimer = NO;
    isPadDevice=NO;
    
}

-(void)stopBeingDelegate{
    MGLog(MGT,@"%s",__func__);
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [zhiXunFull stopAd];

    
    if ([zhiXunFull isKindOfClass:[AdSdk class]]) {
        [zhiXunFull removeFromSuperview];
        zhiXunFull = nil;
    }
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    
}

- (void)dealloc {
    
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return YES;
}

- (void)presentInterstitial{
    // 呈现插屏广告
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    AdViewType type =[configData.ad_type intValue];
    id key = [self.ration objectForKey:@"key"];
    
    
    //获取用于展示插屏的UIViewController
    uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(!uiViewController){
        uiViewController = [self rootViewControllerForPresent];
    }
    
    
    if(uiViewController){
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adfinish) name:@"adArriveRecivedFinishNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(aderror) name:@"adArriveRecivedErrorNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(adclick) name:@"adArriveClickNotification" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(adclose) name:@"adArriveRecivedCloseNotification" object:nil];
        
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        
    }
    else{
        [self adapter:self didFailAd:nil];
        return;
    }
    
    
    switch (type) {
        case AdViewTypeFullScreen:
            zhiXunFull = [[AdSdk alloc] initAdWith300X250:uiViewController AppId:key X:0.0 Y:0.0];
            break;
        case AdViewTypeiPadFullScreen:
            zhiXunFull = [[AdSdk alloc] initAdWith600X500w:uiViewController AppId:key X:0.0 Y:0.0];
            isPadDevice = YES;
            break;
        default:
            [self adapter:self didFailAd:nil];
            return;
            break;
    }
    [self adapterDidStartRequestAd:self];
    [zhiXunFull startAd];

    [uiViewController.view addSubview:zhiXunFull];
    [zhiXunFull release];
    
    
}

#pragma mark ZhiXunNotification Delegate
// 当插屏广告被成功加载后，回调该方法
-(void)adfinish{
    MGLog(MGT,@"zhixun interstitial adfinish");
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"adArriveRecivedFinishNotification" object:nil];
    
    
    if (isStop) {
        return;
    }
    [self stopTimer];
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        zhiXunFull.center = CGPointMake(uiViewController.view.center.y, uiViewController.view.center.x);
    }else{
        zhiXunFull.center = uiViewController.view.center;
    }
    
    [self adapter:self didReceiveInterstitialScreenAd:zhiXunFull];
    [self adapter:self didShowAd:nil];
}

// 当插屏广告加载失败后，回调该方法
-(void)aderror
{
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"adArriveRecivedErrorNotification" object:nil];
    
    MGLog(MGT,@"zhixun interstitial aderror");
    if (isStop) {
        return;
    }
    [self stopTimer];
    
    
    if ([zhiXunFull isKindOfClass:[AdSdk class]]) {
        [zhiXunFull stopAd];
    }
    
    [self adapter:self didFailAd:nil];
}

-(void)adclick
{
    
    [self specialSendRecordNum];
    [self adclose];
}

-(void)adclose
{

    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self performSelectorOnMainThread:@selector(dismissAD) withObject:nil waitUntilDone:NO];
   
}

- (void)dismissAD{
     [self adapter:self didDismissScreen:zhiXunFull];
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
    
    if ([zx_interstitial_super_view isKindOfClass:[UIView class]]) {
        [zx_interstitial_super_view removeFromSuperview];
        zx_interstitial_super_view = nil;
    }
    
    if ([zhiXunFull isKindOfClass:[AdSdk class]]) {
        [zhiXunFull stopAd];
    }
    
    [self adapter:self didFailAd:nil];
}

@end
