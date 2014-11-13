//
//  AdMoGoAdapterPuchBox.h
//  wanghaotest
//
//  Created by MOGO on 14-9-29.
//
//
#import "AdMoGoAdNetworkAdapter.h"
#import "ChanceAd.h"
#import "CSBannerView.h"
static BOOL startedSession = NO;
@interface AdMoGoAdapterChance : AdMoGoAdNetworkAdapter<CSBannerViewDelegate>
{
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;
@end
