//
//  AdMoGoAdapterRmob.h
//  
//
//  Created by MOGO on 14-10-28.
//
//


#import "AdMoGoAdNetworkAdapter.h"
#import "RmobSDK.h"
@interface AdMoGoAdapterRmob : AdMoGoAdNetworkAdapter
{
    BOOL isStop;
    BOOL isStopTimer;
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;
@end
