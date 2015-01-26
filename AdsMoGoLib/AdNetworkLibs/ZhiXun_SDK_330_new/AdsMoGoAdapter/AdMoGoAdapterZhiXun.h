//
//  AdMoGoAdapterZhiXun.h
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 13-10-22.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "AdSdk.h"

@interface AdMoGoAdapterZhiXun : AdMoGoAdNetworkAdapter{
    AdMoGoConfigData *configData;
    BOOL isStop;
    NSTimer *timer;
    BOOL isStopTimer;
    AdSdk *zhiXun;
    BOOL isloadfail;
    BOOL isSuccess;

}
+ (AdMoGoAdNetworkType)networkType;
-(void)adfinish;
-(void)aderror;
-(void)adclick;
@end
