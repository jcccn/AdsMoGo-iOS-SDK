//
//  AdsMoGoAdapterVpon.h
//  TestMOGOSDKAPP
//
//  Created by Daxiong on 14-03-25.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "VponBanner.h"
#import "AdMoGoConfigData.h"

@interface AdsMoGoAdapterVpon : AdMoGoAdNetworkAdapter<VponBannerDelegate>{
    NSTimer *timer;
    BOOL isStop;
    BOOL isfailed;
//    UIViewController *vponViewController;
    AdMoGoConfigData *configData;
}
+ (AdMoGoAdNetworkType)networkType;
@end
