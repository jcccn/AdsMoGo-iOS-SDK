//
//  File: AdMoGoAdapterIZP.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "IZPView.h"
#import "IZPDelegate.h"

@interface AdMoGoAdapterIZP : AdMoGoAdNetworkAdapter <IZPDelegate> {
    NSTimer *timer;
    BOOL isStop;
}
+ (AdMoGoAdNetworkType)networkType;
//- (void)loadAdTimeOut:(NSTimer*)theTimer;
@end
