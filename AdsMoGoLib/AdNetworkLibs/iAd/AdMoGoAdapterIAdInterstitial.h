//
//  AdMoGoAdapterIAdInterstitial.h
//  wanghaotest
//
//  Created by mogo on 14-4-3.
//
//


#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import <iAd/iAd.h>
#import <iAd/ADInterstitialAd.h>
#import <iAd/UIViewControlleriAdAdditions.h>
@interface AdMoGoAdapterIAdInterstitial : AdMoGoAdNetworkAdapter<ADInterstitialAdDelegate>{
    ADInterstitialAd *adInterstitialAd;
    NSTimer *timer;
    BOOL isStop;
}

@end
