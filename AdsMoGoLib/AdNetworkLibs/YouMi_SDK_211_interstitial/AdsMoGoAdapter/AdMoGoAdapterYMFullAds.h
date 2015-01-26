//
//  AdMoGoAdapterYouMiFullAds.h
//  __DARREN__
//
//  Created by Darren Liu on 14-08-06.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "symbols_spotconfuse.h"
#import "YouMiNewSpot.h"

@interface AdMoGoAdapterYMFullAds : AdMoGoAdNetworkInterstitialAdapter{
    YouMiNewSpot *youMiNewSpot;
    BOOL isStop;
    NSTimer *timer;
    BOOL isReady;
}

+ (AdMoGoAdNetworkType)networkType;
@end
