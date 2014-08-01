//
//  AdMoGoAdapterYJFFullAds.m
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 13-4-9.
//
//

#import "AdMoGoAdapterYJFFullAds.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"


#import <Escore/YJFUserMessage.h>
#import <Escore/YJFInitServer.h>

@interface AdMoGoAdapterYJFFullAds (){

}

@end

@implementation AdMoGoAdapterYJFFullAds


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoadNetworkTypeYiJiFen;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

//+ (NSDictionary *)networkType {
//	return [self makeNetWorkType:AdMoGoadNetworkTypeYiJiFen IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

- (void)getAd {
    
    /*
        易积分的插屏不支持ios5以下系统
     */
    if ([[UIDevice currentDevice].systemVersion intValue] < 5) {
        [self adapter:self didFailAd:nil];
        return;
    }
    isStop = NO;
    isStopTimer = NO;
    isReady = NO;
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
            break;
    }
    
    
    id keys = [self.ration objectForKey:@"key"];
    if(keys && [keys isKindOfClass:[NSDictionary class]]){
        id APP_ID = [keys objectForKey:@"APP_ID"];
        if (APP_ID && [APP_ID isKindOfClass:[NSString class]]) {
            [YJFUserMessage shareInstance].yjfUserAppId = APP_ID;
        }
        id APP_KEY = [keys objectForKey:@"APP_KEY"];
        if (APP_KEY && [APP_KEY isKindOfClass:[NSString class]]) {
            [YJFUserMessage shareInstance].yjfAppKey = APP_KEY;
        }
        id DEV_ID = [keys objectForKey:@"DEV_ID"];
        if (DEV_ID && [DEV_ID isKindOfClass:[NSString class]]) {
            [YJFUserMessage shareInstance].yjfUserDevId = DEV_ID;
        }
    }
    [YJFUserMessage shareInstance].yjfChannel = @"IOS2.0";//渠道号，默认当前SDK版本号
    
    YJFInitServer *InitData = [[YJFInitServer alloc] init];
    [InitData getInitEscoreData];
    [InitData release];
    
//    YJFInterstitial *inp = [[YJFInterstitialParameter alloc]init];
//    [inp createInterstitialWithInterfaceOrientation:@"Landscape"];//0横屏  1竖屏
//    [inp release];
    
    UIInterfaceOrientation interfaceOrientation  = [[UIApplication sharedApplication] statusBarOrientation];
    UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;    
    
    CGRect rect = uiViewController.view.bounds;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {//横屏
            [[YJFInterstitial shareInstance]initWithFrame:rect andPicFrame:CGRectMake((rect.size.width-300)/2, (rect.size.height-270)/2, 300, 270) andOrientation:@"Landscape" andDelegate:self];
        }else if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {//竖屏
            [[YJFInterstitial shareInstance]initWithFrame:rect andPicFrame:CGRectMake((rect.size.width-270)/2, (rect.size.height-300)/2, 270, 300) andOrientation:@"Portrait" andDelegate:self];
        }
        [self adapterDidStartRequestAd:self];
        
    }
    else
        {
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {//横屏
            [[YJFInterstitial shareInstance]initWithFrame:rect andPicFrame:CGRectMake((rect.size.width-600)/2, (rect.size.height-540)/2, 600, 540) andOrientation:@"Landscape" andDelegate:self];
        }
        else if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {//竖屏
            [[YJFInterstitial shareInstance]initWithFrame:rect andPicFrame:CGRectMake((rect.size.width-540)/2, (rect.size.height-600)/2, 560, 600) andOrientation:@"Portrait" andDelegate:self];
            
        }
        [self adapterDidStartRequestAd:self];
        }
    
        [YJFInterstitial shareInstance].viewController = uiViewController;
        //        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut30 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }

}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}


- (void)presentInterstitial{
    [YJFInterstitial shareInstance].uiFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[YJFInterstitial shareInstance] show];
    
}

#pragma mark -YJFInterstitialDelegate

//1 插屏弹出成功  0 插屏弹出失败
-(void)openInterstitial:(int)_value{
    if (isStop) {
        return;
    }
    if (_value == 1) {
        [self adapter:self willPresent:nil];
        [self adapter:self didShowAd:nil];
    }
}

//插屏关闭
-(void)closeInterstitial{
    if (isStop) {
        return;
    }
    [self adapter:self didDismissScreen:nil];
}

//预加载失败
- (void)getInterstitialDataFail{
    MGLog(MGT,@"%s",__func__);
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}

    //预加载成功
- (void)getInterstitialDataSuccess{
    MGLog(MGT,@"%s",__func__);
    if (isStop) {
        return;
    }
    isReady = YES;
    [self stopTimer];
    
    [self adapter:self didReceiveInterstitialScreenAd:nil];
}

-(void)stopBeingDelegate{
    if (isStop) {
        return;
    }
    [self stopTimer];
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;    
}


- (void)dealloc {

    [self stopTimer];
    
    [YJFInterstitial shareInstance].delegate = nil;
    [YJFInterstitial destroyDealloc];
    
    [super dealloc];
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

/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    MGLog(MGT,@"%s",__func__);
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}


@end
