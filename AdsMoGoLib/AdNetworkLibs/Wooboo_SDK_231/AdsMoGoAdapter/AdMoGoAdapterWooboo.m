//  File: AdMoGoAdapterWooboo.m
//  Project: AdsMOGO iOS SDK
//  Version: 1.2.1
//  Copyright 2011 AdsMogo.com. All rights reserved.


#import "AdMoGoAdapterWooboo.h"
#import "AdMoGoView.h"
#import "CommonADView.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdMoGoAdapterWooboo

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeWooboo IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeWooboo;
}

+ (void)load {
	[[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {

    isStop = NO;
    
    [adMoGoCore adDidStartRequestAd];

	[adMoGoCore adapter:self didGetAd:@"wooboo"];


    NSString *WOOBOO_PID = [self.ration objectForKey:@"key"];

    
	if (WOOBOO_PID!=nil && ![WOOBOO_PID isEqualToString:@""]) {
        
        CommonADView *myCommonADView = nil;
        @try {
            myCommonADView = [[CommonADView alloc] initWithPID:WOOBOO_PID
                                                                   locationX:0
                                                                   locationY:0
                                                                 displayType:CommonBannerScreen
                                                           screenOrientation:CommonOrientationPortrait];
        }
        @catch (NSException *exception) {
            MGLog(MGT,@"wooboo exception-->%@",exception);
            [adMoGoCore adapter:self didFailAd:nil];
            return;
        }
        @finally {
            
        }

        [myCommonADView setListenerDelegate:self];
		[myCommonADView startADRequest];
        myCommonADView.requestADTimeIntervel = 0;
        
		self.adNetworkView = myCommonADView;
		[myCommonADView release];
        
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
	}
	else {
		[adMoGoCore adapter:self didFailAd:nil];
	}
}

- (void)stopBeingDelegate {
	CommonADView *adView = (CommonADView *)self.adNetworkView;
    [adView requestADWillStop];
	if (adView != nil) {
		[adView setListenerDelegate:nil];
	}
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}

- (void)dealloc {
    [self stopTimer];
	[super dealloc];
}

-(void)loadAdTimeout:(NSTimer *)theTimer{
    if (isStop) {
        return;
    }
    [super loadAdTimeOut:theTimer];
    [self stopTimer];
    [adMoGoCore adapter:self didFailAd:nil];
}
-(void)stopTimer{
    if (timer) {
        [timer invalidate];
        [timer release],timer = nil;
    }
}
//set ContentLabel Color//
-(UIColor*) setContentLabelColor {
	return [self helperTextColorToUse];
}
//set AD providers NameLabel Color//
-(UIColor*) setNameLabelColor {
	return [self helperSecondaryTextColorToUse];
}



/* 成功获取广告时候调用 */
- (void)didReceivedAD {
    
    if (isStop) {
        return;
    }
    [self stopTimer];
    if ([NSThread isMainThread]) {
        [adMoGoCore adapter:self didReceiveAdView:adNetworkView];
    }
    else {
        [self performSelectorOnMainThread:@selector(showAd)
                               withObject:nil
                            waitUntilDone:NO];
    }
}

/* 获取广告失败的时候调用 */
- (void)onFailedToReceiveAD:(NSString*)error{
    
    MGLog(MGT,@"%s",__FUNCTION__);
    if (isStop) {
        return;
    }
    [self stopTimer];
    if ([NSThread isMainThread]) {
        [self failAd];
    }
    else {
        [self performSelectorOnMainThread:@selector(failAd)
                               withObject:nil
                            waitUntilDone:NO];
    }
}

- (void)showAd {
    
    if (isStop) {
        return;
    }
    
    [adMoGoCore adapter:self didReceiveAdView:adNetworkView];
}

- (void)failAd{
    if (isStop) {
        return;
    }
    [adMoGoCore adapter:self didFailAd:nil];
}
@end