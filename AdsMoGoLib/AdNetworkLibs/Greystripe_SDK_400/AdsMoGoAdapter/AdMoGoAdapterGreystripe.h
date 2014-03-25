//
//  File: AdMoGoAdapterGreystripe.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.2.2
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "GSAdDelegate.h"
#import "GSMobileBannerAdView.h"
#import "GSMediumRectangleAdView.h"
#import "GSLeaderboardAdView.h"
#import "GSFullscreenAd.h"

@interface AdMoGoAdapterGreystripe : AdMoGoAdNetworkAdapter <GSAdDelegate> {
    AdViewType type;
    GSAdView *gsAdView;
    GSFullscreenAd *gsFullAd;
    BOOL isStop;
    NSTimer *timer;
}
@end
