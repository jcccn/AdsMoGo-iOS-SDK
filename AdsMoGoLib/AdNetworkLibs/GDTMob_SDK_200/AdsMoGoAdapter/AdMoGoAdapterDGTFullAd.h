//
//  AdMoGoAdapterDGTFullAd.h
//  wanghaotest
//
//  Created by Chasel on 14-2-24.
//
//

#import <Foundation/Foundation.h>
#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "GDTMobInterstitial.h"

@interface AdMoGoAdapterDGTFullAd : AdMoGoAdNetworkAdapter<GDTMobInterstitialDelegate>{
    NSTimer *timer;
    BOOL isStop;
    GDTMobInterstitial *_interstitialObj;
    BOOL isReady;
    BOOL canRemove;
}

@end
