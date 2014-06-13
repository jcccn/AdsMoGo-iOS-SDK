//
//  File: AdMoGoAdapterIZP.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "IZPAdShell.h"

@interface AdMoGoAdapterBJMobile : AdMoGoAdNetworkAdapter <IZPAdDelegate> {
    NSTimer *timer;
    BOOL isStop;
}
+ (AdMoGoAdNetworkType)networkType;
- (BOOL) canBeRemoveAd;
@end
