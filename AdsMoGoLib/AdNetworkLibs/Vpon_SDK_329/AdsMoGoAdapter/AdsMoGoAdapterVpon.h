//
//  AdsMoGoAdapterVpon.h
//  TestMOGOSDKAPP
//
//  Created by 孟令之 on 12-11-21.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "VponAdOn.h"
#import "AdOnPlatform.h"
#import "AdMoGoConfigData.h"

@interface AdsMoGoAdapterVpon : AdMoGoAdNetworkAdapter<VponAdOnDelegate>{
    NSTimer *timer;
    BOOL isStop;
    BOOL isfailed;
    UIViewController *vponViewController;
    AdMoGoConfigData *configData;
}
+ (AdMoGoAdNetworkType)networkType;
@end
