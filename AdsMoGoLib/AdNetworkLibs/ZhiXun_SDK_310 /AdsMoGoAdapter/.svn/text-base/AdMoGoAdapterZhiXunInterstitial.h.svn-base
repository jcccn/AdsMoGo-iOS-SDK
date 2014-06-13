//
//  AdMoGoAdapterZhiXunInterstitial.h
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 13-10-23.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdSdk.h"

@interface AdMoGoAdapterZhiXunInterstitial : AdMoGoAdNetworkInterstitialAdapter{
    BOOL isStop;
    NSTimer *timer;
    BOOL isStopTimer;
    AdSdk *zhiXunFull;
    UIButton *closeButton;
    UIViewController *uiViewController;
    BOOL isPadDevice;
    UIView *zx_interstitial_super_view;
}
+ (AdMoGoAdNetworkType)networkType;
-(void)adfinish;
-(void)aderror;
-(void)adclick;
-(void)adclose;
@end
