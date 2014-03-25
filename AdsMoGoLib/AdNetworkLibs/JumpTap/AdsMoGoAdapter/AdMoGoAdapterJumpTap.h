//
//  File: AdMoGoAdapterJumpTap.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "JTAdWidget.h"

@interface AdMoGoAdapterJumpTap : AdMoGoAdNetworkAdapter <JTAdWidgetDelegate> {
	BOOL isStop;
    NSTimer *timer;
}

//+ (NSDictionary *)networkType;
+ (AdMoGoAdNetworkType)networkType;
@end
