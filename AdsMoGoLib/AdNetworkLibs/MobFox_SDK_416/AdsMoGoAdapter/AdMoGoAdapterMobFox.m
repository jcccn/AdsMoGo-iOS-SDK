//
//  AdMoGoAdapterMobFox.m
//  wanghaotest
//
//  Created by MOGO on 13-7-18.
//
//

#import "AdMoGoAdapterMobFox.h"

#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@implementation AdMoGoAdapterMobFox

//+ (NSDictionary *)networkType {
//    return [self makeNetWorkType:AdMoGoAdNetworkTypeMobFox IsSDK:YES isApi:NO isBanner:YES isFullScreen:NO];
//}
//
//+ (void)load {
//	[[AdMoGoAdNetworkRegistry sharedRegistry] registerClass:self];
//}

+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeMobFox;
}

+(void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isStop = NO;
    isStopTimer = NO;
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    AdViewType type =[configData.ad_type intValue];
    
    CGSize size =CGSizeMake(0, 0);
    switch (type) {
        case AdViewTypeNormalBanner:
            size = CGSizeMake(320, 50);
            break;
        case AdViewTypeLargeBanner:
            size = CGSizeMake(728, 90);
            break;
        default:
            [adMoGoCore adapter:self didFailAd:nil];
            return;
            break;
    }
    
    id key = [self.ration objectForKey:@"key"];
    if ([key isKindOfClass:[NSDictionary class]]) {
        id _requestURL = [key objectForKey:@"requestURL"];
        if (_requestURL && [_requestURL isKindOfClass:[NSString class]]) {
            if (![(NSString *)_requestURL isEqualToString:@""] && [self isMatch:_requestURL]) {
                requestURL = _requestURL;
            }
            else{
                requestURL = @"http://my.mobfox.com/request.php";
            }
        }
        else{
            requestURL = @"http://my.mobfox.com/request.php";
        }
        id _publisherID = [key objectForKey:@"publisherId"];
        if (_publisherID && [_publisherID isKindOfClass:[NSString class]]) {
            publisherID = (NSString *)_publisherID;
        }
    }
    
    
    
    bannerView = [[MobFoxBannerView alloc] initWithFrame:CGRectZero];
    // size does not matter yet
    // Don't trigger an Advert load when setting delegate
    bannerView.allowDelegateAssigmentToRequestAd = NO;
    bannerView.delegate = self;
    bannerView.backgroundColor = [UIColor clearColor];
    bannerView.refreshAnimation = UIViewAnimationTransitionFlipFromLeft;
    bannerView.requestURL = requestURL;
    self.adNetworkView = bannerView;
    [bannerView release];
    @try {
         [bannerView requestAd];
//        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut5 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
    @catch (NSException *exception) {
        [self stopTimer];
        [adMoGoCore adapter:self didFailAd:nil];
        return;
    }
    @finally {
        
    }
}

- (void)stopBeingDelegate {
    MobFoxBannerView *view = (MobFoxBannerView *)self.adNetworkView;
    if (view) {
        view.delegate = nil;
    }
    
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
    [self stopTimer];
}

- (void)stopTimer {
    if (!isStopTimer) {
        isStopTimer = YES;
    }else{
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)dealloc {
    isStop = YES;
	[super dealloc];
}


- (NSString *)publisherIdForMobFoxBannerView:(MobFoxBannerView *)banner{
    return publisherID;
}

- (void)mobfoxBannerViewDidLoadMobFoxAd:(MobFoxBannerView *)banner{
    [self stopTimer];
    banner.frame = CGRectMake(0.0, 0.0, banner.frame.size.width, banner.frame.size.height);
    [adMoGoCore adapter:self didReceiveAdView:banner];

}

- (void)mobfoxBannerViewDidLoadRefreshedAd:(MobFoxBannerView *)banner{

}

- (void)mobfoxBannerView:(MobFoxBannerView *)banner didFailToReceiveAdWithError:(NSError *)error{
    [self stopTimer];
    
    [adMoGoCore adapter:self didFailAd:error];

}



- (void)mobfoxBannerViewActionWillPresent:(MobFoxBannerView *)banner{

}

- (void)mobfoxBannerViewActionWillFinish:(MobFoxBannerView *)banner{

}

- (void)mobfoxBannerViewActionDidFinish:(MobFoxBannerView *)banner{

}

- (void)mobfoxBannerViewActionWillLeaveApplication:(MobFoxBannerView *)banner{

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
    [interstitial adapter:self didFailAd:nil];
}

- (BOOL)isMatch:(NSString *)string{
    NSString *expression = @"(https?|ftp|file)://[-A-Z0-9+&@#/%?=~_|!:,.;]*[-A-Z0-9+&@#/%=~_|]";
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:string options:0 range:NSMakeRange(0, [string length])];
    
    NSRange ran = [match rangeAtIndex:0];
    if(ran.length>0 && ran.location==0){
        return YES;
    }else{
        return NO;
    }
}

@end
