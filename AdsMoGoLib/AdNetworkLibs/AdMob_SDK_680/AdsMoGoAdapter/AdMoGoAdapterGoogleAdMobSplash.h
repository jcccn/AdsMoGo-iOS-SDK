//
//  AdMoGoAdapterGoogleAdMobSplash.h
//  wanghaotest
//
//  Created by mogo on 13-11-18.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "GADInterstitial.h"
#import "GADInterstitialDelegate.h"

@interface AdMoGoAdapterGoogleAdMobSplash : AdMoGoAdNetworkAdapter<GADInterstitialDelegate>{
    GADInterstitial *gadsplash;
    BOOL isFail;
    BOOL isSuccess;
}
+ (AdMoGoAdNetworkType)networkType;
@end
