//
//  AdMoGoAdapterBaiduFullAds.h
//  TestV1.3.1
//
//  Created by wang hao on 13-9-17.
//
//

#import <UIKit/UIKit.h>
#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "BaiduMobAdInterstitial.h"
@interface AdMoGoAdapterBaiduFullAds : AdMoGoAdNetworkInterstitialAdapter<BaiduMobAdInterstitialDelegate>
{
    BaiduMobAdInterstitial *baiduInterstitial;
    BOOL isLocationOn;
    NSTimer *timer;
    BOOL isStop;
}
+ (AdMoGoAdNetworkType)networkType;
@end
