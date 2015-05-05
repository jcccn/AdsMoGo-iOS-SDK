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
#import <Eadver/HMUserMessage.h>
#import <Eadver/HMInitServer.h>
BOOL static isinit = NO;
@interface AdMoGoAdapterYJFFullAds ()<InitResultDelegate>{
    HMInitServer *InitData;
}

@end

@implementation AdMoGoAdapterYJFFullAds


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoadNetworkTypeYiJiFen;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

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
            [HMUserMessage shareInstance].hmUserAppId = APP_ID;
            //[HMUserMessage shareInstance].hmUserAppId =@"200";
        }
        id APP_KEY = [keys objectForKey:@"APP_KEY"];
        if (APP_KEY && [APP_KEY isKindOfClass:[NSString class]]) {
            [HMUserMessage shareInstance].hmAppKey = APP_KEY;
            //[HMUserMessage shareInstance].hmAppKey =@"EMPAN4GE2U3YCD866XI30RDH3S0XBIP8NB";
        }
        id DEV_ID = [keys objectForKey:@"DEV_ID"];
        if (DEV_ID && [DEV_ID isKindOfClass:[NSString class]]) {
            [HMUserMessage shareInstance].hmUserDevId = DEV_ID;
            //[HMUserMessage shareInstance].hmUserDevId =@"27";
        }
    }
    [HMUserMessage shareInstance].hmChannel = @"IOS3.0";//渠道号，默认当前SDK版本号
    [HMUserMessage shareInstance].hmCoop_info =@"coopInfo";//此参数是服务器端回调必须使用的参数。值为用户id（用户指的是开发者app的用户），默认是coopinfo
    

    UIViewController *uiViewController = [self getRootViewController];
    CGRect rect = uiViewController.view.bounds;
    UIInterfaceOrientation interfaceOrientation  = [[UIApplication sharedApplication] statusBarOrientation];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone){
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) { //横屏
            CGRect picRect = [self centerRectWithSize:CGSizeMake(300, 270)];
            [[HMInterstitial shareInstance]initWithFrame:rect  andDelegate:self];
        }
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {//竖屏
            
            CGRect picRect = [self centerRectWithSize:CGSizeMake(270, 300)];
            [[HMInterstitial shareInstance]initWithFrame:rect  andDelegate:self];
        }
    }
    else
    {
        if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {//横屏
            CGRect picRect = [self centerRectWithSize:CGSizeMake(600, 540)];
            [[HMInterstitial shareInstance]initWithFrame:rect  andDelegate:self];
            
        }
        if (UIInterfaceOrientationIsPortrait(interfaceOrientation)) {//竖屏
            CGRect picRect = [self centerRectWithSize:CGSizeMake(540, 600)];
            [[HMInterstitial shareInstance]initWithFrame:rect andDelegate:self];
        }
    }
    
    [HMInterstitial shareInstance].viewController = uiViewController;

    if (!isinit) {
        isinit = YES;
        InitData = [[HMInitServer alloc]init];
        [InitData  getInitEscoreData:self];
    }
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (UIViewController *)getRootViewController
{
    UIViewController *uiViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return uiViewController;
}

- (CGRect)centerRectWithSize:(CGSize)size
{
    UIViewController *uiViewController = [self getRootViewController];
    CGRect rect = uiViewController.view.bounds;
    NSInteger height = size.height;
    NSInteger width = size.width;
    NSInteger originX = (rect.size.width - width)/2;
    NSInteger originY = (rect.size.height - height)/2;
    return CGRectMake(originX, originY, width, height);
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    [HMInterstitial shareInstance].uiFrame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    [[HMInterstitial shareInstance] show];
}

#pragma mark -YJFInterstitialDelegate
-(void)initSuccess{

}
-(void)initFailed{

}
//1 插屏弹出成功  0 插屏弹出失败
-(void)openInterstitial:(int)_value{
    if (isStop) {
        return;
    }
    if (_value == 1) {
        MGLog(MGD,@"弹出易积分插屏成功");
        [self adapter:self willPresent:nil];
        [self adapter:self didShowAd:nil];
    }else{
        MGLog(MGD,@"弹出易积分插屏失败");
    }
}

//插屏关闭
-(void)closeInterstitial{
    if (isStop) {
        return;
    }
    MGLog(MGD,@"关闭易积分插屏");
    [self adapter:self didDismissScreen:nil];
}

//预加载失败
- (void)getInterstitialDataFail{
    MGLog(MGD,@"预加载易积分插屏数据失败");
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}

//预加载成功
- (void)getInterstitialDataSuccess{
    MGLog(MGD,@"预加载易积分插屏数据成功");
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
    [HMInterstitial shareInstance].delegate = nil;
    [HMInterstitial destroyDealloc];
    
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

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    MGLog(MGD,@"易积分插屏请求超时");
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

@end
