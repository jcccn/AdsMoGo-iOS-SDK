//
//  AdMoGoAdapterVungleVideoAd.m
//  TestMOGOSDKAPI
//
//  Created by Daxiong on 13-8-8.
//  Copyright (c) 2013年 Daxiong. All rights reserved.
//
#import "vunglepub.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdapterVungleVideoAd.h"

@interface AdMoGoAdapterVungleVideoAd ()<VGVunglePubDelegate>{
    
    BOOL isStop;
    BOOL isReady;
    UIViewController *_viewController;
    NSTimer *timer;
}
@end

@implementation AdMoGoAdapterVungleVideoAd
//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeVungle IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES isVideo:YES];
//}

//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeVungle;
}

+ (void)load {
	[[AdMoGoAdSDKVideoNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    isReady = NO;
    [adMoGoCore adDidStartRequestAd];
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    AdViewType type =[configData.ad_type intValue];
    if (type != AdViewTypeVideo) {
        MGLog(MGT,@"not video ad type");
        [self adapter:self didFailAd:nil];
        return;
    }
    _viewController = [self rootViewControllerForPresent];
    VGUserData*  data  = [VGUserData defaultUserData];
    NSString*    appID = [self.ration objectForKey:@"key"];
    
    // set up config data
    data.age             = [self getUserAge];
    data.gender          = [self getGender];
    data.adOrientation   = [self getOri];
    data.locationEnabled = TRUE;
    [VGVunglePub allowAutoRotate:YES];
    // start vungle publisher library
    if ([VGVunglePub running]) {
        [VGVunglePub stop];
    }
    [VGVunglePub startWithPubAppID:appID userData:data];
    [VGVunglePub setDelegate:self];
    [self adapterDidStartRequestAd:self];

//    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut60
//                                              target:self
//                                            selector:@selector(loadAdTimeOut:)
//                                            userInfo:nil
//                                             repeats:NO] retain];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopBeingDelegate{
    [self stopTimer];
    id delegate = [VGVunglePub delegate];
    if (delegate && [delegate isKindOfClass:[AdMoGoAdNetworkAdapter class]]) {
        if (delegate == self) {
            [VGVunglePub setDelegate:nil];
        }
    }
    
//    [VGVunglePub stop];
    
}

- (void)stopAd{
    isStop = YES;
    [self stopBeingDelegate];
}
- (BOOL)isReadyPresentInterstitial{
    return isReady;
}
-(void)playVideoAd{

    if ([VGVunglePub adIsAvailable] && _viewController && isReady){
        [self adapter:self willPresent:nil];
        [VGVunglePub playModalAd:_viewController animated:YES];
//        if ([interstitial respondsToSelector:@selector(adsMoGoDidPlayVideoAd:)]) {
//            [interstitial performSelector:@selector(adsMoGoDidPlayVideoAd:) withObject:nil];
//        }
    }
    else {
        MGLog(MGT,@"Ad Not Yet Available or no view controller to show");
    }
}
#pragma mark -
#pragma mark VGVunglePubDelegate
-(void)vungleMoviePlayed:(VGPlayData*)playData{
    if (isStop) {
        return;
    }

    
}
-(void)vungleStatusUpdate:(VGStatusData*)statusData{
    if (isStop) {
        return;
    }
    switch (statusData.status) {
        case VGStatusOkay:
            
            MGLog(MGT,@"isReady-->%d isAvailable-->%d",isReady,[VGVunglePub adIsAvailable]);
            
            if (isReady || ![VGVunglePub adIsAvailable]) {
                return;
            }
            isReady = YES;
            [self stopTimer];
            [self adapter:self didReceiveInterstitialScreenAd:nil];
//            if ([interstitial respondsToSelector:@selector(adsMoGoDidLoadVideoAd:)]) {
//                [interstitial performSelector:@selector(adsMoGoDidLoadVideoAd:) withObject:nil];
//            }
            break;
        case VGStatusNetworkError:
        case VGStatusDiskError:
            [self stopTimer];
            [self adapter:self didFailAd:nil];
            break;
        default:
            break;
    }
}
-(void)vungleViewDidDisappear:(UIViewController*)viewController{
    if (isStop) {
        return;
    }
//    [self adapterAdModal:self didDismissScreen:nil];
    
    
    [self adapter:self didDismissScreen:nil];
//    if ([interstitial respondsToSelector:@selector(adsMoGoFinishVideoAd:)]) {
//        [interstitial performSelector:@selector(adsMoGoFinishVideoAd:) withObject:nil];
//    }
}
-(void)vungleViewWillAppear:(UIViewController*)viewController{
    if (isStop) {
        return;
    }
    [self adapterAdModal:self willPresent:nil];
}

#pragma mark -
#pragma mark timer time out method
- (void)loadAdTimeOut:(NSTimer*)theTimer{
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self adapter:self didFailAd:nil];
    
}
- (void)stopTimer {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        
        if (timer) {
            [timer invalidate];
            [timer release];
            timer = nil;
        }
        
    });
    
}
#pragma mark -
#pragma mark user info method
- (int)getUserAge{
    int userAge = 23;
    if ([adMoGoDelegate respondsToSelector:@selector(dateOfBirth)]) {
        NSDate *birth = [adMoGoDelegate dateOfBirth];
        if (birth == nil) {
            return userAge;
        }
        NSDate *today = [[NSDate alloc] init];
        NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        NSDateComponents *components = [gregorian components:NSYearCalendarUnit
                                                    fromDate:birth
                                                      toDate:today
                                                     options:0];
        NSInteger years = [components year];
        [gregorian release];
        [today release];
        return years;
    }else{
        return userAge;
    }
}

- (VGGender)getGender{
    
    if ([adMoGoDelegate respondsToSelector:@selector(gender)]) {
        NSString *curGender =[[adMoGoDelegate gender] lowercaseString];
        if ([curGender isEqualToString:@"m"]) {
            return VGGenderMale;
        }else if([curGender isEqualToString:@"f"]){
            return VGGenderFemale;
        }else{
            return VGGenderUnknown;
        }
    }else{
        return VGGenderUnknown;
    }
    
}

- (VGAdOrientation)getOri{
    UIInterfaceOrientation curOri = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(curOri)) {
        return VGAdOrientationPortrait;
    }else if(UIInterfaceOrientationIsLandscape(curOri)){
        return VGAdOrientationLandscape;
    }else{
        return VGAdOrientationUnknown;
    }
}


@end
