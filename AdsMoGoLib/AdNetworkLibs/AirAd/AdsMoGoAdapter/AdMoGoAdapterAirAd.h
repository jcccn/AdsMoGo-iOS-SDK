//
//  File: AdMoGoAdapterAirAd.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.2.1
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "airADView.h"

@interface AdMoGoAdapterAirAd : AdMoGoAdNetworkAdapter <airADViewDelegate> {
    NSTimer *timer;
    BOOL isStop;
}
+ (AdMoGoAdNetworkType)networkType;

- (void)loadAdTimeOut:(NSTimer*)theTimer;
@end
