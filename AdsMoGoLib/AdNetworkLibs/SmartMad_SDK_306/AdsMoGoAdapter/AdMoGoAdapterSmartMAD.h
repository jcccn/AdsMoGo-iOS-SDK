//
//  File: AdMoGoAdapterSmartMAD.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.2.2
//
//  Copyright 2011 AdsMogo.com. All rights reserved.
//
//SmartMad v2.0.5

#import "AdMoGoAdNetworkAdapter.h"
#import "SMAdManager.h"
#import "SMAdBannerView.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"

@interface AdMoGoAdapterSmartMAD : AdMoGoAdNetworkAdapter <SMAdBannerViewDelegate>{
    NSTimer *timer;
    
    UIView *myView;
    SMAdBannerView *adView;
    
    AdViewType type;
    
    AdMoGoConfigData *configData;
    
    BOOL isStop;
    BOOL isClicked;
}
- (void)loadAdTimeOut:(NSTimer*)theTimer;
@end
