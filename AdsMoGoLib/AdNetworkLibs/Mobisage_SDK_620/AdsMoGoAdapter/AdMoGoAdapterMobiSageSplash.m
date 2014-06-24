//
//  AdMoGoAdapterMobiSageSplash.m
//  wanghaotest
//
//  Created by mogo on 14-2-24.
//
//

#import "AdMoGoAdapterMobiSageSplash.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
@implementation AdMoGoAdapterMobiSageSplash
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMobiSage;
}

+ (void)load{
    [[AdMoGoAdSDKSplashNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isFail = NO;
    isSuccess = NO;
    
    isStop = NO;
    isLoaded = NO;
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:splashAds.config_key];
    
    AdViewType type =[configData.ad_type intValue];
    
	if (type == AdViewTypeSplash) {
        
        NSString *key = [self.ration objectForKey:@"key"];
        
        [[MobiSageManager getInstance] setPublisherID:key];
        
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            mobiSageAdSplash = [[MobiSageSplash alloc] initWithOrientation:MS_Orientation_Landscape
                background:[self getBackgroundColor]
                withDelegate:self];
        }else{
            mobiSageAdSplash = [[MobiSageSplash alloc] initWithOrientation:MS_Orientation_Portrait
                background:[self getBackgroundColor]
                withDelegate:self];
        }
        
        [mobiSageAdSplash startSplash];
        
        
        [self.splashAds adapterDidStartRequestSplashAd:self];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if (_timeInterval && [_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut12 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
    else{
        [self adFailWith:nil];
    }
}

- (void)stopBeingDelegate {
    /*2013*/
    
    
}

- (void)stopAd{
    [self stopBeingDelegate];
    [self stopTimer];
    isStop = YES;
}

- (void)dealloc {
    NSLog(@"remove ad");
    
    [super dealloc];
    
}

- (void)stopTimer {
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
    [self adFailWith:nil];
}

- (UIColor *)getBackgroundColor{
    NSString *imageName = [self.splashAds getBackgroundImageName];
    UIImage *backgroundImage = nil;
    if (imageName) {
        backgroundImage = [UIImage imageNamed:imageName];
    }
    UIColor* bgColor = [UIColor colorWithPatternImage:backgroundImage];
    return bgColor;
}

- (void)adSuccess:(id) _awSplash{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [self.splashAds adSplashSuccess:self withSplash:_awSplash];
    }
}

- (void)adFailWith:(NSError *)error{
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [self.splashAds adSplashFail:self withError:error];
    }
}

/**
 *  AdSplash展示成功
 *  @param adSplash
 */
- (void)mobiSageSplashSuccessToShow:(MobiSageSplash*)adSplash{
    [self adSuccess:adSplash];
}

/**
 *  AdSplash展示失败
 *  @param adSplash
 */
- (void)mobiSageSplashFaildToRequest:(MobiSageSplash*)adSplash{
    [mobiSageAdSplash release];
    [self adFailWith:nil];
}

/**
 *  AdSplash被点击
 *  @param adSplash
 */
- (void)mobiSageSplashClick:(MobiSageSplash*)adSplash{
    if ([self.splashAds respondsToSelector:@selector(sendClickCountWithAdAdpter:)]) {
        [self.splashAds sendClickCountWithAdAdpter:self];
    }
}

/**
 *  AdSplash被关闭
 *  @param adSplash
 */
- (void)mobiSageSplashClose:(MobiSageSplash*)adSplash{
    [self.splashAds adSplash:self didDismiss:adSplash];
}

@end
