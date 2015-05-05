//
//  AdMoGoAdapterBaiduSplash.h
//  wanghaotest
//
//  Created by mogo on 13-11-15.
//
//


#import "AdMoGoAdNetworkAdapter.h"
#import "BaiduMobAdSplashDelegate.h"
@class BaiduMobAdSplash;
@interface AdMoGoAdapterBaiduSplash : AdMoGoAdNetworkAdapter<BaiduMobAdSplashDelegate>
{
    BaiduMobAdSplash *splash;
    BOOL isLocationOn;
    NSTimer *timer;
    BOOL isFail;
    BOOL isSuccess;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
- (void)loadAdTimeOut:(NSTimer*)theTimer;

@end
