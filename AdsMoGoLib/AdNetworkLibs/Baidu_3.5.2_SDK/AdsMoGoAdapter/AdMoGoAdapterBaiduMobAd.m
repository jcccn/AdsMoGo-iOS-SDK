//
//  File: AdMoGoAdapterBaiduMobAd.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterBaiduMobAd.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdSDKBannerNetworkRegistry.h"

#define kAdMoGoBaiduAppIDKey @"AppID"
#define kAdMoGoBaiduAppSecretKey @"AppSEC"


@implementation AdMoGoAdapterBaiduMobAd

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeBaiduMobAd;
}

+ (void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd{
    [self performSelectorOnMainThread:@selector(baidugetAd) withObject:nil waitUntilDone:NO];
}

- (void)baidugetAd{
    isStop = NO;
    [adMoGoCore adDidStartRequestAd];
    
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    isLocationOn = [configData islocationOn];
    AdViewType type = [configData.ad_type intValue];
    CGSize size = CGSizeZero;
    
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size = kBaiduAdViewBanner320x48;
            break;
        case AdViewTypeiPhoneRectangle:
            size = kBaiduAdViewSquareBanner300x250;
            break;
        case AdViewTypeMediumBanner:
            size = kBaiduAdViewBanner468x60;
            break;
        case AdViewTypeLargeBanner:
            size = kBaiduAdViewBanner728x90;
            break;
        case AdViewTypeRectangle:
            size = kBaiduAdViewSquareBanner600x500;
            break;
        default:
            [adMoGoCore adapter:self didGetAd:@"baidu"];
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    sBaiduAdview = [[BaiduMobAdView alloc] init] ;
    sBaiduAdview.hidden = YES;
    //    sBaiduAdview.autoplayEnabled = NO;
    sBaiduAdview.frame = CGRectMake(0.0,0.0,size.width,size.height);
    MGLog(AdMoGoLogTemp, @"baidu version %@",sBaiduAdview.Version);
    
    sBaiduAdview.delegate = self;
    [sBaiduAdview start];
    
    self.adNetworkView = sBaiduAdview;
    [sBaiduAdview release];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopBeingDelegate{
    BaiduMobAdView *_adView = (BaiduMobAdView *)self.adNetworkView;
	if (_adView != nil) {
        _adView.delegate = nil;
    }
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)dealloc {
    [self stopTimer];
    [super dealloc];
}

/**
 *  应用在mounion.baidu.com上的id
 */
- (NSString *)publisherId {
    id key =  [self.ration objectForKey:@"key"];
    id appID;
    NSString *appIDStr;
    if (key != nil && ([key isKindOfClass:[NSDictionary class]])) {
        appID = [key objectForKey:kAdMoGoBaiduAppIDKey];
        if (appID != nil && ([appID isKindOfClass:[NSString class]])) {
            appIDStr = [NSString stringWithString:appID];
        }
    }
    return appIDStr;
}

/**
 *  应用在mounion.baidu.com上的计费名
 */
- (NSString*) appSpec {
    id key =  [self.ration objectForKey:@"key"];
    id appSpec;
    NSString *appSpecStr;
    if (key != nil && ([key isKindOfClass:[NSDictionary class]])) {
        appSpec = [key objectForKey:kAdMoGoBaiduAppSecretKey];
        if (appSpec != nil && ([appSpec isKindOfClass:[NSString class]])) {
            appSpecStr = [NSString stringWithString:appSpec];
        }
    }
    return appSpecStr;
}

/**
 *  设置成聚合平台的渠道id
 */
- (NSString*) channelId
{
    return @"13b50d6f";
}


//-(BOOL) enableLocation {
//    return isLocationOn;
//}
- (void)stopAd{
    isStop = true;
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}
/**
 *  广告将要被载入
 */
-(void) willDisplayAd:(BaiduMobAdView*) adview {
    MGLog(MGT,@"baidu adapter is %@",self);
    [self stopTimer];
//    adview.hidden = NO;
    [adMoGoCore adapter:self didGetAd:@"baidu"];
    [adMoGoCore baiduAddAdViewAdapter:self didReceiveAdView:adview];
}




/*
    
 */
-(void) didAdImpressed {
    MGLog(MGT,@"%s",__func__);
    if (isStop) {
        return;
    }
    [adMoGoCore baiduSendRIB];
}
-(void) didAdClicked{
    MGLog(MGT,@"%s",__func__);
    
    if (isStop) {
        return;
    }
//    [adMoGoCore sendRecordNum];
    [adMoGoCore baiduSendCLK:self];
   
}

-(void) didDismissLandingPage {
    [self helperNotifyDelegateOfFullScreenModalDismissal];
}

/**
 *  广告载入失败
 */
-(void) failedDisplayAd:(BaiduMobFailReason) reason {
    MGLog(MGT,@"baidu adapter is %@",self);
    if (isStop) {
        return;
    }
    [self stopTimer];
    
    [adMoGoCore adapter:self didFailAd:nil];
}


- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}



@end