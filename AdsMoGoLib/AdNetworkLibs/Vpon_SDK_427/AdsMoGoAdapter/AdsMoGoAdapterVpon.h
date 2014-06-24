//
//  AdsMoGoAdapterVpon.h
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 14-03-25.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "VpadnBanner.h"
#import "AdMoGoConfigData.h"

@interface AdsMoGoAdapterVpon : AdMoGoAdNetworkAdapter<VpadnBannerDelegate>{
    NSTimer *timer;
    BOOL isStop;
    BOOL isfailed;
//    UIViewController *vponViewController;
    AdMoGoConfigData *configData;
}
+ (AdMoGoAdNetworkType)networkType;
@end
