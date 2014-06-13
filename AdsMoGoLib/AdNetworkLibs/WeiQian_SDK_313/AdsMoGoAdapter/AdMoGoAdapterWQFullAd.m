//
//  AdMoGoAdapterWQFullAd.m
//  wanghaotest
//
//  Created by MOGO on 13-9-28.
//
//

#import "AdMoGoAdapterWQFullAd.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "WQADViewBaseClass+platform.h"
#import "WQADViewBaseClass.h"

#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"

#import "AdMoGoDeviceInfoHelper.h"

#define kAdMoGoWQAppID @"AppID"
#define kAdMoGoWQPublisherID @"PublisherID"
#define kAdMoGoWQAccountKey @"AccountKey"

@interface AdMoGoAdapterWQFullAd (){
    
    BOOL isStop;
    
}

@end

@implementation AdMoGoAdapterWQFullAd
//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeWQ IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeWQ;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    isReady = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    
    AdViewType type =[configData.ad_type intValue];
    isReady =NO;
    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
            break;
            
        default:
            [self adapter:self didFailAd:nil];
            return;
            break;
    }
    UIViewController *viewContoller  = [self rootViewControllerForPresent];
    NSString *adSloatID = [[self.ration objectForKey:@"key"] objectForKey:kAdMoGoWQAppID];
    NSString *accountKey = [[self.ration objectForKey:@"key"] objectForKey:kAdMoGoWQPublisherID];
    MGLog(MGT,@"adSloatID %@",adSloatID);
    MGLog(MGT,@"accountKey %@",accountKey);
    BOOL islocation = [configData islocationOn];
    _interstitialAdView = [[WQInterstitialAdView alloc] initWithFrame:viewContoller.view.bounds andAdSloatID:adSloatID andAccountKey:accountKey withLocationEnabled:islocation];
    AdMoGoDeviceInfoHelper *infoHelper = [[AdMoGoDeviceInfoHelper alloc] init];
    NSString *mogoVersion = [infoHelper getMoGoSDKVersion];
    [_interstitialAdView setAdPlatform:@"adsmogofc5deaf624fd1" AdPlatformVersion:mogoVersion];
    [infoHelper release];
    _interstitialAdView.storeKitEnabled = YES;
    _interstitialAdView.delegate=self;
//    [viewContoller.view addSubview:_interstitialAdView];
//    [_interstitialAdView release];
    [self adapterDidStartRequestAd:self];
    
    [_interstitialAdView loadInterstitialAd];//如果广告没有就绪，调用loadInterstitialAd
    
   
    
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut30
//                                              target:self
//                                            selector:@selector(loadAdTimeOut:)
//                                            userInfo:nil
//                                             repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}


- (void)stopBeingDelegate {
    _interstitialAdView.delegate = nil;
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    MGLog(MGT,@"loadAdTimeOut");
    
    [super loadAdTimeOut:theTimer];
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
    
}

- (void)stopAd{
    MGLog(MGT,@"wq fullscreen stopAd");
    isStop = YES;
    if ([_interstitialAdView isKindOfClass:[WQInterstitialAdView class]]) {
        _interstitialAdView.hidden = YES;
        
    }
    [self stopTimer];
}

- (BOOL)isReadyPresentInterstitial{
    return [_interstitialAdView isInterstitialAdReady];
}

- (void)presentInterstitial{
    if ([_interstitialAdView isInterstitialAdReady]) {
        UIViewController *viewController  = [self rootViewControllerForPresent];
        [viewController.view addSubview:_interstitialAdView];
        [_interstitialAdView release];
        [_interstitialAdView showInterstitialAd];
    }
}

- (void)stopTimer{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)dealloc{
    if ([_interstitialAdView isKindOfClass:[WQInterstitialAdView class]]) {
        _interstitialAdView.delegate = nil;
        [_interstitialAdView removeFromSuperview];
        _interstitialAdView = nil;
    }
    [super dealloc];
}

#pragma mark - interstitial ad view delegate method(s)
//当插屏广告展示成功时调用该方法
-(void) onInterstitialAdViewed:(WQInterstitialAdView *)pAdView
{
    if (isStop) {
        return;
    }
    [self adapter:self didShowAd:pAdView];
    MGLog(MGT,@"Interstitial ad viewed");
}

//当插屏广告被点击时回调该方法
-(void) onInterstitialAdClicked:(WQInterstitialAdView *)pAdView
{
    if (isStop) {
        return;
    }
    [self specialSendRecordNum];
    MGLog(MGT,@"Interstitial ad clicked");
}

//当插屏广告被成功加载后，回调该方法，pAllLoaded 为 true，表示所有的广告已经加载完成（一次广告加载可能会加载多条广告）
-(void) onInterstitialAdRequestLoaded:(WQInterstitialAdView*)pAdView  allLoaded:(BOOL)pAllLoaded
{
    
    if (isStop) {
        return;
    }
    
    if (isReady) {
        return;
    }
    
    if (pAllLoaded)
    {
        MGLog(MGT,@"All ads has been loaded successfully.");
    }
    else
    {
        MGLog(MGT,@"A ads has been loaded successfully.");
    }
    [self stopTimer];
    if (!isReady) {
        isReady = YES;
        [self adapter:self didReceiveInterstitialScreenAd:pAdView];
    }
    
}

//当插屏广告被加载失败后，回调该方法
-(void) onInterstitialAdRequestFailed:(WQInterstitialAdView*)pAdView
{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
    MGLog(MGT,@"Loading ads request failed.");
}

//当插屏广告要展示出来前，回调该方法
-(void) onInterstitialAdPresent:(WQInterstitialAdView*)pAdView
{
    MGLog(MGT,@"Ad is about to show.");
}

//当插屏广告被关闭后，回调改方法，广告视图已经被移除
-(void) onInterstitialAdDismiss:(WQInterstitialAdView*)pAdView
{
    if (isStop) {
        return;
    }
    MGLog(MGT,@"Ad is closed");
    [self adapter:self didDismissScreen:nil];
}

//当要呈现 Modal View 时，回调该方法，如打开内置浏览器
-(void) wqInterstitialAdWillPresentModalView:(WQInterstitialAdView*)pAdView
{
    MGLog(MGT,@"Ad is about to open web page with internal browser.");
}

//当呈现的 Modal View 即将关闭时，回调该方法，如关闭内置浏览器
-(void) wqInterstitialAdDidDismissModalView:(WQInterstitialAdView*)pAdView
{
    MGLog(MGT,@"Ad is about to close internal browser and return to app");
}

//SDK用presentModalViewController的方式来打开广告内部的链接，这里需要返回一个view controller用作presentingViewController
-(UIViewController*) controllerForPresentingModelViewInInterstitialAdView:(WQInterstitialAdView*)pAdView
{
    if (isStop) {
        return nil;
    }
    return [self rootViewControllerForPresent];
}

@end
