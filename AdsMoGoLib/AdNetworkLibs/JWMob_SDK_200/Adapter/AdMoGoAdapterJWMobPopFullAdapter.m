//
//  AdMoGoAdapterJWMobPopFullAdapter.m
//  wanghaotest
//
//  Created by MOGO on 15-4-24.
//
//

#import "AdMoGoAdapterJWMobPopFullAdapter.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "JWMobSingleton.h"
@interface AdMoGoAdapterJWMobPopFullAdapter()<JWMobSingletonDelegate>{
    BOOL isStop;
    BOOL isRequest;
    BOOL isStopTimer;
    BOOL isready;
    NSTimer *timer;
    JWMobSingleton *jwmobsingleton;
}
@end
@implementation AdMoGoAdapterJWMobPopFullAdapter
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeJWMob;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    isRequest = NO;
    isStopTimer = NO;
    isready = NO;
    //获取用于展示插屏的UIViewController
    
    UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    if(!uiViewController){
        uiViewController = [self rootViewControllerForPresent];
    }
    
    if(uiViewController){
        id key = [self.ration objectForKey:@"key"];
        if ([key isKindOfClass:[NSString class]]) {
            
            id _timeInterval = [self.ration objectForKey:@"to"];
            if ([_timeInterval isKindOfClass:[NSNumber class]]) {
                timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
            }
            else{
                timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
            }
            
            NSString *idstr = (NSString *)key;
            jwmobsingleton = [JWMobSingleton shareInstance];
            jwmobsingleton.delegate = self;
            [jwmobsingleton setJWinitByID:idstr];
            
            [jwmobsingleton loadAd];
            [self adapterDidStartRequestAd:self];
            
            
        }else{
            [self adapter:self didFailAd:nil];
        }
        
    }
    else{
        [self adapter:self didFailAd:nil];
    }
    
}

-(void)stopBeingDelegate{
    
}

- (void)stopAd{
    jwmobsingleton.delegate = nil;
    isStop = YES;
}

- (void)dealloc {
    [self stopTimer];
    jwmobsingleton.delegate = nil;
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isready;
}

- (void)presentInterstitial{
    [jwmobsingleton showAd];
}

- (void)stopTimer {
    if (!isStopTimer) {
        isStopTimer = YES;
    }else{
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

#pragma mark JWMobSingletonDelegate Delegate

- (void)requestAdSuccess{
    MGLog(MGT, @"jwmob requestAdSuccess");
    
    isready = YES;
    if (isStop) {
        return;
    }
    [self stopTimer];
    
    [self adapter:self didReceiveInterstitialScreenAd:nil];
}
- (void)requestAdFail{
    MGLog(MGT, @"jwmob requestAdFail");
    
    if(isStop){
        return;
    }
    
    [self stopTimer];
    if (!isRequest) {
        isRequest = YES;
    }else{
        return;
    }
    MGLog(MGE,@"jwmob error");
    [self adapter:self didFailAd:nil];
}
- (void)loadAdSuccess{
    MGLog(MGT, @"jwmob loadAdSuccess");
    [self adapter:self willPresent:nil];
    [self adapter:self didShowAd:nil];
}
- (void)loadAdFail{
    MGLog(MGT, @"jwmob loadAdFail");
}
- (void)adClose{
    MGLog(MGP, @"adclose jwmob dismiss");
    [self adapter:self didDismissScreen:nil];
}


@end
