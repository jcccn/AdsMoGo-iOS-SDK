//
//  AdMoGoAdapterAdwoSplash.m
//  wanghaotest
//
//  Created by mogo on 13-11-13.
//
//

#import "AdMoGoAdapterAdwoSplash.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"

static NSString* const adwoResponseErrorInfoList[] = {
    @"操作成功",
    @"广告初始化失败",
    @"当前广告已调用了加载接口",
    @"不该为空的参数为空",
    @"参数值非法",
    @"非法广告对象句柄",
    @"代理为空或adwoGetBaseViewController方法没实现",
    @"非法的广告对象句柄引用计数",
    @"意料之外的错误",
    @"已创建了过多的Banner广告，无法继续创建",
    @"广告加载失败",
    @"全屏广告已经展示过",
    @"全屏广告还没准备好来展示",
    @"全屏广告资源破损",
    @"开屏全屏广告正在请求",
    @"当前全屏已设置为自动展示",
    
    @"服务器繁忙",
    @"当前没有广告",
    @"未知请求错误",
    @"PID不存在",
    @"PID未被激活",
    @"请求数据有问题",
    @"接收到的数据有问题",
    @"当前IP下广告已经投放完",
    @"当前广告都已经投放完",
    @"没有低优先级广告",
    @"开发者在Adwo官网注册的Bundle ID与当前应用的Bundle ID不一致",
    @"服务器响应出错",
    @"设备当前没连网络，或网络信号不好",
    @"请求URL出错",
    @"初始化出错"
};
@implementation AdMoGoAdapterAdwoSplash

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdwo;
}

+ (void)load{
    [[AdMoGoAdSDKSplashNetworkRegistry sharedRegistry] registerClass:self];
}

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeAdwo IsSDK:YES isApi:NO isAutoOptimize:NO isS2S:NO isSplash:YES];
//    
//}
//
//+(void)load{
//    [[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

-(void)getAd{
    
    isSuccess = NO;
    isFail = NO;
    NSString *pid = [self.ration objectForKey:@"key"];
    BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
    
    
    adWoSplash = AdwoAdGetFullScreenAdHandle(pid, !testMode, self, ADWOSDK_FSAD_SHOW_FORM_LAUNCHING);
    [self.splashAds adapterDidStartRequestSplashAd:self];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:splashAds.config_key];
    BOOL islocation = [configData islocationOn];
    if (islocation) {
        //            adView.disableGPS = NO;
        AdwoAdSetAdAttributes(adWoSplash, &(struct AdwoAdPreferenceSettings){
            .disableGPS = NO                                       // 禁用GPS导航功能
        });
    }else{
        //            adView.disableGPS = YES;
        AdwoAdSetAdAttributes(adWoSplash, &(struct AdwoAdPreferenceSettings){
            .disableGPS = YES                                       // 禁用GPS导航功能
        });
    }
    
    // 这里设置动画形式为无动画模式。如果不设置则由系统自动给出
    AdwoAdSetAdAttributes(adWoSplash, &(const struct AdwoAdPreferenceSettings){
        .animationType = ADWO_SDK_FULLSCREEN_ANIMATION_TYPE_NONE
    });
    
    // 开始加载全屏广告，并不锁定方向旋转
    mCanShowAd = AdwoAdLoadFullScreenAd(adWoSplash, YES, 20) == YES;

//    mCanShowAd = AdwoAdLoadFullScreenAd(adWoSplash, YES) == ADWOSDK_LOAD_AD_STATUS_LOAD_AD_SUCCESSFUL;
    
    if (!mCanShowAd) {
        int errCode = AdwoAdGetLatestErrorCode();
        MGLog(MGT,@"Adwo request splash failed, because: %@", adwoResponseErrorInfoList[errCode]);
    }
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut2 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (BOOL)isSupportSplashCache{
    return YES;
}

- (void)dealloc{
    [super dealloc];
}

- (void)loadAdTimeOut:(NSTimer *)_timer{
    
    [super loadAdTimeOut:_timer];
    
    [self adFailWith:nil];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    
}

- (UIViewController*)adwoGetBaseViewController{
    
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (viewController == NULL) {
        viewController = [self.adMoGoSplashAdsDelegate adsMoGoSplashAdsViewControllerForPresentingModalView];
    }
    return viewController;
}



/**
 * 描述：捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的AWAdview对象。开发者可以通过errorCode属性来查询失败原因。
 */
- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView{
    adWoSplash = nil;
    [self stopTimer];
    [self performSelectorOnMainThread:@selector(adFailWith:) withObject:nil waitUntilDone:NO];
}

/**
 * 描述：捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
 */
- (void)adwoAdViewDidLoadAd:(UIView*)adView{
    MGLog(MGT,@"%s",__func__);
    [self stopTimer];
    if(adWoSplash != adView){
        // 失败
//        [self nil];
        [self performSelectorOnMainThread:@selector(adFailWith:) withObject:nil waitUntilDone:NO];
        return;
    }
    
    
    if(!mCanShowAd)
    {
        // 若当前开屏广告资源没准备好，则直接将mAdView置空
        
        adWoSplash = nil;
        // 失败
        [self performSelectorOnMainThread:@selector(adFailWith:) withObject:nil waitUntilDone:NO];
    }
    else
    {
        // 广告加载成功，可以把全屏广告展示上去
        BOOL status=AdwoAdShowFullScreenAd(adWoSplash);
        if (status) {
            mCanShowAd = NO;
            [self performSelectorOnMainThread:@selector(adSuccess:) withObject:adWoSplash waitUntilDone:NO];
            // 成功
        }else{
            adWoSplash = nil;
            // 失败
            [self performSelectorOnMainThread:@selector(adFailWith:) withObject:nil waitUntilDone:NO];
        }
     }
}

/**
 * 描述：当全屏广告被关闭时，SDK将调用此接口。一般而言，当全屏广告被用户关闭后，开发者应当释放当前的AWAdView对象，因为它的展示区域很可能发生改变。如果再用此对象来请求广告的话，展示可能会成问题。参数adView指向当前请求广告的AWAdView对象。
 */
- (void)adwoFullScreenAdDismissed:(UIView*)adView{
    [self.splashAds adSplash:self didDismiss:adView];

}

/**
 * 描述：当SDK弹出自带的全屏展示浏览器时，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里需要注意的是，当adView弹出全屏展示浏览器时，此adView不允许被释放，否则会导致SDK崩溃。
 */
- (void)adwoDidPresentModalViewForAd:(UIView*)adView{

}

/**
 * 描述：当SDK自带的全屏展示浏览器被用户关闭后，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里允许释放adView对象。
 */
- (void)adwoDidDismissModalViewForAd:(UIView*)adView{

}

- (void)adSuccess:(UIView *) _awSplash{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [self.splashAds adSplashSuccess:self withSplash:_awSplash];
    }
}

- (void)adFailWith:(NSError *)error{
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        int errCode = AdwoAdGetLatestErrorCode();
        MGLog(MGT,@"Ad request failed, because: %@", adwoResponseErrorInfoList[errCode]);
        [self.splashAds adSplashFail:self withError:error];
    }
}
@end
