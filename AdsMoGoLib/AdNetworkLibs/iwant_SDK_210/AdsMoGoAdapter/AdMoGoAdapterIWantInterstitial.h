//
//  AdMoGoAdapterIWantInterstitial.h
//  wanghaotest
//
//  Created by MOGO on 13-7-3.
//
//

#import <UIKit/UIKit.h>
#import "AdMoGoAdNetworkAdapter.h"
#import "pingcooSDK.h"
@interface AdMoGoAdapterIWantInterstitial : AdMoGoAdNetworkAdapter<pingcooSDKDelegate>
{
    BOOL isStop;
    NSTimer *timer;
    pingcooSDK *pingcoo;
}
+ (NSDictionary *)networkType;
@end
