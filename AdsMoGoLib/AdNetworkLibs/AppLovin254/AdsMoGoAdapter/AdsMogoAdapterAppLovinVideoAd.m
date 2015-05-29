//
//  AdsMogoAdapterAdwoVideoAd.m
//  wanghaotest
//
//  Created by ChaSel Chen on 15-4-3.
//
//

#import "AdsMogoAdapterAppLovinVideoAd.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
 
@interface AdsMogoAdapterAppLovinVideoAd()<ALAdLoadDelegate, ALAdRewardDelegate,ALAdVideoPlaybackDelegate,ALAdDisplayDelegate>{
    BOOL isReady;
    BOOL isStop;
    BOOL issuccess;
    BOOL isfail;
    UIView *mAdView;
    NSTimer *timer;
    NSTimer *timerreward;
    BOOL isdismiss;
}

@end

@implementation AdsMogoAdapterAppLovinVideoAd
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeAppLovIn;
}

+ (void)load{
    [[AdMoGoAdAPIVideoNetworkRegistry sharedRegistry] registerClass:self];
}

-(BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)getAd{
    isStop = NO;
    isReady = NO;
    issuccess = NO;
    isfail = NO;
    isdismiss = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    
  [self adapterDidStartRequestAd:self];
    AdViewType type =[configData.ad_type intValue];
    isReady =NO;
    switch (type) {
        case AdViewTypeVideo:
            break;
        default:
            [self adapter:self didFailAd:nil];
            return;
            break;
    }
    [ALSdk initializeSdk];
    
    
//    ALSdk* sdk = [ALSdk shared];
//    
//    [[ALIncentivizedInterstitialAd shared] initWithSdk:sdk];
    [ALIncentivizedInterstitialAd shared].adDisplayDelegate = self;
    [ALIncentivizedInterstitialAd shared].adVideoPlaybackDelegate = self;
    [[ALIncentivizedInterstitialAd shared] preloadAndNotify: self];
    if([ALIncentivizedInterstitialAd isReadyForDisplay]){
        // If you want to use a reward delegate, set it here.  For this example, we will use nil.
        [self issuccess:YES];
        return;
    }
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}

-(void)stopBeingDelegate{
    //    ALIncentivizedInterstitialAd *interstitialad = [ALIncentivizedInterstitialAd shared];
    //    interstitialad.adDisplayDelegate = nil;
}

- (void)dealloc {
    
    
    [super dealloc];
}

- (void)issuccess:(BOOL)status{
    if (issuccess == isfail && issuccess==NO) {
        [self stopTimer];
        if (status) {
            issuccess = YES;
            [self adapter:self didReceiveInterstitialScreenAd:nil];
        }else{
            issuccess = NO;
            [self adapter:self didFailAd:nil];
        }
    }
}

- (void)videoadDismiss{
    if (isdismiss) {
        return;
    }else{
        isdismiss = YES;
    }
   
    [self adapter:self didDismissScreen:nil];
}


- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)stoprrewardtimer{
    if (timerreward) {
        
        [timerreward invalidate];
        [timerreward release];
        timerreward = nil;
    }
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}

- (void)rewardtimeout:(NSTimer*)theTimer {
    [self stoprrewardtimer];
    [self videoadDismiss];
    
}

-(void)playVideoAd{
    [[ALIncentivizedInterstitialAd shared] showAndNotify: self];
     timerreward = [[NSTimer scheduledTimerWithTimeInterval:5 target:self selector:@selector(rewardtimeout:) userInfo:nil repeats:NO] retain];
}


#pragma mark ALAdLoadDelegate implementation... mandatory for rewarded videos

-(void) adService:(ALAdService *)adService didLoadAd:(ALAd *)ad
{
    isReady = YES;
    [self issuccess:YES];
}

-(void) adService:(ALAdService *)adService didFailToLoadAdWithError:(int)code
{
    isReady =NO;
    [self issuccess:NO];

}




#pragma mark ALAdDisplayDelegate
/**
 * This method is invoked when the ad is displayed in the view.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad that was just displayed. Will not return nil.
 * @param view   Ad view in which the ad was displayed. Will not return nil.
 */
-(void) ad:(ALAd *) ad wasDisplayedIn: (UIView *)view{

}

/**
 * This method is invoked when the ad is hidden from in the view. This occurs
 * when the ad is rotated or when it is explicitly closed.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad that was just hidden. Will not return nil.
 * @param view   Ad view in which the ad was hidden. Will not return nil.
 */
-(void) ad:(ALAd *) ad wasHiddenIn: (UIView *)view{
//     [self videoadDismiss];
    [self performSelector:@selector(videoadDismiss) withObject:nil afterDelay:3.0];
}

/**
 * This method is invoked when the ad is clicked from in the view.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad     Ad that was just clicked. Will not return nil.
 * @param view   Ad view in which the ad was hidden. Will not return nil.
 */
-(void) ad:(ALAd *) ad wasClickedIn: (UIView *)view{

}


#pragma mark  ALAdVideoPlaybackDelegate

/**
 * This method is invoked when a video starts playing in an ad.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad Ad in which video playback began.
 */
-(void) videoPlaybackBeganInAd: (ALAd*) ad{
    [self stoprrewardtimer];
    [self adapter:self willPresent:nil];
    [self adapter:self didShowAd:nil];
    
   
   
}

/**
 * This method is invoked when a video stops playing in an ad.
 *
 * This method is invoked on the main UI thread.
 *
 * @param ad                Ad in which video playback ended.
 * @param percentPlayed     How much of the video was watched, as a percent.
 * @param wasFullyWatched   Whether or not the video was watched to, or very near to, completion.
 */
-(void) videoPlaybackEndedInAd: (ALAd*) ad atPlaybackPercent:(NSNumber*) percentPlayed fullyWatched: (BOOL) wasFullyWatched{
   
}

#pragma mark  ALAdRewardDelegate
-(void) rewardValidationRequestForAd:(ALAd *)ad didSucceedWithResponse:(NSDictionary *)response
{
    // Grant your user coins, or better yet, set up postbacks in the UI and refresh the balance from your server.
    
    NSString* currencyName = [response objectForKey: @"currency"];
    // For example - "Coins", "Gold", whatever you set in the UI.
    
    NSString* amountGivenString = [response objectForKey: @"amount"];
    // For example, "5" or "5.00" if you've specified an amount in the UI.
    // Obviously NSStrings aren't super helpful for numerica data, so you'll probably want to convert to NSNumber.
    
    NSNumber* amountGiven = [NSNumber numberWithFloat: [amountGivenString floatValue]];
    
    [self onVideoReward:@"AppLovin"  reward:amountGiven];
    [self stoprrewardtimer];
}

-(void) rewardValidationRequestForAd:(ALAd *)ad didFailWithError:(NSInteger)responseCode
{
    if(responseCode == kALErrorCodeIncentivizedUserClosedVideo)
    {
       
    }
    
    if(responseCode == kALErrorCodeIncentivizedValidationNetworkTimeout || responseCode == kALErrorCodeIncentivizedUnknownServerError)
    {
     
    }
   
    [self stoprrewardtimer];

    
}

-(void) rewardValidationRequestForAd: (ALAd *) ad wasRejectedWithResponse: (NSDictionary*) response{
    [self stoprrewardtimer];

}

-(void) rewardValidationRequestForAd: (ALAd*) ad didExceedQuotaWithResponse: (NSDictionary*) response{
    [self stoprrewardtimer];

}



@end
