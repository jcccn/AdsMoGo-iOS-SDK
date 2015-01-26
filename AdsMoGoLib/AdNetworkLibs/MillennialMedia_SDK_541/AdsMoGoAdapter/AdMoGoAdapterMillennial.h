//
//  File: AdMoGoAdapterMillennial.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.2.1
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//
//MM v4.6.0

#import "AdMoGoAdNetworkAdapter.h"
#import <MillennialMedia/MMAdView.h>
@interface AdMoGoAdapterMillennial : AdMoGoAdNetworkAdapter  {
	NSMutableDictionary *requestData;
    
    MMAdView *fullAdView;
    NSTimer *timer;
    NSUInteger savedType;
    BOOL isStop;
    
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;

@end
