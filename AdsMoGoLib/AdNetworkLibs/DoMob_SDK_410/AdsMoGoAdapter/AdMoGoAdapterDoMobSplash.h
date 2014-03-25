//
//  AdMoGoAdapterDoMobSplash.h
//  wanghaotest
//
//  Created by mogo on 13-11-18.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "DMSplashAdController.h"
@interface AdMoGoAdapterDoMobSplash : AdMoGoAdNetworkAdapter<DMSplashAdControllerDelegate>
{
    DMSplashAdController *_splashAd;
    BOOL isFail;
    BOOL isSuccess;
}
+ (AdMoGoAdNetworkType)networkType;
@end
