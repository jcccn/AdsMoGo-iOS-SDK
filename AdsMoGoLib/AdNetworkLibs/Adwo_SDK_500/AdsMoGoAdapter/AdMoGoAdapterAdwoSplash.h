//
//  AdMoGoAdapterAdwoSplash.h
//  wanghaotest
//
//  Created by mogo on 13-11-13.
//
//
#import "AdMoGoAdNetworkAdapter.h"
#import "AdwoAdSDK.h"

@interface AdMoGoAdapterAdwoSplash : AdMoGoAdNetworkAdapter<AWAdViewDelegate>
{
    UIView *adWoSplash;
    BOOL mCanShowAd;
    BOOL isSuccess;
    BOOL isFail;
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;
- (BOOL)isSupportSplashCache;
@end
