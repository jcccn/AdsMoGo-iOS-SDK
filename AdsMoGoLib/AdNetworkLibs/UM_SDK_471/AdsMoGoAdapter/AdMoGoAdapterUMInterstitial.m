//
//  AdMoGoAdapterUMInterstitial.m
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import "AdMoGoAdapterUMInterstitial.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"

@implementation AdMoGoAdapterUMInterstitial

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeUM;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}
- (void)getAd {
}

- (void)stopBeingDelegate {
    [self stopTimer];
    if (dialog.delegate) {
        dialog.delegate = nil;
    }
    
    if([dialog superview])
    {
        [dialog removeFromSuperview];
    }
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)stopAd{
    if (dialog.delegate) {
        dialog.delegate = nil;
    }
    isStop = YES;
    [self stopBeingDelegate];
}


- (void)showAlertView{
    
}


- (void)dealloc {
    [self stopTimer];
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)loadAdTimeOut:(NSTimer*)theTimer{
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    if (dialog.delegate) {
        dialog.delegate = nil;
    }
    [interstitial adapter:self didFailAd:nil];
}

- (void)presentInterstitial{
    isReady = NO;
    isSuccess = NO;
    isFail = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
    
    AdViewType type =[configData.ad_type intValue];
    UIViewController* viewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    
    switch (type) {
        case AdViewTypeFullScreen:
        case AdViewTypeiPadFullScreen:
            [interstitial adapterDidStartRequestAd:self];
            dialog = [[UMUFPDialog alloc] initWithAppkey:[[self.ration objectForKey:@"key"] objectForKey:@"ClientID"] slotId:[[self.ration objectForKey:@"key"] objectForKey:@"SlotID"] currentViewController:viewController];
            dialog.delegate =self;
            dialog.pageType = UMUFPDialogPageTypeApp;           // 内容的可选样式：webview或native，默认为webview
            // dialog.shouldShowAfterDataLoaded = NO;              // 是否在相关数据均ready后马上展示dialog，默认为数据ready后马山展示，关闭后需要手动添加
            //    dialog.shouldShowDefaultCloseBtn = NO;              // 是否显示默认的关闭按钮，默认为显示
            dialog.contentMargin = 4.0f;                        // 内容与最外层边框的margin
            [dialog showAlertView];
            id _timeInterval = [self.ration objectForKey:@"to"];
            if ([_timeInterval isKindOfClass:[NSNumber class]]) {
                timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
            }
            else{
                timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
            }
            
            break;
        default:
            break;
    }

   
}

#pragma mark delegate

//called when promoter list loaded from the server
- (void)dialog:(UMUFPDialog *)dialog didLoadDataFinish:(NSDictionary *)promoterInfo{
    NSLog(@"%s",__FUNCTION__);
    
}
//called when promoter list loaded failed for some reason, for example network problem or the promoter list is empty
- (void)dialog:(UMUFPDialog *)dialog didLoadDataFailWithError:(NSError *)error{
    if (isStop) {
        return;
    }
    [self stopTimer];
     [self isFail:error];
}
//called when shouldShowAfterDataLoaded is Closed and dialog is ready to shown
- (void)dialogReadyToShow:(UMUFPDialog *)dialog{
}
//called when will appear the 1st time, implement this mothod if you want to change animation for the dialog appear or do something else before dialog appear
- (void)dialogWillShow:(UMUFPDialog *)dialog{
    if (isStop) {
        return;
    }
    [self stopTimer];
    isReady = YES;
    [self isSuccess];
}
//called before dialog will disappear
- (void)dialogWillDisappear:(UMUFPDialog *)dialog{
    if (isStop) {
        return;
    }
     [interstitial adapter:self didDismissScreen:nil];
}

// called when dialog is clicked
- (void)didClickDialog:(UMUFPDialog *)dialog{
    [self sendAdFullClick];
}
- (void)isSuccess{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [interstitial adapter:self didReceiveInterstitialScreenAd:nil];
    }
}

- (void)isFail:(NSError *)error{
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [interstitial adapter:self didFailAd:nil];
        
    }
}


- (void)sendAdFullClick{
    if (isStop) {
        return;
    }
    [interstitial specialSendRecordNum];
}
@end
