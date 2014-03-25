//
//  AdMoGoAdapterChartboost.h
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-12-3.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "Chartboost.h"
@interface AdMoGoAdapterChartboost : AdMoGoAdNetworkAdapter<ChartboostDelegate>{
    Chartboost *cb;
    NSTimer *timer;
    BOOL isStop;
    BOOL isReady;
}
+ (AdMoGoAdNetworkType)networkType;
@end
