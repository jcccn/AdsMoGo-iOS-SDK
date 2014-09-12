//
//  AdMoGoAdapterWAPS.h
//  MoGoSample_iPhone
//
//  Created by MOGO on 13-5-8.
//
//

#import "AdMoGoAdNetworkAdapter.h"

@interface AdMoGoAdapterWAPS : AdMoGoAdNetworkAdapter
{
    UIViewController *viewController;
    NSTimer *timer;
}

+ (AdMoGoAdNetworkType)networkType;

@end
