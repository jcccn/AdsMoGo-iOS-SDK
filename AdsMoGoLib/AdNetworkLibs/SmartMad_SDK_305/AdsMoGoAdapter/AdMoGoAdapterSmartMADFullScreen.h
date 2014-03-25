//
//  AdMoGoAdapterSmartMADFullScreen.h
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-12-6.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "SMAdInterstitial.h"
@interface AdMoGoAdapterSmartMADFullScreen : AdMoGoAdNetworkAdapter<SMAdInterstitialDelegate>{
    
    NSTimer *timer;
    
    AdViewType type;
    
    AdMoGoConfigData *configData;
    
    BOOL isStop;
    
    SMAdInterstitial *smad_interstitial;
    
    BOOL isReady;
}
@property(nonatomic,retain)SMAdInterstitial* smad_interstitial;
- (void)loadAdTimeOut:(NSTimer*)theTimer;
@end
