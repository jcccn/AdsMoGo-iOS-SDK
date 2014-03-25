//
//  AdMoGoAdapterWAPS.m
//  MoGoSample_iPhone
//
//  Created by MOGO on 13-5-8.
//
//

#define App_ID @"App_ID"

#define Pid @"pid"

#import "AdMoGoAdapterWAPS.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "WapsOffer/AppConnect.h"



@implementation AdMoGoAdapterWAPS
//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeWAPS IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeWAPS;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    AdViewType type =[configData.ad_type intValue];
    
    [WapsLog setLogThreshold:LOG_DEBUG]; //开启后台打印调试信息
    
	if (type == AdViewTypeNormalBanner ||
        type == AdViewTypeiPadNormalBanner) {
       
        NSString *appid = [[self.ration objectForKey:@"key"] objectForKey:App_ID];
        NSString *pid = [[self.ration objectForKey:@"key"] objectForKey:Pid];
        [AppConnect getConnect:appid pid:pid];
        viewController = [[UIViewController alloc] init];
        viewController.view.backgroundColor = [UIColor redColor];
        [AppConnect displayAd:viewController showX:0 showY:-20];
        CGRect frame = viewController.view.frame;
        frame.size.width = 320.0;
        frame.size.height = 50.0;
        viewController.view.frame = frame;
    }
    

//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];

    //指定获取连接状态的回调方法
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wapsSuccess:) name:WAPS_CONNECT_SUCCESS object:nil];
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(wapsFailed:) name:WAPS_CONNECT_FAILED object:nil];
}

- (void)stopAd{
    [self stopTimer];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)stopBeingDelegate {

}

- (void)dealloc{
    [super dealloc];
}

#pragma mark TimerOut
/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)wapsSuccess:(NSNotification*)notifyObj{
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:viewController.view];
}

- (void)wapsFailed:(NSNotification*)notifyObj{
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:nil];
}

@end
