//
//  AdMoGoAdapterGreystripeFullScreen.h
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-12-20.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "GSAdDelegate.h"
#import "GSFullscreenAd.h"
@interface AdMoGoAdapterGreystripeFullScreen : AdMoGoAdNetworkInterstitialAdapter <GSAdDelegate> {
    AdViewType type;
    GSFullscreenAd *gsFullAd;
    BOOL isStop;
    NSTimer *timer;
    
}

@end
