//
//  AdMoGoAdapterDianruFullAds.m
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 13-12-31.
//
//

#import "AdMoGoAdapterDianruFullAds.h"
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

@implementation AdMoGoAdapterDianruFullAds


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeDianru;
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
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
    MGLog(MGT,@"dianru full timer %@",timer);
    
    [DianRuSDK requestAdmobileViewWithDelegate:self];
    
    
}

- (BOOL)isReadyPresentInterstitial{
    return isreceived;
}

- (void)presentInterstitial{
    if (isreceived==NO) {
        return ;
    }
    
    if (isPresnt == YES) {
        return;
    }else{
        isPresnt = YES;
        
        UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
//        sdkView.bounds = uiViewController.view.bounds;
        [self addAdClickListener:sdkView];
        [uiViewController.view addSubview:sdkView];
        
        [self adapter:self didShowAd:sdkView];
     }
}

- (void)stopBeingDelegate{
//    if (sdkView) {
//        [sdkView removeFromSuperview];
//        sdkView = nil;
//    }
    
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

#pragma mark - DianRuSDKDelegate
- (NSString *)applicationKey{
    return [self.ration objectForKey:@"key"];
}

- (int) adType{
    return 1;
}


- (int)adDisplayTime{
    return 600;
}

//- (NSString *)keyWords
//{
//    return @"生活";
//}

- (UIViewController *)viewControllerForPresentingModalView{
    return [self rootViewControllerForPresent];
}


//预缓存代理函数 向后台请求数据
-(void)adLoadResult:(BOOL)isLoadedResult{
    if(isLoadedResult){
        NSLog(@"加载数据成功!");
        
        [DianRuSDK getView];
        isreceived = YES;
        
    }else{
        NSLog(@"加载数据失败,加载出现问题!");
        [self adapter:self didFailAd:nil];
    }
    
}

- (void)didReceiveAdView:(UIView *)adView{
    [self stopTimer];
    if(!sdkView)
    {
        
        sdkView = adView;
        //      [self.view addSubview:sdkView];
    }
}

/*介绍:
 *      加载图形结果； 返回YES表示加载图形成功
 */

-(void)adLoadViewResult:(BOOL)isLoadedViewResult{
    if (isLoadedViewResult) {
        
        
        
        [self adapter:self didReceiveInterstitialScreenAd:sdkView];
    }else{
        [self adapter:self didFailAd:nil];
    }
}


- (void)adDisappearResult:(BOOL)isDisappear
{
    if (isDianruDisappear) {
        return;
    }
    if (isDisappear == YES) {
        [self adapter:self didDismissScreen:nil];
        isDianruDisappear = YES;
    }
}

#pragma mark -
#pragma mark adsMogo ad click count
- (void)addAdClickListener:(UIView *) adView{
    
    NSArray *array = [adView subviews];
    for (UIView* subView in array) {
        
        if ([subView isKindOfClass:[UIButton class]] && subView.frame.size.width >= k_dianru_btn_size) {
            [(UIButton *)subView addTarget:self
                                    action:@selector(adDidClick:)
                          forControlEvents:UIControlEventTouchDown];
            
            break;
            
        }
        
    }
    
}

- (void)adDidClick:(id)sender{
    if (!isclicked) {
        isclicked = YES;
    }else{
        return;
    }
    
    [self specialSendRecordNum];
    
}

@end
