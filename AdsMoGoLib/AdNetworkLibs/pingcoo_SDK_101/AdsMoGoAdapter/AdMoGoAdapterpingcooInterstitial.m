//
//  AdMoGoAdapterIWantInterstitial.m
//  wanghaotest
//
//  Created by MOGO on 13-7-3.
//
//

#import "AdMoGoAdapterpingcooInterstitial.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"

@implementation AdMoGoAdapterpingcooInterstitial
//+ (NSDictionary *)networkType{
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeIWant IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeIWant;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isPresent = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    AdViewType type =[configData.ad_type intValue];
    
    
    //this class only have full screen type.
    if(type == AdViewTypeFullScreen || type == AdViewTypeiPadFullScreen){
        
    }else{
        [self adapter:self didFailAd:nil];
        return;
    }
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
        pingcoo.delegate = nil;
    }
    [self stopTimer];
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}


- (BOOL)ispreloadPlatform{
    return  NO;
}

- (BOOL)isReadyPresentInterstitial{
    return YES;
}

- (void)presentInterstitial{
    if (isPresent) {
        return;
    }else{
        isPresent = YES;
    }
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSString class]]) {
        pingcoo = [pingcooSDK initWithKey:key];
        pingcoo.delegate = self;
        UIViewController* viewController = [self rootViewControllerForPresent];
        if (viewController) {
            pingcoo.rootViewController = viewController;
        }
        
        [pingcoo pauseShow];
        [self adapterDidStartRequestAd:self];
//        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut30 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
    else{
        [self adapter:self didFailAd:nil];
        return ;
    }
}


//图片显示完成
-(void)show:(pingcooSDK *)show didFinishAppearWithResult:(id)result{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didReceiveInterstitialScreenAd:nil];
    [self adapter:self didShowAd:nil];
}
//错误
-(void)show:(pingcooSDK *)show didFailWithError:(NSError *)error{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}
//图片消失
-(void)show:(pingcooSDK *)show didFinishDisappearWithResult:(id)result{
    if (isStop) {
        return;
    }
    [self adapter:self didDismissScreen:nil];
}

@end
