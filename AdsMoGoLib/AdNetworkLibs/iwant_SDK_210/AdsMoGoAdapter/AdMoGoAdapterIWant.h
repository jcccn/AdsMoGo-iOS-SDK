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
@interface AdMoGoAdapterIWant : AdMoGoAdNetworkAdapter<pingcooSDKDelegate>
{
    BOOL isStop;
    NSTimer *timer;
    pingcooSDK *pingcoo;
}
+ (NSDictionary *)networkType;
@end
