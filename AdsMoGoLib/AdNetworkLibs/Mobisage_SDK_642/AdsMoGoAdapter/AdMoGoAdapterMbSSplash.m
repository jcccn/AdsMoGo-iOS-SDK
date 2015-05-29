//
//  AdMoGoAdapterMobiSageSplash.m
//  wanghaotest
//
//  Created by mogo on 14-2-24.
//
//

#import "AdMoGoAdapterMbSSplash.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
@implementation AdMoGoAdapterMbSSplash
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMbS;
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
    
    [[MobiSageManager getInstance] setPublisherID:[[self.ration objectForKey:@"key"] objectForKey:@"PublisherID"] auditFlag:nil];
    
    AdViewType type =[configData.ad_type intValue];
	if (type == AdViewTypeSplash) {
        
        
        if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
                mobiSageAdSplash = [[MobiSageRTSplash alloc] initWithOrientation:MS_Orientation_Landscape
                                                                    background:[self getBackgroundColor] withDelegate:self
                                                                     slotToken:[[self.ration objectForKey:@"key"] objectForKey:@"slotToken"]];
            }else{
                [self adFailWith:nil];
            }

        }else{
            mobiSageAdSplash = [[MobiSageRTSplash alloc] initWithOrientation:MS_Orientation_Portrait
                                                                background:[self getBackgroundColor] withDelegate:self
                                                                 slotToken:[[self.ration objectForKey:@"key"] objectForKey:@"slotToken"]];
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
    mobiSageAdSplash.delegate = nil;
    [mobiSageAdSplash release], mobiSageAdSplash = nil;
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

#pragma mark - MobiSageSplashDelegate

//开屏广告展示成功时,回调此方法
- (void)mobiSageSplashSuccessToShow:(MobiSageSplash *)adSplash{
    MGLog(MGD, @"艾德思奇开屏广告展示成功");
    [self adSuccess:adSplash];
}

//开屏广告展示失败时,回调此方法,在此回调方法中,需释放广告,且在此时弹出应用的界面
- (void)mobiSageSplashFaildToRequest:(MobiSageSplash *)adSplash withError:(NSError *)error{
    MGLog(MGE, @"艾德思奇开屏广告展示失败 %@",error);
    [self adFailWith:error];
}

//开屏广告关闭时,回调此方法,需释放广告,且在此时弹出应用的界面
- (void)mobiSageSplashClose:(MobiSageSplash*)adSplash{
    MGLog(MGD, @"艾德思奇开屏广告展示被关闭");
    [self.splashAds adSplash:self didDismiss:adSplash];
}

@end
