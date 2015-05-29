//
//  AdMoGoAdapterTapjoyVideo.m
//  wanghaotest
//
//  Created by Castiel Chen on 15/3/12.
//
//

#import "AdMoGoAdapterTapjoyVideo.h"
#import "AdMoGoAdapterTapjoyFullAds.h"
#import <Tapjoy/Tapjoy.h>
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"

@interface AdMoGoAdapterTapjoyVideo()<TJEventDelegate>
{
    BOOL isStop;
    BOOL isReady;
    NSTimer *timer;
    TJEvent *event;
}
@end

@implementation AdMoGoAdapterTapjoyVideo

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeTapjoy;
}

+ (void)load{
    [[AdMoGoAdAPIVideoNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isReady=NO;
    
    [self adapterDidStartRequestAd:self];
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    AdViewType type =[configData.ad_type intValue];
    
    if (type != AdViewTypeVideo) {
        MGLog(MGT,@"not video ad type");
        [self adapter:self didFailAd:nil];
        return;
    }
        id key = [self.ration objectForKey:@"key"];
        NSString *AppID = @"";
        NSString *AppSecret = @"";
        NSString * eventStr =@"";
        if ([key isKindOfClass:[NSDictionary class]]) {
            AppID  = [key objectForKey:@"appID"];
            AppSecret = [key objectForKey:@"secretKey"];
            eventStr =[key objectForKey:@"eventToken"];
        }
     
    
    NSDictionary *segmentationParams = @{@"iap" : @(YES)};
    [Tapjoy requestTapjoyConnect:AppID secretKey:AppSecret options:@{TJC_OPTION_SEGMENTATION_PARAMS: segmentationParams}];
    
    UIViewController *viewController = [self rootViewControllerForPresent];
    
    event= [TJEvent eventWithName: eventStr delegate:self];
    [event setPresentationViewController:viewController];
    [event setPreload:YES];
    [event send];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
 
}


- (void)sendEventComplete:(TJEvent*)event withContent:(BOOL)contentIsAvailable {
    NSLog(@"Tapjoy event send completed");
    
}

- (void)sendEventFail:(TJEvent*)event error:(NSError*)error {
    NSLog(@"There was a problem sending the event: %@", [error localizedDescription]);
    [self adapter:self didFailAd:nil];
}

- (void)contentWillAppear:(TJEvent*)event {
    NSLog(@"Tapjoy event content will appear");
}

- (void)contentDidAppear:(TJEvent*)event {
    NSLog(@"Tapjoy event content did appear");
}

- (void)contentWillDisappear:(TJEvent*)event {
    NSLog(@"Tapjoy event content will disappear");
    
}

- (void)contentDidDisappear:(TJEvent*)event {
    NSLog(@"Tapjoy event content did disappear");
    [self adapter:self didDismissScreen:nil];
}



- (void)contentIsReady:(TJEvent*)event withStatus:(int)status {
    //This is a good place to actually show the content
    isReady =YES;
    [self stopTimer];
    [self adapter:self didReceiveInterstitialScreenAd:nil];
}

- (void)stopBeingDelegate {
 
}

-(void)playVideoAd{
    UIViewController *viewController = [self rootViewControllerForPresent];
    [event presentContentWithViewController:viewController];
         [self adapter:self didShowAd:nil];
}


- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer =nil;
    }
}


- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}

- (void)dealloc{
    [self stopTimer];
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}


@end
