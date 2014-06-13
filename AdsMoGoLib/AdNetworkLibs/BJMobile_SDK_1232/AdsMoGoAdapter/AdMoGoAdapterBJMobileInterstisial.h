//
//  AdMoGoAdapterIZPInterstisial.h
//  wanghaotest
//
//  Created by mogo on 14-1-23.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "IZPAdShell.h"
#import "AdMoGoAdNetworkAdapter.h"

@interface AdMoGoAdapterBJMobileInterstisial : AdMoGoAdNetworkInterstitialAdapter<IZPAdDelegate>{
    NSTimer *timer;
    BOOL isStop;
    BOOL isReady;
    UIView *adView;
}
+ (AdMoGoAdNetworkType)networkType;

@end
