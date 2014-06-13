//
//  AdsMoGoAdapterVpon.m
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 14-03-25.
//
//

#import "AdsMoGoAdapterVpon.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoView.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoDeviceInfoHelper.h"

@interface  AdsMoGoAdapterVpon(){
    
    VponBanner *vponAd;
}

@end

@implementation AdsMoGoAdapterVpon

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdOnCN;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    isfailed = NO;
    [adMoGoCore adapter:self didGetAd:@"vpon"];
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    VponAdSize size = VponAdSizeBanner;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = VponAdSizeBanner;
            break;
        case AdViewTypeRectangle:
            size = VponAdSizeMediumRectangle;
            break;
        case AdViewTypeMediumBanner:
            size = VponAdSizeFullBanner;
            break;
        case AdViewTypeLargeBanner:
            size = VponAdSizeLeaderboard;
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

    //init vpon
    vponAd = [[VponBanner alloc] initWithAdSize:size origin:CGPointMake(0, 0)];
    vponAd.strBannerId = [self.ration objectForKey:@"key"];;   // 填入您的BannerId
    vponAd.delegate = self;
    
    NSString *countryCode = nil;

    //如果需要自行设置vpon Platform属性 可以在 {appName}-Prefix.pch 文件中宏定义 vpon_custom_platform
    //如：#define vpon_custom_platform @"TW"
    //注：定义值为国家代码双字母简写 目前vpon只支持 CN 和 TW 的设置
    //如果不定义 则交由adsMogo® SDK根据真实环境处理
    
#ifdef vpon_custom_platform
    countryCode = vpon_custom_platform;
#else
    if ([self.ration objectForKey:@"countryCode"] != [NSNull null]) {
        countryCode = [self.ration objectForKey:@"countryCode"];
    }else{
        countryCode = @"cn";
    }
#endif
    
    //platform
    vponAd.platform = [[countryCode lowercaseString] isEqualToString:@"cn"]? CN : TW;

    //use loaction
    id islocation = [configData.config_extra objectForKey:@"location_on"];
    [vponAd setLocationOnOff:[islocation intValue]==1];
    
    //ad auto refresh
    [vponAd setAdAutoRefresh:NO];
    
    //rootViewController
    UIViewController *rootViewCon = [self.adMoGoDelegate viewControllerForPresentingModalView];
    if (rootViewCon) {
        
        if (rootViewCon.navigationController) {
            rootViewCon = rootViewCon.navigationController;
        }
        
    }else{
        
        rootViewCon = [UIApplication sharedApplication].keyWindow.rootViewController;
        
    }
    
    if (rootViewCon) {
        [vponAd setRootViewController:rootViewCon];
    }
    
    
    //start request ad
    [vponAd startGetAd:[self getTestIdentifiers]];
    
}

// 請新增此function到您的程式內 如果為測試用 則在下方填入UUID
-(NSArray*)getTestIdentifiers
{
    return [NSArray arrayWithObjects:
#if DEBUG_COMMON
            @"09E41E38-7C96-4D33-BACE-0EA56062706C",// add your test UUID
#endif
            nil];
}

- (void)stopBeingDelegate{

    if (vponAd) {
        vponAd.delegate = nil;
        [vponAd release],vponAd = nil;
    }
    
    [self stopTimer];
    
}

- (void)stopAd{
    isStop = YES;
    [self stopTimer];
}

- (void)stopTimer{
    
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        if (timer) {
            [timer invalidate];
            [timer release];
            timer = nil;
        }
        
    });
    
    
}

- (void)dealloc {
    [self stopTimer];
    [super dealloc];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    [self stopBeingDelegate];
    isfailed = YES;
    [adMoGoCore adapter:self didFailAd:nil];
}


#pragma mark -- vpon delegate

#pragma mark 通知拉取廣告成功pre-fetch完成
- (void)onVponAdReceived:(UIView *)bannerView{
    
    if(isStop || isfailed){
        return;
    }
    isfailed = NO;
    [self stopTimer];
    
    
    [adMoGoCore adapter:self didReceiveAdView:[vponAd getVponAdView]];
    
}
#pragma mark 通知拉取廣告失敗
- (void)onVponAdFailed:(UIView *)bannerView didFailToReceiveAdWithError:(NSError *)error{
    
    if(isStop || isfailed){
        return;
    }
    isfailed = YES;
    [self stopTimer];
    
    MGLog(MGD, @"vpon did fail to receice ad error-->%@",error);
    
    [adMoGoCore adapter:self didFailAd:error];
    
}

#pragma mark 通知開啟vpon廣告頁面
- (void)onVponPresent:(UIView *)bannerView{
    
    if (isStop) {
        return;
    }
    
    [adMoGoCore stopTimer];
    
}
#pragma mark 通知關閉vpon廣告頁面
- (void)onVponDismiss:(UIView *)bannerView{
    
    if (isStop) {
        return;
    }
    
    [adMoGoCore fireTimer];
    
}

//// 回傳點擊點廣是否有效
//- (void)onClickAd:(UIViewController *)bannerView withValid:(BOOL)isValid withLicenseKey:(NSString *)adLicenseKey{
//    if (isStop) {
//        return;
//    }
//}
//// 回傳Vpon廣告抓取成功
//- (void)onRecevieAd:(UIViewController *)bannerView withLicenseKey:(NSString *)licenseKey{
//    if (isStop) {
//        return;
//    }
//    if (timer) {
//        [timer invalidate];
//        [timer release];
//        timer = nil;
//    }
//    isfailed = NO;
//    [adMoGoCore adapter:self didReceiveAdView:bannerView.view];
//}
//// 回傳Vpon廣告抓取失敗
//- (void)onFailedToRecevieAd:(UIViewController *)bannerView withLicenseKey:(NSString *)licenseKey{
//    
//    if (isfailed) {
//        return;
//    }
//    if (isStop) {
//        return;
//    }
//    
//    [self stopTimer];
//    
//    [adMoGoCore adapter:self didFailAd:nil];
//    isfailed = YES;
//}

@end
