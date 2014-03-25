//
//  AdMoGoAdapterAdFractalFullScreenSDK.m
//  TestMOGOSDKAPP
//
//  Created by hao wang on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdapterAdFractalFullScreenSDK.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h" 

#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "FtadSdk.h"

@implementation AdMoGoAdapterAdFractalFullScreenSDK

//+ (NSDictionary *)networkType{
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeAdFractal IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAdFractal;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    
    [adMoGoCore adapter:self didGetAd:@"FractalSDK"];
    [adMoGoCore adDidStartRequestAd];
    

//    
    [FtadSdk setNeedFullScreenStartView:YES];
    [FtadSdk setFtadFullScrrenAdStatusDelegate:self];
    manager=[[FtadManager alloc] init];
    [manager setPublisherid:[self.ration objectForKey:@"key"]];
    [manager start];
//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut60 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
    fullScreenView=[FtadFullScreenStartView newAndShowFtadFullScreenStartViewInView:[adMoGoDelegate viewControllerForPresentingModalView].view adIdentify:@"fullScreen" delegate:nil];
    
//    self.adNetworkView = fullScreenView;
    
}

- (void)stopAd{
    
    isStop = YES;
}

- (void)stopBeingDelegate{
    [FtadSdk setFtadFullScrrenAdStatusDelegate:nil];
    if(fullScreenView != nil) {
        fullScreenView.adstatus = nil;
    }
}

- (void)dealloc {
    [self stopTimer];
    [manager stop];
    [manager release];
    manager  = nil;
    [FtadSdk releaseSdkConfig];
    [super dealloc];
}

-(void)didFtadReceiveAdFail:(NSString*)adIdentify{
    if(isStop){
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:nil];
}
//
//
-(void)didFtadReceiveAdSuccess:(NSString*)adIdentify{
    if(isStop){
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didReceiveAdView:nil];
}
//
//
-(void)didFtadRefreshAd:(NSString*)adIdentify{
    
}
//
//
-(void)didFtadClick:(NSString*)adIdentify{

}
//
//
-(void)willFtadViewClosed:(NSString*)adIdentify{
    
}
//
//
-(void)willFtadFullScreenShow:(NSString*)adIdentify{
    
}
//
//
-(void)didFtadFullScreenShow:(NSString*)adIdentify{
    
}

//
//
-(void)willFtadFullScreenClose:(NSString*)adIdentify{
    
}
//
//
-(void)didFtadFullScreenClose:(NSString*)adIdentify{
    
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
- (void) stopTimer{
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}
@end
