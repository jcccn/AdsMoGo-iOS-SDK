//
//  AdMoGoAdapterIWant.h
//  wanghaotest
//
//  Created by MOGO on 13-6-24.
//
//

#import <UIKit/UIKit.h>
#import "AdMoGoAdNetworkAdapter.h"
#import "pingcooSDK.h"
@interface AdMoGoAdapterpingcoo : AdMoGoAdNetworkAdapter<pingcooSDKDelegate>
{
    BOOL isStop;
    NSTimer *timer;
    pingcooSDK *pingcoo;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
@end
