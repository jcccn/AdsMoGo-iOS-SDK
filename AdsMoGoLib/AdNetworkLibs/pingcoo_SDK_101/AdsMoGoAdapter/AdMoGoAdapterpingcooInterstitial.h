//
//  AdMoGoAdapterIWantInterstitial.h
//  wanghaotest
//
//  Created by MOGO on 13-7-3.
//
//

#import <UIKit/UIKit.h>
#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "pingcooSDK.h"
@interface AdMoGoAdapterpingcooInterstitial : AdMoGoAdNetworkInterstitialAdapter<pingcooSDKDelegate>
{
    BOOL isStop;
    NSTimer *timer;
    pingcooSDK *pingcoo;
    BOOL isPresent;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
@end
