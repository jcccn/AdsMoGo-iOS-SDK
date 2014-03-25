//
//  AdMoGoAdapterDianruFullAds.h
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 13-12-31.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "DianRuSDK.h"

@interface AdMoGoAdapterDianruFullAds : AdMoGoAdNetworkAdapter<DianRuSDKDelegate>{
    
    NSTimer *timer;
    BOOL isStop;
    BOOL isStopTimer;
    int callNum;
    BOOL isPresnt;
    BOOL isreceived;
    BOOL isDianruDisappear;
}
+ (AdMoGoAdNetworkType)networkType;
- (void)getAd;
- (void)stopBeingDelegate;
- (void)stopTimer;
- (void)stopAd;
- (void)dealloc;
@end
