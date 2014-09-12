//
//  AdMoGoAdapterWQFullAd.h
//  wanghaotest
//
//  Created by MOGO on 13-9-28.
//
//
#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "WQInterstitialAdView.h"
@interface AdMoGoAdapterWQFullAd : AdMoGoAdNetworkInterstitialAdapter<WQInterstitialAdViewDelegate>
{
    WQInterstitialAdView *_interstitialAdView;
    BOOL isReady;
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;

@end
