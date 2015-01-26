//
//  AdMoGoAdapterChartboost.h
//  TestMOGOSDKAPP
//
//  Created by MOGO on 12-12-3.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import <Chartboost/Chartboost.h>
@interface AdMoGoAdapterChartboost : AdMoGoAdNetworkInterstitialAdapter<ChartboostDelegate>{
    Chartboost *cb;
    NSTimer *timer;
    BOOL isStop;
    BOOL isReady;
}
+ (AdMoGoAdNetworkType)networkType;
@end
