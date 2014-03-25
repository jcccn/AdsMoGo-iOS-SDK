//
//  AdMoGoAdapterWAPSFullAd.h
//  MoGoSample_iPhone
//
//  Created by MOGO on 13-5-8.
//
//

#import "AdMoGoAdNetworkAdapter.h"

@interface AdMoGoAdapterWAPSFullAd : AdMoGoAdNetworkAdapter
{
    NSTimer *timer;
    BOOL isReady;
    NSTimer *detachPresentTimer;
    BOOL isPresent;
}
+ (AdMoGoAdNetworkType)networkType;

@end
