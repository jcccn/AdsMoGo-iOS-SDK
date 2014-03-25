//
//  AdsMoGoAdapterVpon.m
//  TestMOGOSDKAPP
//
//  Created by 孟令之 on 12-11-21.
//
//

#import "AdsMoGoAdapterVpon.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoView.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdsMoGoAdapterVpon

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeAdOnCN IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}

//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

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
    CGSize size = CGSizeZero;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = ADON_SIZE_320x48;
            break;
        case AdViewTypeRectangle:
            size = ADON_SIZE_320X270;
            break;
        case AdViewTypeMediumBanner:
            size = ADON_SIZE_480x72;
            break;
        case AdViewTypeLargeBanner:
            size = ADON_SIZE_700x105;
            break;
        default:
            break;
    }
    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];

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
    
    if ([[countryCode lowercaseString] isEqualToString:@"cn"]) {
        [VponAdOn initializationPlatform:CN];
    }else{
        [VponAdOn initializationPlatform:TW];
    }
    
    [[VponAdOn sharedInstance] setIsVponLogo:YES];
    id islocation = [configData.config_extra objectForKey:@"location_on"];
    
    if ([islocation isKindOfClass:[NSNumber class]]) {
        if ([islocation intValue]==1) {
            [[VponAdOn sharedInstance] setLocationOnOff:YES];
        }else{
            [[VponAdOn sharedInstance] setLocationOnOff:NO];
        }
    }else if ([islocation isKindOfClass:[NSString class]]) {
        if ([islocation intValue]==1) {
            [[VponAdOn sharedInstance] setLocationOnOff:YES];
        }else{
            [[VponAdOn sharedInstance] setLocationOnOff:NO];
        }
    }
    vponViewController = [[VponAdOn sharedInstance] adwhirlRequestDelegate:self licenseKey:[self.ration objectForKey:@"key"] size:size];
    [vponViewController.view setFrame:CGRectMake(0, 0, size.width, size.height)];
}

- (void)stopBeingDelegate{
    
    [VponAdOn sharedInstance].adOnDelegate = nil;
    [self stopTimer];
    
}

- (void)stopAd{
    isStop = YES;
    [self stopTimer];
}

- (void)stopTimer{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)dealloc {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    if (vponViewController) {
        [vponViewController release];
        vponViewController = nil;
    }
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
// 回傳點擊點廣是否有效
- (void)onClickAd:(UIViewController *)bannerView withValid:(BOOL)isValid withLicenseKey:(NSString *)adLicenseKey{
    if (isStop) {
        return;
    }
}
// 回傳Vpon廣告抓取成功
- (void)onRecevieAd:(UIViewController *)bannerView withLicenseKey:(NSString *)licenseKey{
    if (isStop) {
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    isfailed = NO;
    [adMoGoCore adapter:self didReceiveAdView:bannerView.view];
}
// 回傳Vpon廣告抓取失敗
- (void)onFailedToRecevieAd:(UIViewController *)bannerView withLicenseKey:(NSString *)licenseKey{
    
    if (isfailed) {
        return;
    }
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    [adMoGoCore adapter:self didFailAd:nil];
    isfailed = YES;
}

@end
