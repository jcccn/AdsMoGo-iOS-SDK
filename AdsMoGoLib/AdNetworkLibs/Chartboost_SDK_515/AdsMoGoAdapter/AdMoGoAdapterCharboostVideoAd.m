//
//  AdMoGoAdapterCharboostVideoAd.m
//  wanghaotest
//
//  Created by MOGO on 15-4-2.
//
//

#import "AdMoGoAdapterCharboostVideoAd.h"
#import "AdMoGoAdSDKVideoNetworkRegistry.h"
@implementation AdMoGoAdapterCharboostVideoAd

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeChartboost;
}

+ (void)load {
    [[AdMoGoAdSDKVideoNetworkRegistry sharedRegistry] registerClass:self];
}

-(void)getAd{
    isStop = NO;
    isReady = NO;
    isClose = NO;
    NSString *appId = [[self.ration objectForKey:@"key"] objectForKey:@"AppID"];
    NSString *appSignature = [[self.ration objectForKey:@"key"] objectForKey:@"AppSignature"];
    
    [Chartboost startWithAppId:appId appSignature:appSignature delegate:self];
    
    [self adapterDidStartRequestAd:self];
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
    if([Chartboost hasRewardedVideo:CBLocationHomeScreen]) {
        [self cacheVideoSucess];
    }else{
        [Chartboost cacheRewardedVideo:CBLocationHomeScreen];
    }
}

- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    NSLog(@"charboost loadadtimeout%s",__func__);
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

- (void)dealloc{
    [self stopTimer];
    [super dealloc];
}

- (void)stopBeingDelegate{

}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

-(void)playVideoAd{
    if([Chartboost hasRewardedVideo:CBLocationHomeScreen]) {
        
        [Chartboost showRewardedVideo:CBLocationHomeScreen];
    }
}

- (void)cacheVideoSucess
{
    if (isStop) {
        return;
    }
    if (isReady) {
        return;
    }
    isReady = YES;
    
    MGLog(MGD, @"Chartboost视频缓存成功");
    [self stopTimer];
    [self adapter:self didReceiveInterstitialScreenAd:cb];
}

- (void)closevideo{
    if (isClose) {
        return;
    }else{
        isClose = YES;
    }
    [self adapter:self didDismissScreen:nil];

}

#pragma mark - Video Delegate

/*!
 @abstract
 Called after videos have been successfully prefetched.
 
 @discussion Implement to be notified of when the prefetching process has finished successfully.
 */

- (void)didPrefetchVideos{

}

#pragma mark - Rewarded Video Delegate

/*!
 @abstract
 Called before a rewarded video will be displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @return YES if execution should proceed, NO if not.
 
 @discussion Implement to control if the Charboost SDK should display a rewarded video
 for the given CBLocation.  This is evaluated if the showRewardedVideo:(CBLocation)
 is called.  If YES is returned the operation will proceed, if NO, then the
 operation is treated as a no-op and nothing is displayed.
 
 Default return is YES.
 */
- (BOOL)shouldDisplayRewardedVideo:(CBLocation)location{
    [self adapter:self willPresent:nil];
    [self adapter:self didShowAd:nil];
    return YES;
}

/*!
 @abstract
 Called after a rewarded video has been displayed on the screen.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has
 been displayed on the screen for a given CBLocation.
 */
- (void)didDisplayRewardedVideo:(CBLocation)location{
    
}

/*!
 @abstract
 Called after a rewarded video has been loaded from the Chartboost API
 servers and cached locally.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been loaded from the Chartboost API
 servers and cached locally for a given CBLocation.
 */
- (void)didCacheRewardedVideo:(CBLocation)location{
    [self cacheVideoSucess];
}

/*!
 @abstract
 Called after a rewarded video has attempted to load from the Chartboost API
 servers but failed.
 
 @param location The location for the Chartboost impression type.
 
 @param error The reason for the error defined via a CBLoadError.
 
 @discussion Implement to be notified of when an rewarded video has attempted to load from the Chartboost API
 servers but failed for a given CBLocation.
 */
- (void)didFailToLoadRewardedVideo:(CBLocation)location
                         withError:(CBLoadError)error{
    switch(error){
        case CBLoadErrorInternetUnavailable: {
            MGLog(MGE,@"Failed to load Rewarded Video, no Internet connection !");
        } break;
        case CBLoadErrorInternal: {
           MGLog(MGE,@"Failed to load Rewarded Video, internal error !");
        } break;
        case CBLoadErrorNetworkFailure: {
           MGLog(MGE,@"Failed to load Rewarded Video, network error !");
        } break;
        case CBLoadErrorWrongOrientation: {
            MGLog(MGE,@"Failed to load Rewarded Video, wrong orientation !");
        } break;
        case CBLoadErrorTooManyConnections: {
            MGLog(MGE,@"Failed to load Rewarded Video, too many connections !");
        } break;
        case CBLoadErrorFirstSessionInterstitialsDisabled: {
            MGLog(MGE,@"Failed to load Rewarded Video, first session !");
        } break;
        case CBLoadErrorNoAdFound : {
            MGLog(MGE,@"Failed to load Rewarded Video, no ad found !");
        } break;
        case CBLoadErrorSessionNotStarted : {
            MGLog(MGE,@"Failed to load Rewarded Video, session not started !");
        } break;
        case CBLoadErrorNoLocationFound : {
            MGLog(MGE,@"Failed to load Rewarded Video, missing location parameter !");
        } break;
        default: {
            MGLog(MGE,@"Failed to load Rewarded Video, unknown error !");
        }
    }
    [self stopTimer];
    [self adapter:self didFailAd:nil];
}

/*!
 @abstract
 Called after a rewarded video has been dismissed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been dismissed for a given CBLocation.
 "Dismissal" is defined as any action that removed the rewarded video UI such as a click or close.
 */
- (void)didDismissRewardedVideo:(CBLocation)location{
         NSLog(@"%s",__func__);
    [self closevideo];
}

/*!
 @abstract
 Called after a rewarded video has been closed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been closed for a given CBLocation.
 "Closed" is defined as clicking the close interface for the rewarded video.
 */
- (void)didCloseRewardedVideo:(CBLocation)location{
     NSLog(@"%s",__func__);
    [self closevideo];
}

/*!
 @abstract
 Called after a rewarded video has been clicked.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been click for a given CBLocation.
 "Clicked" is defined as clicking the creative interface for the rewarded video.
 */
- (void)didClickRewardedVideo:(CBLocation)location{
    NSLog(@"%s",__func__);
    
}

/*!
 @abstract
 Called after a rewarded video has been viewed completely and user is eligible for reward.
 
 @param reward The reward for watching the video.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when a rewarded video has been viewed completely and user is eligible for reward.
 */
- (void)didCompleteRewardedVideo:(CBLocation)location
                      withReward:(int)reward{
     NSLog(@"%s",__func__);
//    [self closevideo];
    
    [self onVideoReward:@"Charboost"  reward:[NSNumber numberWithInt:reward]];
}

/*!
 @abstract
 Called after an interstitial has been dismissed.
 
 @param location The location for the Chartboost impression type.
 
 @discussion Implement to be notified of when an interstitial has been dismissed for a given CBLocation.
 "Dismissal" is defined as any action that removed the interstitial UI such as a click or close.
 */
- (void)didDismissInterstitial:(CBLocation)location{
    NSLog(@"%s",__func__);
    [self closevideo];
}

@end
