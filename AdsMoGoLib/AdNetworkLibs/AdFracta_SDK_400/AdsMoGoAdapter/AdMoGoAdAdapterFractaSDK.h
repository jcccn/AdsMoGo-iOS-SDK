//
//  AdMoGoAdAdapterFracta.h
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-8-14.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//  Version: 1.2.1
//  

#import "AdMoGoAdNetworkAdapter.h"
#import "FtadStatusDelegate.h"
#import "FtadBannerView.h"
#import "FtadManager.h"

@interface AdMoGoAdAdapterFractaSDK : AdMoGoAdNetworkAdapter<FtadStatusDelegate>{
    FtadManager *manager;
    FtadBannerView *bannerView;
    UIView *view;
    NSTimer *timer;
    BOOL isStop;
}
+ (AdMoGoAdNetworkType)networkType;

@end
