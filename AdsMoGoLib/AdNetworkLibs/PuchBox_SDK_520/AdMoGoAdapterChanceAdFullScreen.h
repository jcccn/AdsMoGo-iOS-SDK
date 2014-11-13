//
//  AdMoGoAdapterPuchBoxFullScreen.h
//  wanghaotest
//
//  Created by MOGO on 13-9-28.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "ChanceAd.h"
#import "CSInterstitial.h"
@interface AdMoGoAdapterChanceAdFullScreen : AdMoGoAdNetworkInterstitialAdapter
{
    NSTimer *timer;
    BOOL isReady;
    BOOL isFail;
    BOOL isClosed;
}
@end
