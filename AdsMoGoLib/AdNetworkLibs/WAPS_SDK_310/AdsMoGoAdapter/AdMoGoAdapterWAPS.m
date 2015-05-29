//
//  AdMoGoAdapterWAPS.m
//  wanghaotest
//
//  Created by MOGO on 15-4-28.
//
//

#import "AdMoGoAdapterWAPS.h"
#import "CSLib/CSConnect.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#define App_ID @"App_ID"

#define Pid @"pid"

typedef NS_ENUM(NSUInteger, CSAdContent) {
    CSAdDefault,
    CSAdRequestSuccess,
    CSAdRequestFail,
    CSAdShowSuccess,
    CSAdShowFail,
};
@interface AdMoGoAdapterWAPS(){
    CSAdContent adstatus;
    AdMoGoConfigData *configData;
    BOOL isStop;
    BOOL isStopTimer;
}
@end

@implementation AdMoGoAdapterWAPS
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeWAPS;
}

+ (void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    //指定获取连接状态的回调方法
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wapsInitSuccess:) name:CS_CONNECT_SUCCESS object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wapsInitFailed:) name:CS_CONNECT_FAILED object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBannerSuccessed:) name:CS_GET_BANNER_SUCCESS object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getBannerFailed:) name:CS_GET_BANNER_FAILED object:nil];
    
    
    isStopTimer = NO;
    isStop = NO;
    adstatus = CSAdDefault;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    
    
    NSString *appid = [[self.ration objectForKey:@"key"] objectForKey:App_ID];
    NSString *pid = [[self.ration objectForKey:@"key"] objectForKey:Pid];
    [CSConnect getConnect:appid pid:pid];
    float width = [UIScreen mainScreen].bounds.size.width;
    switch (type) {
        case AdViewTypeNormalBanner:
            if(width == 320.0f){
                [CSConnect initHFView:AD_SIZE_320X50];
            }else if(width == 375.0f){
                [CSConnect initHFView:AD_SIZE_375x65];
            }else if(width == 414.0f){
                [CSConnect initHFView:AD_SIZE_414x70];
            }else{
                [CSConnect initHFView:AD_SIZE_320X50];
            }
            
            break;
        
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }

    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}

- (void)stopBeingDelegate{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)stopAd{
    isStop = YES;
    [self stopTimer];
    [self stopBeingDelegate];
}

- (void)dealloc{
    
    [super dealloc];
}

/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    
    [adMoGoCore adapter:self didFailAd:nil];
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

#pragma mark CSNotification
- (void)wapsInitSuccess:(NSNotification*)notifyObj{
    
}

- (void)wapsInitFailed:(NSNotification*)notifyObj{
    
}

-(void)getBannerSuccessed:(NSNotification*)notifyObj{
    UIView *view = (UIView*)(notifyObj.object);
    CGRect frame = view.frame;
    frame.origin.x = 0.0;
    frame.origin.y = 0.0;
    view.frame = frame;
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:view];
}

-(void)getBannerFailed:(NSNotification*)notifyObj{
    [self stopTimer];
    MGLog(MGE, @"wap error %@",notifyObj);
    [adMoGoCore adapter:self didFailAd:nil];
}

@end
