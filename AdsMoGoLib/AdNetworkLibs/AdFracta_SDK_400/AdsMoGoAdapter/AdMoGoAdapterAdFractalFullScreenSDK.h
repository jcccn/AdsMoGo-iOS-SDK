//
//  AdMoGoAdapterAdFractalFullScreenSDK.h
//  TestMOGOSDKAPP
//
//  Created by hao wang on 12-8-29.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "FtadStatusDelegate.h"
#import "FtadFullScreenStartView.h"
#import "FtadManager.h"

@interface AdMoGoAdapterAdFractalFullScreenSDK : AdMoGoAdNetworkAdapter<FtadStatusDelegate>{
    FtadManager *manager;
    FtadFullScreenStartView *fullScreenView;
    UIView *view;
    NSTimer *timer;
    BOOL isStop;
}
+ (AdMoGoAdNetworkType)networkType;
@end
