//
//  AdMoGoAdapterMiidi.m
//  TestMOGOSDKAPP
//
//  Created by 孟令之 on 13-1-11.
//
//

#import "AdMoGoAdapterMiidi.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "MiidiManager.h"

static BOOL isManagerCreate = NO;

@implementation AdMoGoAdapterMiidi
//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeMiidi IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMiidi;
}

+(void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd{
    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
	[adMoGoCore adapter:self didGetAd:@"miidi"];
    
    //    AdViewType type = adMoGoView.adType;
    AdViewType type =[configData.ad_type intValue];
    
    MiidiAdSizeIdentifier miidiSize;
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            miidiSize = MiidiAdSize320x50;
            break;
        case AdViewTypeRectangle:
            miidiSize = MiidiAdSize200x200;
            break;
        case AdViewTypeMediumBanner:
            miidiSize = MiidiAdSize460x72;
            break;
        case AdViewTypeLargeBanner:
            miidiSize = MiidiAdSize768x72;
            break;
        default:
            break;
    }
    if (!isManagerCreate) {
        [MiidiManager setAppPublisher:[[self.ration objectForKey:@"key"] objectForKey:@"appID"]  withAppSecret:[[self.ration objectForKey:@"key"] objectForKey:@"appPassword"] withTestMode:[[self.ration objectForKey:@"testmodel"] boolValue]];
        isManagerCreate = YES;
    }
    adMiidiView = [[MiidiAdView alloc]initMiidiAdViewWithContentSizeIdentifier:miidiSize delegate:self];
    
    CGRect frame1 = adMiidiView.frame;
	frame1.origin.x = 0;
	frame1.origin.y = 0;
	adMiidiView.frame = frame1;
    self.adNetworkView = adMiidiView;
    [adMiidiView requestAd];
    
    [adMiidiView release];
    
}

- (void)didReceiveAd:(MiidiAdView *)adView{
    if(isStop){
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:adView];
}

- (void)didFailReceiveAd:(MiidiAdView *)adView  error:(NSError *)error{
    if(isStop){
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:error];
}

- (void)stopBeingDelegate {
    [self stopTimer];
    if (adMiidiView) {
        adMiidiView.delegate = nil;
    }
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}
- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}


- (void)dealloc {
    isStop = YES;
	[super dealloc];
}


- (void)loadAdTimeOut:(NSTimer*)theTimer{
    
    if (isStop) {
        return;
    }
    isStop = YES;
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}
@end
