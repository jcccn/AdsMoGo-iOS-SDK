//
//  AdMoGoAdapterAduu.m
//  wanghaotest
//
//  Created by mogo_wenyand on 13-7-3.
//
//

#import "AdMoGoAdapterAduu.h"
//#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
static BOOL isLoadedAduuConfig = NO;
@implementation AdMoGoAdapterAduu
//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeAduu IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAduu;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}


- (void)getAd {
    isRevice = NO;
    isStopTimer = NO;
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    AdViewType type =[configData.ad_type intValue];
    AduuBannerContentSizeIdentifier yYAdBannerContentSizeIdentifierSize;
    CGSize size =CGSizeZero;
    switch (type) {
        case AdViewTypeNormalBanner:
            size = CGSizeMake(320, 50);
            yYAdBannerContentSizeIdentifierSize = AduuBannerContentSizeIdentifier320x50;
            break;
        case AdViewTypeLargeBanner:
            size = CGSizeMake(728, 90);
            yYAdBannerContentSizeIdentifierSize = AduuBannerContentSizeIdentifier728x90;
            break;
        default:
            [self stopBeingDelegate];
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    if (!isLoadedAduuConfig) {
        isLoadedAduuConfig = YES;
        NSString *appID = [[self.ration objectForKey:@"key"] objectForKey:@"appid"];
        NSString *appsecret = [[self.ration objectForKey:@"key"] objectForKey:@"appsecret"];
        [AduuConfig launchWithAppID:appID appSecret:appsecret channelID:@"62"];

    }
    
    banner  = [[AduuView alloc] initWithContentSizeIdentifier:yYAdBannerContentSizeIdentifierSize delegate:self];
    banner.frame = CGRectMake(0, 0, size.width, size.height);
    banner.updateTime = 10000;
    self.adNetworkView = banner;
    
    [banner release];
    [banner start];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}

- (void)stopBeingDelegate {
    [self stopTimer];
    AduuView *aduuview = (AduuView *)self.adNetworkView;
    if(aduuview){
        [aduuview stop];
        [self.adNetworkView removeFromSuperview];
        self.adNetworkView = nil;
    }
    
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

- (void)stopAd{
    [self stopBeingDelegate];
}

- (void)dealloc {
    [self stopTimer];
    
    [super dealloc];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    
    [super loadAdTimeOut:theTimer];
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    /*******/
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}
- (void)didReceiveAd:(AduuView *)adView
{
    if (!isRevice) {
        isRevice = YES;
        [self stopTimer];
        [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
    }
}
-(void)didFailToReceiveAd:(AduuView *)adView error:(NSError *)error
{
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:nil];
}
@end
