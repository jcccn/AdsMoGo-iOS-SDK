//
//  AdMoGoAdapterlomarkInterstitial.m
//  wanghaotest
//
//  Created by mogo on 14-4-4.
//
//

#import "AdMoGoAdapterlomarkInterstitial.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"

@implementation AdMoGoAdapterlomarkInterstitial
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeLomark;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    isLoaded = NO;
//    initAdChinaFrame = CGRectZero;
    
    /*
     获取广告类型
     原来代码：AdViewType type = adMoGoView.adType;
     */
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    AdViewType type =[configData.ad_type intValue];
    CGSize myADSize = CGSizeZero;
	if (type == AdViewTypeFullScreen ||
        type == AdViewTypeiPadFullScreen) {
        if (isIPad) {
            myADSize = FWSIZE_600_500;
        }else{
            myADSize =  FWSIZE_300_250;
        }
    }
    
    
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *appKey = nil;
    NSString *secretKey = nil;
    NSString *appId = [[NSBundle mainBundle] bundleIdentifier];
    appKey = [[self.ration objectForKey:@"key"] objectForKey:@"appkey"];
    secretKey = [[self.ration objectForKey:@"key"] objectForKey:@"secretkey"];
    
    
    _fwView = [[LomarkAdView alloc] initWithAdType:LomarkAdTypeFloatWindow appCategory:AppOther appId:appId appKey:appKey appSecret:secretKey appName:appName size:myADSize autoTimeInterval:15];
    _fwView.delegate = self;
    [_fwView setFrame:CGRectMake(0, 0, myADSize.width, myADSize.height)];
    [self adapterDidStartRequestAd:self];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopBeingDelegate {
    /*2013*/
    if (_fwView) {
        _fwView.delegate = nil;
    }
    
}

- (void)stopAd{
    [self stopBeingDelegate];
    [self stopTimer];
    isStop = YES;
    
    
}

- (void)dealloc {
    MGLog(MGT,@"remove ad");
    if (_fwView && ![_fwView isKindOfClass:[NSNull class]]) {
        if ([_fwView superview]) {
            [_fwView removeFromSuperview];
        }
        [_fwView release];
        _fwView = nil;
    }
    [super dealloc];
    
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}


- (BOOL)isReadyPresentInterstitial{
    return isLoaded;
}


- (void)sendAdFullClick{
    if (isStop) {
        return;
    }
    [self specialSendRecordNum];
}


-(void)presentInterstitial{
    UIViewController *viewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if (viewController) {
        viewController = [self rootViewControllerForPresent];
        
    }
    CGSize size = [UIScreen mainScreen].bounds.size;
    if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
        _fwView.center = CGPointMake(size.height/2, size.width/2);
    }else{
        _fwView.center = CGPointMake(size.width/2, size.height/2);
    }
    
    [viewController.view addSubview:_fwView];
    [self adapter:self didShowAd:_fwView];
}

/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

//即将请求广告数据
- (void)adViewWillLoadAd:(UIView *)view{

}

//获取到可展示的广告数据，加载广告
- (void)adViewDidLoadAd:(UIView *)view{
    if (isStop) {
        return;
    }
    [self stopTimer];
    isLoaded=YES;
    [self adapter:self didReceiveInterstitialScreenAd:view];
}

//获取到不可展示的广告数据 或者 没有获取到可展示的广告数据
- (void)adView:(UIView *)view didFailToReceiveAdWithError:(NSError *)error{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];;
}

//广告展示被点击，将要打开广告地址
-(void)adViewDidClicked:(UIView *)view{
    [self sendAdFullClick];
}


//视图被移除
-(void)adViewDidRemoved:(UIView *)view{
    [self adapter:self didDismissScreen:nil];
}
@end
