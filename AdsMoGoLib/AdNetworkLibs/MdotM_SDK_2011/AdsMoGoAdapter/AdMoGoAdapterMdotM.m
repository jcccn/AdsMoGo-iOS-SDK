

#import "AdMoGoAdapterMdotM.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "MdotMAdSizes.h"

@interface AdMoGoAdapterMdotM ()

@end

@implementation AdMoGoAdapterMdotM

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeMdotM IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMdotM;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    [adMoGoCore adDidStartRequestAd];
    [adMoGoCore adapter:self didGetAd:@"MdotM"];
    
    //init AdView size
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type = [configData.ad_type intValue];
    CGSize size = CGSizeZero;
    switch (type) {
        case AdViewTypeNormalBanner:
            size = BANNER_320_50;
            break;
        case AdViewTypeiPadNormalBanner:
            size = BANNER_320_50;
            break;
        case AdViewTypeRectangle:
            size = BANNER_300_250;
            break;
        case AdViewTypeLargeBanner:
            size = BANNER_728_90;
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    //init AdView
    adView = [[MdotMAdView alloc]init];
    [adView setFrame:CGRectMake(0, 0, size.width, size.height)];
    [adView setAdRefreshInterval:0];
    
    //init MdotMRequestParameters
    if (!requestParameters) {
        requestParameters = [[MdotMRequestParameters alloc]init];
    }
    
    //set appKey and test or not
    requestParameters.appKey = [self.ration objectForKey:@"key"];
    requestParameters.test  = [self.ration objectForKey:@"testmodel"];
    
    //set delegate and load content
    adView.adViewDelegate = self;
    [adView loadBannerAd:requestParameters withSize:size];
    self.adNetworkView = adView;
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

-(void)stopAd{
    isStop = YES;
    
    [self stopBeingDelegate];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)stopBeingDelegate {
    if (self.adNetworkView != nil) {
        ((MdotMAdView *)self.adNetworkView).adViewDelegate = nil;
        self.adNetworkView = nil;
    }
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
    
    [self stopTimer];
    [self stopBeingDelegate];
    [adMoGoCore adapter:self didFailAd:nil];
}

#pragma mark-
#pragma  mark MdotM delegate methods
-(void) onReceiveBannerAd{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
}
-(void) onReceiveBannerAdError:(NSString *)error{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:[NSError errorWithDomain:@"MdotM" code:1000 userInfo:[NSDictionary dictionaryWithObjectsAndKeys:@"error",error,nil]]];

}
-(void) onReceiveClickInBannerAd{}
-(void) willLeaveApplication{}

@end