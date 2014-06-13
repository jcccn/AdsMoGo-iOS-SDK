//
//  File: AdMoGoAdapterSmartMAD.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdapterSmartMAD.h"
#import "AdMoGoAdNetworkRegistry.h"
//#import "AdMoGoView.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"


#define kAdMoGoSmartMADAppIDKey @"AppID"
#define kAdMoGoSmartMADAdPosKey @"AdSpaceID"

@implementation AdMoGoAdapterSmartMAD

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeSmartMAD;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeSmartMAD IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

- (void)getAd {	
    
    isStop = NO;
    isClicked = NO;
    [adMoGoCore adDidStartRequestAd];
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
	
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
//            if ([genderStr isEqualToString:@"f"]) {
//                [SMAdManager setUserGender:UFemale];
//                
//            }
//            if ([genderStr isEqualToString:@"m"]) {
//                [SMAdManager setUserGender:UMale];
//            }
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
        [SMAdManager setAdRefreshInterval:1];
        myView = [[UIView alloc] init];
        /*
            现有ipad中没有适合ipad兼容模式大小尺寸
         */
        
        if (type == AdViewTypeNormalBanner || type == AdViewTypeiPadNormalBanner ) {
            myView.frame = CGRectMake(0, 0, 320, 48);
            adView = [[SMAdBannerView alloc] initWithAdSpaceId:SmartMad_AdPos smAdSize:PHONE_AD_BANNER_MEASURE_AUTO];
        }
        else if (type == AdViewTypeLargeBanner) {
            myView.frame = CGRectMake(0, 0, 728, 90);
            adView = [[SMAdBannerView alloc] initWithAdSpaceId:SmartMad_AdPos smAdSize:TABLET_AD_BANNER_MEASURE_728X90];
        }
        else if (type == AdViewTypeMediumBanner) {
            myView.frame = CGRectMake(0, 0, 468, 60);
            adView = [[SMAdBannerView alloc] initWithAdSpaceId:SmartMad_AdPos smAdSize:TABLET_AD_BANNER_MEASURE_468X60];
        }
        else if (type == AdViewTypeRectangle) {
            myView.frame = CGRectMake(0, 0, 300, 250);
             adView = [[SMAdBannerView alloc] initWithAdSpaceId:SmartMad_AdPos smAdSize:TABLET_AD_BANNER_MEASURE_300X250];
        }else{
            [adMoGoCore adapter:self didGetAd:@"smartmad"];
            [adMoGoCore adapter:self didFailAd:nil];
            return;
        }
        adView.delegate = self;
        adView.rootViewController = [adMoGoDelegate viewControllerForPresentingModalView];
        
        [myView addSubview:adView];
        /*2013*/
        [adView release];
        self.adNetworkView = myView;
        /*2013*/
        [myView release];
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
        [adMoGoCore adapter:self didGetAd:@"smartmad"];
        [adMoGoCore adapter:self didFailAd:nil];
    }
}

- (void)stopBeingDelegate {
    /*2013*/
    UIView *_myView = self.adNetworkView;
    if (_myView) {
        SMAdBannerView *_smartView = (SMAdBannerView*)[[_myView subviews] lastObject];
        if (_smartView != nil) {
            _smartView.delegate = nil;
            [_smartView removeFromSuperview];
            _smartView = nil;
        }
    }
	
}

- (void)stopAd{
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

#pragma mark - SMAdBannerViewDelegate
/*!
 @method
 @abstract adBannerViewDidReceiveAd取到广告
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewDidReceiveAd:(SMAdBannerView*)adView{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [adMoGoCore adapter:self didGetAd:@"smartmad"];
    [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView waitUntilDone:YES];

}

/*!
 @method
 @abstract adBannerView取广告失败
 @discussion
 @param adView
 @param errorCode
 @result nil
 */
- (void)adBannerView:(SMAdBannerView*)adView didFailToReceiveAdWithError:(SMAdEventCode*)errorCode{
    if (isStop) {
        return;
    }
    MGLog(MGT,@"errorcode is %@",errorCode);
    [self stopTimer];
    [adMoGoCore adapter:self didGetAd:@"smartmad"];
    [adMoGoCore adapter:self didFailAd:nil];
}

/*!
 @method
 @abstract 即将展示banner广告
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewWillPresentScreen:(SMAdBannerView*)adView impressionEventCode:(SMAdEventCode *)eventCode{

}

/*!
 @method
 @abstract 即将移出banner广告
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewWillDismissScreen:(SMAdBannerView*)adView{

}

/*!
 @method
 @abstract 已经移出banner广告
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewDidDismissScreen:(SMAdBannerView*)adView{

}

/*!
 @method
 @abstract 应用程序被切换到后台
 @discussion
 @param adView
 @result nil
 */
- (void)adBannerViewWillLeaveApplication:(SMAdBannerView*)adView{

}

/*!
 @method
 @abstract 广告被点击
 @discussion
 @result nil
 */
- (void)adDidClick{
    if (!isClicked) {
        [adMoGoCore premiumADClick_SmartAd];
        isClicked = YES;
    }
    
}

/*!
 @method
 @abstract banner将被expand
 @discussion
 @param adView
 @result nil
 */
- (void)adWillExpandAd:(SMAdBannerView *)adView{

}

/*!
 @method
 @abstract expand已经被关闭
 @discussion
 @param adView
 @result nil
 */
- (void)adDidCloseExpand:(SMAdBannerView*)adView{

}

/*!
 @method
 @abstract 应用程序即将被挂起
 @discussion
 @param adView
 @result nil
 */
- (void)appWillSuspendForAd:(SMAdBannerView*)adView{

}

/*!
 @method
 @abstract 应用程序即将被唤醒
 @discussion
 @param adView
 @result nil
 */
- (void)appWillResumeFromAd:(SMAdBannerView*)adView{

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
    [adMoGoCore adapter:self didGetAd:@"smartmad"];
    [adMoGoCore adapter:self didFailAd:nil];
}
@end
