//
//  File: AdMoGoAdapterWooboo.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.2.1
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//
//Wooboo v2.2.1

#import "AdMoGoAdNetworkAdapter.h"
//#import "CommonADColor.h"
#import "CommonADView.h"
@interface AdMoGoAdapterWooboo : AdMoGoAdNetworkAdapter <ADCommonListenerDelegate> {
	BOOL isTouched;
    BOOL isStop;
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
@end
