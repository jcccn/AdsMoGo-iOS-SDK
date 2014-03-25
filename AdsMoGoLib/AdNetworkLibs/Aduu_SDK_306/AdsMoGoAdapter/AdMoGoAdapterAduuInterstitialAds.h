//
//  AdMoGoAdapterAduuInterstitialAds.h
//  wanghaotest
//
//  Created by mogo_wenyand on 13-7-4.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "AduuInsertAd.h"
#import "AduuConfig.h"
@interface AdMoGoAdapterAduuInterstitialAds : AdMoGoAdNetworkAdapter<AduuInsertAdDelegate>
{
    BOOL isStop;
    NSTimer *timer;
    AduuInsertAd *insertAd;
    BOOL isReady;
    CGAffineTransform inittransform;
    BOOL isStopTimer;
}
+ (AdMoGoAdNetworkType)networkType;
@end
