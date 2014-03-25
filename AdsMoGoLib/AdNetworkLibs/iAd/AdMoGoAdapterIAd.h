//
//  File: AdMoGoAdapterIAd.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import <iAd/iAd.h>
#import <iAd/ADBannerView.h>
#import <iAd/ADBannerView_Deprecated.h>
@interface AdMoGoAdapterIAd : AdMoGoAdNetworkAdapter <ADBannerViewDelegate> {
	NSString *kADBannerContentSizeIdentifierPortrait;
	NSString *kADBannerContentSizeIdentifierLandscape;
    
    BOOL isStop;
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;

@end
