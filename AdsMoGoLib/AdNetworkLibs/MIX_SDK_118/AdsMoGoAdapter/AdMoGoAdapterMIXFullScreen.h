//
//  AdMoGoAdapterMIXFullScreen.h
//  wanghaotest
//
//  Created by MOGO on 13-5-31.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "MIXView.h"
#import "MIXViewDelegate.h"
@interface AdMoGoAdapterMIXFullScreen : AdMoGoAdNetworkInterstitialAdapter<MIXViewDelegate>{
    NSTimer *timer;
    BOOL isStop;
    MIXView *mixview;
    BOOL isReady;
    NSString *adUnitId;
    NSString *place;
    BOOL isLoadNextAdapter;
    BOOL isError;
    BOOL isSuccess;
}
+ (AdMoGoAdNetworkType)networkType;
@end
