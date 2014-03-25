//
//  AdMoGoAdapterMobFox.h
//  wanghaotest
//
//  Created by MOGO on 13-7-18.
//
//
#import <MobFox/MobFox.h>
#import <MobFox/MobFoxBannerView.h>
#import "AdMoGoAdNetworkAdapter.h"

@interface AdMoGoAdapterMobFox : AdMoGoAdNetworkAdapter<MobFoxBannerViewDelegate>
{
    MobFoxBannerView *bannerView;
    NSString *requestURL;
    NSString *publisherID;
    NSTimer *timer;
    BOOL isStop;
    BOOL isStopTimer;
}
+ (AdMoGoAdNetworkType)networkType;
@end
