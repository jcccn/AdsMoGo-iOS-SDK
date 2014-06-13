//
//  AdMoGoAdapterIomarkBanner.m
//  wanghaotest
//
//  Created by mogo on 14-4-4.
//
//
#import "AdMoGoAdapterlomarkBanner.h"

#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdSDKBannerNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
@implementation AdMoGoAdapterlomarkBanner
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeLomark;
}

+ (void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    /*
     获取广告类型
     原来代码：AdViewType type = adMoGoView.adType;
     */
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    
    //
    //    AdViewType type = adMoGoView.adType;
    AdViewType type =[configData.ad_type intValue];
    CGSize size = CGSizeZero;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = ADSIZE_320_50;
            break;
        case AdViewTypeLargeBanner:
            size = ADSIZE_640_100;
            break;
        case AdViewTypeMediumBanner:
            size = ADSIZE_480_75;
            break;
        default:
            [adMoGoCore adapter:self didGetAd:@"iomark"];
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    NSString *appName = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleDisplayName"];
    NSString *appKey = nil;
    NSString *secretKey = nil;
    NSString *appId = [[NSBundle mainBundle] bundleIdentifier];;
    
    appKey = [[self.ration objectForKey:@"key"] objectForKey:@"appkey"];
    secretKey = [[self.ration objectForKey:@"key"] objectForKey:@"secretkey"];

    
    
    
    _bannerView = [[LomarkAdView alloc]initWithAdType:LomarkAdTypeBanner appCategory:AppOther appId:appId appKey:appKey appSecret:secretKey appName:appName size:size autoTimeInterval:15];
    _bannerView.delegate = self;
    [_bannerView loadADAutoPlay];
    
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopTimer {
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (timer) {
            [timer invalidate];
            [timer release];
            timer = nil;
        }
    });
    
}

- (void)stopBeingDelegate {
    isStop = YES;
    
    if (_bannerView && ![_bannerView isKindOfClass:[NSNull class]]) {
        
        _bannerView.delegate = nil;
        
    }

}

- (void)stopAd{
    [self stopTimer];
   
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)dealloc {
    [self stopTimer];
    if (_bannerView && ![_bannerView isKindOfClass:[NSNull class]]) {
        if ([_bannerView superview]) {
            [_bannerView removeFromSuperview];
        }
        _bannerView.delegate = nil;
        [_bannerView release];
        _bannerView = nil;
    }
    
	[super dealloc];
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
    [adMoGoCore adapter:self didReceiveAdView:view];
}

//获取到不可展示的广告数据 或者 没有获取到可展示的广告数据
- (void)adView:(UIView *)view didFailToReceiveAdWithError:(NSError *)error{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:error];
}

//广告展示被点击，将要打开广告地址
-(void)adViewDidClicked:(UIView *)view{
    
}

//视图被移除
-(void)adViewDidRemoved:(UIView *)view{
    
}

@end
