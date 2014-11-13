//
//  File: AdMoGoAdapterYouMi.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//
//  YouMi v4.6.0 2013_02_16

#import "AdMoGoAdNetworkAdapter.h"
#import "YouMiDelegateProtocol.h"

@class YouMiView;
@protocol YouMiDelegate;

@interface AdMoGoAdapterYM : AdMoGoAdNetworkAdapter <YouMiDelegate> {
	NSTimer *timer;
    BOOL isStop;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
- (void)loadAdTimeOut:(NSTimer*)theTimer;
@end
