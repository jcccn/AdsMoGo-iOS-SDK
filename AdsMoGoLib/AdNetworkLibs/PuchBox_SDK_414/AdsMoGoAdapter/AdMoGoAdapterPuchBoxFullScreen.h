//
//  AdMoGoAdapterPuchBoxFullScreen.h
//  wanghaotest
//
//  Created by MOGO on 13-9-28.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdapterPuchBox.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "PunchBoxAd.h"
#import "PBInterstitial.h"
@interface AdMoGoAdapterPuchBoxFullScreen : AdMoGoAdNetworkInterstitialAdapter
{
    NSTimer *timer;
    BOOL isReady;
    BOOL isFail;
    BOOL isClosed;
}
@end
