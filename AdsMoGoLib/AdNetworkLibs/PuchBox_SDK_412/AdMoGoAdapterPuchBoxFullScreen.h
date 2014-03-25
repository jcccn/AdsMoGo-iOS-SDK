//
//  AdMoGoAdapterPuchBoxFullScreen.h
//  wanghaotest
//
//  Created by MOGO on 13-9-28.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "PunchBoxAd.h"
#import "PBInterstitial.h"
@interface AdMoGoAdapterPuchBoxFullScreen : AdMoGoAdNetworkAdapter<PBInterstitialDelegate>
{
    NSTimer *timer;
    BOOL isReady;
    BOOL isFail;
    BOOL isClosed;
}
@end
