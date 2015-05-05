//
//  File: AdMoGoAdapterBaiduMobAd.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.1.9
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//Baidu v2.0

#import "AdMoGoAdNetworkAdapter.h"
#import "BaiduMobAdView.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"
@interface AdMoGoAdapterBaiduMobAd : AdMoGoAdNetworkAdapter <BaiduMobAdViewDelegate>{
    NSTimer *timer;
    BOOL isStop;
    BaiduMobAdView* sBaiduAdview;
    BOOL isLocationOn;
    BOOL isLoad;
    BOOL isShow;
}
- (void)loadAdTimeOut:(NSTimer*)theTimer;
+ (AdMoGoAdNetworkType)networkType;
@end
