//
//  AdMoGoAdapterAdwoFullAd.m
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 12-10-29.
//
//

#import "AdMoGoAdapterAdwoFullAd.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"

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

//隐藏接口是为了处理delegate被释放了导致的crash 。这里可以重新对delegate赋值
extern BOOL AdwoAdSetDelegate(UIView *adView, NSObject<AWAdViewDelegate> *delegate);
extern BOOL AWSetAGGChannel(UIView *adView, enum ADWOSDK_AGGREGATION_CHANNEL channel);

@implementation AdMoGoAdapterAdwoFullAd

static UIView *adFullScreenView = nil;
static BOOL isReady = NO;
static NSObject<AWAdViewDelegate> *sDelegate = nil;//此处的代理是为了请求失败或者超时或者芒果的全屏广告对象释放了需要保留原来的adapter。后面adwo的广告对象加载失败了或者成功展示了会对这个对象进行释放，不用担心内存泄漏



+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdwo;
}

+(void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

-(void)getAd{
    
    isStop = NO;
    isStopTimer = NO;
    isSuccess = NO;
    isFail = NO;
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    AdViewType type = [configData.ad_type intValue];
    
    enum ADWOSDK_FSAD_SHOW_FORM  adwo_ad_type;
    
    //this class only have full screen type.
    if(type == AdViewTypeFullScreen || type == AdViewTypeiPadFullScreen){
        adwo_ad_type = ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND;
    }else{
        MGLog(MGT,@"全屏设置的尺寸有问题");
//        [interstitial adapter:self didFailAd:nil];
        [self adInterstitialFail];
        return;
    }
    
    // init AWAdView
    NSString *pid = [self.ration objectForKey:@"key"];
    BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
    
    
    
    if (adFullScreenView) {
        //如果广告对象已经存在，这里通过该方法，将新的代理类通知sdk
        AdwoAdSetDelegate(adFullScreenView, self);
        [self adapterDidStartRequestAd:self];
        [self adwoAdViewDidLoadAd:adFullScreenView];
        return ;
    }
    
    
    if (adFullScreenView ==nil) {
        
        [self adapterDidStartRequestAd:self];
        if (sDelegate) {
            [sDelegate release];
            sDelegate = nil;
        }
        
        sDelegate = [self retain];
        
        //这里建议用测试模式进去测试。
        adFullScreenView = AdwoAdGetFullScreenAdHandle(pid,!testMode,self, adwo_ad_type);
        //设置渠道号
        AWSetAGGChannel(adFullScreenView, ADWOSDK_AGGREGATION_CHANNEL_MOGO);
        
        if(adFullScreenView == nil)
        {
            MGLog(MGT,@"fs create failed: %@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
            if (sDelegate) {
                [sDelegate release];
                sDelegate = nil;
            }
            [self adInterstitialFail];
            return;
        }
        
        BOOL islocation = [configData islocationOn];
        if (islocation) {
            
            AdwoAdSetAdAttributes(adFullScreenView, &(struct AdwoAdPreferenceSettings){
                .disableGPS = NO                                       // 禁用GPS导航功能
            });
            
        }else{
            
            AdwoAdSetAdAttributes(adFullScreenView, &(struct AdwoAdPreferenceSettings){
                .disableGPS = YES                                       // 禁用GPS导航功能
            });
            
        }
        
        //这里的load全屏广告对象暂时不空制方向，因有的应用不需要方向控制。
        
        if(!AdwoAdLoadFullScreenAd(adFullScreenView, NO, NULL)){
            adFullScreenView = nil;  // 若加载失败，则SDK将会自动销毁当前的全屏广告对象，此时将全屏广告对象引用置空即可
            [self adapter:self didFailAd:nil];
        NSLog(@"fs load failed: %@",adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
        }
        
        NSLog(@"ration=%@ name=%@",ration,[ration objectForKey:@"nname"]);

        id _timeInterval = [self.ration objectForKey:@"to"];
        
       NSTimeInterval timeInt= AdwoAdGetFullScreenRequestInterval(ADWOSDK_FSAD_SHOW_FORM_APPFUN_WITH_BRAND);
        NSLog(@"tiem interval=%f",timeInt);
        
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
            
        }
        
    }else if(isReady){
        //如果广告对象已经存在，这里就可以直接调用adwoAdViewDidLoadAd这个接口去load广告。
        NSLog(@"ready is yes");
        [self adwoAdViewDidLoadAd:adFullScreenView];
    }else{
        
        [self adInterstitialFail];
        NSLog(@"adInterstitial failed");
        
    }
    
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    [self adapter:self didShowAd:nil];
    if(!AdwoAdShowFullScreenAd(adFullScreenView))
        NSLog(@"Adwo fs show failed: %@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
    
}

#pragma mark - AWAdView delegates

/**
 * 描述：当SDK需要弹出自带的Browser以显示mini site时需要使用当前广告所在的控制器。
 * AWAdView的delegate必须被设置，并且此接口必须被实现。
 * 返回：一个视图控制器对象
 */

- (UIViewController*)adwoGetBaseViewController{
    
    //这里建议返回根控制器，由于有的广告没有请求完就会销毁了FullAdViewController对象，导致获取该控制器失败。
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (viewController == NULL) {
        viewController = [self rootViewControllerForPresent];
    }
    return viewController;
    
}


- (void)adwoClickAdAction:(UIView*)adView{
    [self specialSendRecordNum];
}

/**
 * 描述：捕获当前加载广告失败通知。当你所创建的广告视图对象请求广告失败后，SDK将会调用此接口来通知。参数adView指向当前请求广告的AWAdview对象。开发者可以通过errorCode属性来查询失败原因。
 */
- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView{
    
    
    isReady = NO;
    adFullScreenView = nil;
    
    if (sDelegate) {
        [sDelegate release];
        sDelegate = nil;
    }
    
    int errCode = AdwoAdGetLatestErrorCode();
    MGLog(MGD,@"Adwo request failed, because: %@", adwoResponseErrorInfoList[errCode]);
    
    if (isStop) {
        return;
    }
    
    
    [self stopTimer];
    
    [self adInterstitialFail];
    
}

/**
 * 描述：捕获广告加载成功通知。当你广告加载成功时，SDK将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这个接口对于全屏广告展示而言，一般必须实现以捕获可以展示全屏广告的时机。
 */
- (void)adwoAdViewDidLoadAd:(UIView*)adView{
    
    
    isReady = YES;
    
    if (isStop) {
        MGLog(MGT,@"the stop value is yes");
        return;
    }else
        MGLog(MGT,@"stop value is no");
    
    
    [self stopTimer];
    
    [self adInterstitialSuccess:adView];
    
}

/**
 * 描述：当全屏广告被关闭时，SDK将调用此接口。一般而言，当全屏广告被用户关闭后，开发者应当释放当前的AWAdView对象，因为它的展示区域很可能发生改变。如果再用此对象来请求广告的话，展示可能会成问题。参数adView指向当前请求广告的AWAdView对象。
 */

- (void)adwoFullScreenAdDismissed:(UIView*)adView{
    
    
    //modify by xiaohua ============
    
    adFullScreenView = nil;
    isReady = NO;
    
    if (sDelegate) {
        
        [sDelegate release];
        sDelegate = nil;
        
    }
    
    [self adapter:self didDismissScreen:nil];
    
}

/**
 * 描述：当SDK弹出自带的全屏展示浏览器时，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里需要注意的是，当adView弹出全屏展示浏览器时，此adView不允许被释放，否则会导致SDK崩溃。
 */

- (void)adwoDidPresentModalViewForAd:(UIView*)adView{
    
    [self adapterAdModal:self willPresent:adView];
    
    
}

/**
 * 描述：当SDK自带的全屏展示浏览器被用户关闭后，将会调用此接口。参数adView指向当前请求广告的AWAdView对象。这里允许释放adView对象。
 */
- (void)adwoDidDismissModalViewForAd:(UIView*)adView{
    

    [self adapterAdModal:self didDismissScreen:adView];
    
}

-(void)stopAd{
    
    
    isStop = YES;
    
    [self stopBeingDelegate];
    
}

-(void)stopBeingDelegate{
    
    [self stopTimer];
    
    
}

- (void)stopTimer {
    
    
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    isStop = YES;
    
    [super loadAdTimeOut:theTimer];
    
    [self stopBeingDelegate];
    
    [self adInterstitialFail];
    
}

- (void)dealloc{
    [self stopTimer];
    [super dealloc];
}

- (void)adInterstitialFail{
    if ((isFail == isSuccess) && !isFail) {
        isFail = YES;
        
        if ([self respondsToSelector:@selector(adapter:didFailAd:)]) {
            [self adapter:self didFailAd:nil];
        }
    }
}

- (void)adInterstitialSuccess:(UIView *)adView{
    if ((isFail == isSuccess) && !isSuccess) {
        isSuccess = YES;
        
        if ([self respondsToSelector:@selector(adapter:didReceiveInterstitialScreenAd:)]) {
            [self adapter:self didReceiveInterstitialScreenAd:adView];
        }
    }
}

@end
