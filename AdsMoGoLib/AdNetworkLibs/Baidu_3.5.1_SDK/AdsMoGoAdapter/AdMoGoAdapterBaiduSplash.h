//
//  AdMoGoAdapterBaiduSplash.h
//  wanghaotest
//
//  Created by mogo on 13-11-15.
//
//


#import "AdMoGoAdNetworkAdapter.h"
#import "BaiduMobAdInterstitial.h"
@interface AdMoGoAdapterBaiduSplash : AdMoGoAdNetworkAdapter<BaiduMobAdInterstitialDelegate>
{
    BaiduMobAdInterstitial *baiduSplash;
    BOOL isLocationOn;
    NSTimer *timer;
    BOOL isFail;
    BOOL isSuccess;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
- (void)loadAdTimeOut:(NSTimer*)theTimer;

@end
