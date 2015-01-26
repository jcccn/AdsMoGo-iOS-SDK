//
//  AdMoGoAdapterWQ.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//  Created by pengxu on 12-3-9.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "WQAdView.h"
@interface AdMoGoAdapterWQ : AdMoGoAdNetworkAdapter<WQAdViewDelegate> {
    NSTimer *timer;
    BOOL isStop;
    BOOL isFinish;
    WQAdView *adView;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
- (void)loadAdTimeOut:(NSTimer*)theTimer;
 
@end
