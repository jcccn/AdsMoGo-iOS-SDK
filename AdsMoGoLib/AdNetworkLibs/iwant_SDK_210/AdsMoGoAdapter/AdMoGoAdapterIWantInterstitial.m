//
//  AdMoGoAdapterIWantInterstitial.m
//  wanghaotest
//
//  Created by MOGO on 13-7-3.
//
//

#import "AdMoGoAdapterIWantInterstitial.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"

@implementation AdMoGoAdapterIWantInterstitial
+ (NSDictionary *)networkType{
    return [self makeNetWorkType:AdMoGoAdNetworkTypeIWant IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
}

+ (void)load {
	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    AdViewType type =[configData.ad_type intValue];
    
    
    //this class only have full screen type.
    if(type == AdViewTypeFullScreen || type == AdViewTypeiPadFullScreen){
        
    }else{
        [interstitial adapter:self didFailAd:nil];
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
    [interstitial adapter:self didFailAd:nil];
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}

- (BOOL)isReadyPresentInterstitial{
    return YES;
}

- (void)presentInterstitial{
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSString class]]) {
        UIViewController* viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
        if (viewController) {
            UIInterfaceOrientation previousOrientation = [UIApplication sharedApplication].statusBarOrientation;
            UIView *backview = nil;
            if ( UIInterfaceOrientationIsLandscape(previousOrientation))
            {
                backview = [[UIView alloc] initWithFrame:CGRectMake(80, 0,320, 220)];
            }
            else {
                backview = [[UIView alloc] initWithFrame:CGRectMake(0, 0,320, 220)];
            }
            backview.autoresizesSubviews = YES;
            backview.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
            pingcoo = [pingcooSDK initWithKey:key];
            pingcoo.delegate = self;
            [viewController.view addSubview:backview];
            [backview release];
            [pingcoo popShow:backview showTime:5.0];
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut30 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }else{
            [interstitial adapter:self didFailAd:nil];
            return ;
        }
    }
    else{
        [interstitial adapter:self didFailAd:nil];
        return ;
    }
}


//图片显示完成
-(void)show:(pingcooSDK *)show didFinishAppearWithResult:(id)result{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [interstitial adapter:self didReceiveInterstitialScreenAd:nil];
}
//错误
-(void)show:(pingcooSDK *)show didFailWithError:(NSError *)error{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [interstitial adapter:self didFailAd:nil];
}
//图片消失
-(void)show:(pingcooSDK *)show didFinishDisappearWithResult:(id)result{
    if (isStop) {
        return;
    }
    [interstitial adapter:self didDismissScreen:nil];
}

@end
