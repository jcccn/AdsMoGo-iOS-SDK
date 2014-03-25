//
//  AdMoGoAdapterPuchBoxFullScreen.m
//  wanghaotest
//
//  Created by MOGO on 13-9-28.
//
//

#import "AdMoGoAdapterPuchBoxFullScreen.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@interface AdMoGoAdapterPuchBoxFullScreen ()

@property (nonatomic, retain) PBInterstitial *pbInterstitial;

@end

@implementation AdMoGoAdapterPuchBoxFullScreen

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypePuchBox;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isReady = NO;
    isFail = NO;
    isClosed = NO;
    NSLog(@"%s,%@",__func__,self);
}

- (void)loadAdTimeOut:(NSTimer*)theTimer{
    [self stopTimer];
    [self interstitalFail];
}

- (void)stopBeingDelegate {
    [self stopTimer];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)stopAd{
    self.pbInterstitial.delegate = nil;
    self.pbInterstitial = nil;
    [self stopTimer];
}
- (void)dealloc {
    MGLog(MGT, @"%s",__func__);
    NSLog(@"%s,%@",__func__,self);
    
    
    [super dealloc];
}

- (void)interstitalFail{
    if (!isFail&&!isClosed) {
        isFail = YES;
        [interstitial adapter:self didFailAd:nil];
    }
}


- (BOOL)isReadyPresentInterstitial{
    return YES;
}

- (void)presentInterstitial{
    NSLog(@"%s",__func__);
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    
    AdViewType type =[configData.ad_type intValue];
    
    
    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
            break;
        default:
            [interstitial adapter:self didFailAd:nil];
            return;
    }
    
    NSString *mPunchBoxID = nil;
    NSString *mAdMobiID = nil;
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSDictionary class]]) {
        mPunchBoxID = [key objectForKey:@"mPunchBoxID"];
        mAdMobiID = [key objectForKey:@"mAdMobiID"];
    }else{
        [interstitial adapter:self didFailAd:nil];
        return;
    }
    
    
    [PunchBoxAd startSession:mPunchBoxID];
    if (nil == self.pbInterstitial) {
        PBInterstitial *pbInterstitial = [[PBInterstitial alloc] init];
        self.pbInterstitial = pbInterstitial;
        self.pbInterstitial.delegate = self;
        [pbInterstitial release];
    }
    [self.pbInterstitial loadInterstitial:[PBADRequest requestWithOrientationSupported:PBOrientationSupported_Auto]];


    self.pbInterstitial.orientationSupported = PBOrientationSupported_Auto;
    self.pbInterstitial.delegate = self;
    BOOL showstatus=[self.pbInterstitial showInterstitialWithScale:0.9f];
    UIViewController* viewController = [self puchBoxBaseViewController];
    
    if (!showstatus) {
        [self.pbInterstitial showInterstitialOnRootView:viewController.view withScale:0.9f];
    }
    
    
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
    [interstitial adapterDidStartRequestAd:self];
}


- (UIViewController *)puchBoxBaseViewController{
    
    UIViewController *viewController=[UIApplication sharedApplication].keyWindow.rootViewController;
    if (!viewController ) {
        viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];

    }
    return viewController;
}


// 弹出广告加载完成
- (void)pbInterstitialDidLoadAd:(PBInterstitial *)pbInterstitial{
    
}

// 弹出广告加载错误
- (void)pbInterstitial:(PBInterstitial *)pbInterstitial
loadAdFailureWithError:(PBRequestError *)requestError{

    [self stopTimer];
    [self interstitalFail];
}

// 弹出广告打开完成
- (void)pbInterstitialDidPresentScreen:(PBInterstitial *)pbInterstitial{
    isReady = YES;
    [self stopTimer];
    if (!isClosed) {
        [interstitial adapter:self didReceiveInterstitialScreenAd:nil];
    }
}

// 弹出广告将要关闭
- (void)pbInterstitialWillDismissScreen:(PBInterstitial *)pbInterstitial{

}

// 弹出广告关闭完成
- (void)pbInterstitialDidDismissScreen:(PBInterstitial *)pbInterstitial{
    if (!isClosed) {
        isClosed = YES;
        [self performSelectorOnMainThread:@selector(dismissInterstitial:) withObject:pbInterstitial waitUntilDone:NO];
    }
    
}

- (void)dismissInterstitial:(PBInterstitial *)pbInterstitial{
    [interstitial adapter:self didDismissScreen:pbInterstitial];
}
@end
