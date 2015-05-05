//
//  AdMoGoAdapterWQVideoAd.m
//  wanghaotest
//
//  Created by Castiel Chen on 15/3/10.
//
//

#import "AdMoGoAdapterWQVideoAd.h"
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


@interface AdMoGoAdapterWQVideoAd()<WQInterstitialAdViewDelegate>
{
    WQInterstitialAdView * _interstitialAdView;
     BOOL isReady;
     BOOL isStop;
    NSTimer *timer;
}
@end

@implementation AdMoGoAdapterWQVideoAd
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeWQ;
}

+ (void)load{
    [[AdMoGoAdAPIVideoNetworkRegistry sharedRegistry] registerClass:self];
}

-(BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)getAd{
    isStop = NO;
    isReady = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    
    AdViewType type =[configData.ad_type intValue];
    isReady =NO;
    switch (type) {
        case AdViewTypeVideo:
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
    
//    adSloatID =@"dc58ac6904a4ee786c14aefb01ea64ca";
//    accountKey=@"c73d49b0e4a05f3993e4b25eee44623f";
    
    BOOL islocation = [configData islocationOn];
    _interstitialAdView = [[WQInterstitialAdView alloc] initWithFrame:viewContoller.view.bounds andAdSloatID:adSloatID andAccountKey:accountKey withLocationEnabled:islocation];
    AdMoGoDeviceInfoHelper *infoHelper = [[AdMoGoDeviceInfoHelper alloc] init];
//    NSString *mogoVersion = [infoHelper getMoGoSDKVersion];
//    [_interstitialAdView setAdPlatform:@"adsmogofc5deaf624fd1" AdPlatformVersion:mogoVersion];
    [infoHelper release];
    _interstitialAdView.storeKitEnabled = YES;
    _interstitialAdView.delegate=self;
 
    [self adapterDidStartRequestAd:self];
    
    [_interstitialAdView loadInterstitialAd];//如果广告没有就绪，调用loadInterstitialAd
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }

}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}



-(void)playVideoAd{
    if ([_interstitialAdView isInterstitialAdReady]) {
        UIViewController *viewController  = [self rootViewControllerForPresent];
        [viewController.view addSubview:_interstitialAdView];
        [_interstitialAdView showInterstitialAd];
    }
}


//当插屏广告被成功加载后，回调该方法，pAllLoaded 为 true，表示所有的广告已经加载完成（一次广告加载可能会加载多条广告）
-(void) onInterstitialAdRequestLoaded:(WQInterstitialAdView*)pAdView  allLoaded:(BOOL)pAllLoaded{
    if (!isReady) {
        isReady =YES;
         [self stopTimer];
        [self adapter:self didReceiveInterstitialScreenAd:nil];
    }
}
//当插屏广告被加载失败后，回调该方法
-(void) onInterstitialAdRequestFailed:(WQInterstitialAdView*)pAdView{
    [self adapter:self didFailAd:nil];
}
//当插屏广告要展示出来前，回调该方法
-(void) onInterstitialAdPresent:(WQInterstitialAdView*)pAdView{
   
}
//当插屏广告被关闭后，回调改方法，广告视图已经被移除
-(void) onInterstitialAdDismiss:(WQInterstitialAdView*)pAdView{
      [_interstitialAdView removeFromSuperview];
    [self adapter:self didDismissScreen:nil];
}
//当要呈现 Modal View 时，回调该方法，如打开内置浏览器
-(void) wqInterstitialAdWillPresentModalView:(WQInterstitialAdView*)pAdView{
  
}
//当呈现的 Modal View 即将关闭时，回调该方法，如关闭内置浏览器
-(void) wqInterstitialAdDidDismissModalView:(WQInterstitialAdView*)pAdView{
  
}
//SDK用presentModalViewController的方式来打开广告内部的链接，这里需要返回一个view controller用作presentingViewController
-(UIViewController*) controllerForPresentingModelViewInInterstitialAdView:(WQInterstitialAdView*)pAdView{

    UIViewController *viewController = [self rootViewControllerForPresent];
    return viewController;
}
//当广告展示成功的时候，回调该方法
-(void) onInterstitialAdViewed:(WQInterstitialAdView*)pAdView{
    [self adapter:self didShowAd:nil];
}



-(void)stopBeingDelegate{
    if (_interstitialAdView) {
        _interstitialAdView.delegate=nil;
        [_interstitialAdView release],_interstitialAdView =nil;
    }
}

- (void)dealloc {
    MGLog(MGT,@"remove weiqian ad");
    if (_interstitialAdView) {
        _interstitialAdView.delegate=nil;
        [_interstitialAdView release],_interstitialAdView =nil;
    }
    [super dealloc];
}



@end
