//
//  File: AdMoGoAdapterSmartMAD.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterSmartMAD.h"
#import "AdMoGoAdNetworkRegistry.h"

#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"


#define kAdMoGoSmartMADAppIDKey @"AppID"
#define kAdMoGoSmartMADAdPosKey @"AdSpaceID"
#import "AdMoGoAdapterSmartMADFullScreen.h"

@implementation AdMoGoAdapterSmartMADFullScreen

@synthesize smad_interstitial;
//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeSmartMAD IsSDK:YES isApi:NO isBanner:NO isFullScreen:YES];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeSmartMAD;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    
    isStop = NO;
    isReady = NO;
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    

    configData = [configDataCenter.config_dict objectForKey:interstitial.configKey];
	
    NSString *SmartMad_AppId = [[self.ration objectForKey:@"key"] objectForKey:kAdMoGoSmartMADAppIDKey];
    
    NSString *SmartMad_AdPos = [[self.ration objectForKey:@"key"] objectForKey:kAdMoGoSmartMADAdPosKey];
    
	if (SmartMad_AppId!=nil && ![SmartMad_AppId isEqualToString:@""]
		&& SmartMad_AdPos!=nil && ![SmartMad_AdPos isEqualToString:@""]) {
        [SMAdManager setChannelId:@"adsmogo"];
        [SMAdManager setApplicationId:SmartMad_AppId];
        
        if ([adMoGoDelegate respondsToSelector:@selector(dateOfBirth)]) {
            NSUInteger age = [self helperCalculateAge];
            //            [SMAdManager setUserAge:age];
            [SMAdManager setUserInformation:[NSString stringWithFormat:@"{\"age\":\"%d\"}",age]];
            NSDateFormatter *dataFormatter = [[NSDateFormatter alloc] init];
            NSDate *date = [adMoGoDelegate dateOfBirth];
            [dataFormatter setDateFormat:@"YYYYMMdd"];
            NSString *dateString = [[NSString alloc] initWithFormat:@"%@",[dataFormatter stringFromDate:date]];
            //            [SMAdManager setBirthDay:dateString];
            [SMAdManager setUserInformation:[NSString stringWithFormat:@"{\"birthday\":\"%@\"}",dateString]];
            [dateString release];
            [dataFormatter release];
        }
        
        if ([adMoGoDelegate respondsToSelector:@selector(gender)]) {
            NSString *genderStr = [adMoGoDelegate gender];
            [SMAdManager setUserInformation:[NSString stringWithFormat:@"{\"gender\":\"%@\"}",genderStr]];
        }
        
        if ([adMoGoDelegate respondsToSelector:@selector(keywords)]) {
            NSString *keywords = [adMoGoDelegate keywords];
            [SMAdManager setKeywords:keywords];
        }
        
        if ([adMoGoDelegate respondsToSelector:@selector(postalCode)]) {
            NSString *postalCode = [adMoGoDelegate postalCode];
            //            [SmartMadAdView setPostalCode:postalCode];
            [SMAdManager setUserInformation:[NSString stringWithFormat:@"{\"zipcode\":\"%@\"}",postalCode]];
        }
        
        type = [configData.ad_type intValue];
        BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
        [SMAdManager setDebugMode:testMode];
        /*
         现有ipad中没有适合ipad兼容模式大小尺寸
         */
        
        if (type == AdViewTypeiPadFullScreen || type == AdViewTypeFullScreen ) {
            
            smad_interstitial=[[SMAdInterstitial alloc] initWithAdSpaceId:SmartMad_AdPos];
            smad_interstitial.delegate=self;
            [smad_interstitial requestAd];
            [interstitial adapterDidStartRequestAd:self];
        }
        else{
//            [adMoGoCore adapter:self didGetAd:@"smartmad"];
            [interstitial adapter:self didFailAd:nil];
        }
//        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut60 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
	}
    else{
//        [adMoGoCore adapter:self didGetAd:@"smartmad"];
        [interstitial adapter:self didFailAd:nil];
    }
}

- (void)stopBeingDelegate {
    if (smad_interstitial) {
        smad_interstitial.delegate = nil;
        [smad_interstitial release];
        smad_interstitial = nil;
    }
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    [self stopTimer];
}
- (void)stopTimer {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}
- (void)dealloc {
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    
	[super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
     UIViewController *rootviewController = [self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView];
    [smad_interstitial presentFromRootViewController:rootviewController];
}

#pragma mark - SMAdInterstitialDelegate

/*!
 @method
 @abstract 收到插页广告
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialDidReceiveAd:(SMAdInterstitial*)ad{
    
    if (isStop) {
        return;
    }
    [self stopTimer];
    
    if ([self.adMoGoInterstitialDelegate viewControllerForPresentingInterstitialModalView]) {
        isReady = YES;
        [interstitial adapter:self didReceiveInterstitialScreenAd:ad];
    }
    else{
        [interstitial adapter:self didFailAd:nil];
    }
}

/*!
 @method
 @abstract 插页广告获取失败
 @discussion
 @param adview
 @param errorCode
 @result nil
 */
- (void)adInterstitial:(SMAdInterstitial*)adview didFailToReceiveAdWithError:(SMAdEventCode*)errorCode{
    if (isStop) {
        return;
    }
    MGLog(MGT,@"errorcode is %@",errorCode);

    [self stopTimer];
    [interstitial adapter:self didFailAd:nil];
}

/*!
 @method
 @abstract 插页广告被点击
 @discussion
 @result nil
 */
- (void)adInterstitialDidClick{
    [interstitial specialSendRecordNum];
}


/*!
 @method
 @abstract 插页广告将被展示
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialWillPresentScreen:(SMAdInterstitial*)ad{
    [interstitial adapter:self WillPresent:ad];
}

/*!
 @method
 @abstract 插页广告将被移出
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialWillDismissScreen:(SMAdInterstitial*)ad{

}

/*!
 @method
 @abstract 插页广告已经被移出
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialDidDismissScreen:(SMAdInterstitial*)ad{
    [interstitial adapter:self didDismissScreen:ad];
}

/*!
 @method
 @abstract 应用程序切换到后台
 @discussion
 @param ad
 @result nil
 */
- (void)adInterstitialWillLeaveApplication:(SMAdInterstitial*)ad{
}


- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
    /*******/
    [self stopBeingDelegate];
//    [adMoGoCore adapter:self didGetAd:@"smartmad"];
    [interstitial adapter:self didFailAd:nil];
}



@end
