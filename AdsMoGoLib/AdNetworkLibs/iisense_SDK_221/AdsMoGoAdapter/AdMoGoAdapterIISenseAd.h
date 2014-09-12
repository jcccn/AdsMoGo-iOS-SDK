//
//  AdMoGoAdapterIISenseAd.h
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 14-1-3.
//
//

#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoView.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdMoGoAdNetworkAdapter.h"
#import <SNMAd/SNMAd.h>

@interface AdMoGoAdapterIISenseAd : AdMoGoAdNetworkAdapter<SNMAdViewDelegate>{
    
    SNMAdView *banner;
    NSTimer *timer;
}
@end
