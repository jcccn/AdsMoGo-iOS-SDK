//
//  AdMoGoAdapterBaiduFullAds.h
//  TestV1.3.1
//
//  Created by wang hao on 13-9-17.
//
//

#import <UIKit/UIKit.h>
#import "AdMoGoAdNetworkAdapter.h"
#import "BaiduMobAdInterstitial.h"
@interface AdMoGoAdapterBaiduFullAds : AdMoGoAdNetworkAdapter<BaiduMobAdInterstitialDelegate>
{
    BaiduMobAdInterstitial *baiduInterstitial;
    BOOL isLocationOn;
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;
@end
