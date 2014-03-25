//
//  AdMoGoAdapterMobWinAd.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.2.2
//  Created by pengxu on 12-3-6.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "MobWinBannerView.h"



@interface AdMoGoAdapterMobWinAd : AdMoGoAdNetworkAdapter <MobWinBannerViewDelegate>{
    MobWinBannerView *adView;
    BOOL isStop;
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
@end
