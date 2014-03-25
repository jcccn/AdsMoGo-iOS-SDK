//
//  AdMoGoAdapterUM.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//  Created by pengxu on 12-3-8.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "UMUFPBannerView.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"

@interface AdMoGoAdapterUM : AdMoGoAdNetworkAdapter {
    AdMoGoConfigData *configData;
    UMUFPBannerView *adView;
    BOOL isStop;
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
@end
