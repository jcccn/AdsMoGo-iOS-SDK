//
//  AdMoGoAdapterIZPInterstisial.h
//  wanghaotest
//
//  Created by mogo on 14-1-23.
//
//

#import "IZPAdShell.h"
#import "AdMoGoAdNetworkAdapter.h"

@interface AdMoGoAdapterBJMobileInterstisial : AdMoGoAdNetworkAdapter<IZPAdDelegate>{
    NSTimer *timer;
    BOOL isStop;
    BOOL isReady;
    UIView *adView;
}
+ (AdMoGoAdNetworkType)networkType;

@end
