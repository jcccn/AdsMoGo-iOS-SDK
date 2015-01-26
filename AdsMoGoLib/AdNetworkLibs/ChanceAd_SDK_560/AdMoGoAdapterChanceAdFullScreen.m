//
//  AdMoGoAdapterPuchBoxFullScreen.m
//  wanghaotest
//
//  Created by MOGO on 13-9-28.
//
//

#import "CSInterstitialSingleton.h"
#import "AdMoGoAdapterChanceAdFullScreen.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@interface AdMoGoAdapterChanceAdFullScreen ()<CSInterstitialSingletonDelegate>{
    
    CSInterstitialSingleton *csSingleton;
    
}

@property (nonatomic, retain) CSInterstitial *pbInterstitial;

@end

@implementation AdMoGoAdapterChanceAdFullScreen

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
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
    AdViewType type =[configData.ad_type intValue];
    
    
    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
            break;
        default:
            [self adapter:self didFailAd:nil];
            return;
    }
    
    NSString *mPunchBoxID = nil;
    NSString *mAdMobiID = nil;
    NSString *mPlacementID = nil;
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSDictionary class]]) {
        mPunchBoxID = [key objectForKey:@"mPunchBoxID"];
        mAdMobiID = [key objectForKey:@"mAdMobiID"];
        mPlacementID = [key objectForKey:@"placementID"];
    }else{
        [self adapter:self didFailAd:nil];
        return;
    }
    
    csSingleton = [CSInterstitialSingleton shareInstanceWithPID:mPunchBoxID];

    [csSingleton initInterstitialWithPlaceId:mPlacementID];

    [self adapterDidStartRequestAd:self];

    if (csSingleton.isReady) {

        csSingleton.delegate = self;
        isReady = YES;
        [self adapter:self didReceiveInterstitialScreenAd:nil];
    }else if(csSingleton.isError){
        
        [self adapter:self didFailAd:nil];
        
    }else{

        csSingleton.delegate = self;
        
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        
    }
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
//    self.pbInterstitial.delegate = nil;
//    self.pbInterstitial = nil;
    
    if (csSingleton.delegate == self) {
        csSingleton.delegate = nil;
    }
    
    [self stopTimer];
}
- (void)dealloc {
    MGLog(MGT, @"%s",__func__);
    
    if (csSingleton.delegate == self) {
        csSingleton.delegate = nil;
    }
    
    [super dealloc];
}

- (void)interstitalFail{
    if (!isFail&&!isClosed) {
        isFail = YES;
        [self adapter:self didFailAd:nil];
    }
}


- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    [csSingleton showInterstitialWithScale:0.9f];
}


- (UIViewController *)puchBoxBaseViewController{
    
    UIViewController *viewController=[UIApplication sharedApplication].keyWindow.rootViewController;
    if (!viewController ) {
        viewController = [self rootViewControllerForPresent];

    }
    return viewController;
}


#pragma mark -
#pragma mark CSInterstitialSingletonDelegate method

// 弹出广告加载完成
- (void)csInterstitialDidLoadAd:(CSInterstitial *)pbInterstitial{
    if (isReady) {
        return;
    }
    isReady = YES;
    [self stopTimer];
    if (!isClosed) {
        [self adapter:self didReceiveInterstitialScreenAd:nil];
    }
}

// 弹出广告加载错误
- (void)csInterstitial:(CSInterstitial *)pbInterstitial
loadAdFailureWithError:(CSRequestError *)requestError{
    
    if (isFail) {
        return;
    }
    
    [self stopTimer];
    [self interstitalFail];
}

// 弹出广告打开完成
- (void)csInterstitialDidPresentScreen:(CSInterstitial *)csInterstitial{
    [self adapter:self didShowAd:csInterstitial];
}

// 弹出广告将要关闭
- (void)csInterstitialWillDismissScreen:(CSInterstitial *)csInterstitial{

}

// 弹出广告关闭完成
- (void)csInterstitialDidDismissScreen:(CSInterstitial *)csInterstitial{
    if (!isClosed) {
        isClosed = YES;
        [self performSelectorOnMainThread:@selector(dismissInterstitial:) withObject:csInterstitial waitUntilDone:NO];
    }
    
}

- (void)dismissInterstitial:(CSInterstitial *)csInterstitial{
    [self adapter:self didDismissScreen:csInterstitial];
}
@end
