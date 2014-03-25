//
//  AdMoGoAdapterIWant.m
//  wanghaotest
//
//  Created by MOGO on 13-6-24.
//
//

#import "AdMoGoAdapterpingcoo.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"

#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"


@implementation AdMoGoAdapterpingcoo
//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeIWant IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeIWant;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    AdViewType type =[configData.ad_type intValue];
     CGSize size =CGSizeMake(0, 0);
    switch (type) {
        case AdViewTypeNormalBanner:
        case AdViewTypeiPadNormalBanner:
            size =CGSizeMake(320, 50);
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return ;
            break;
    }
    pingcoo = nil;
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSString class]]) {
        pingcoo = [pingcooSDK initWithKey:key];
        pingcoo.delegate = self;
        pingcoo.rootViewController = [adMoGoDelegate viewControllerForPresentingModalView];
        UIView *backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,size.width, size.height)];
        
        self.adNetworkView = backview;
        [backview release];
        pingcoo.customView = backview;
        [pingcoo bannerCustom];
        
//        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
    else{
        [adMoGoCore adapter:self didFailAd:nil];
        return ;
    }   
}

- (void)dealloc {
	[super dealloc];
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)stopBeingDelegate {
    if (pingcoo) {
        pingcoo.customView = nil;
        pingcoo.delegate = nil;
    }
    [self stopTimer];
    
   
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    
    [self stopBeingDelegate];
    
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}

//图片显示完成
-(void)show:(pingcooSDK *)show didFinishAppearWithResult:(id)result{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:pingcoo.customView];
}
//错误
-(void)show:(pingcooSDK *)show didFailWithError:(NSError *)error{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:error];
}
//图片消失
-(void)show:(pingcooSDK *)show didFinishDisappearWithResult:(id)result{
    if (isStop) {
        return;
    }
}

@end
