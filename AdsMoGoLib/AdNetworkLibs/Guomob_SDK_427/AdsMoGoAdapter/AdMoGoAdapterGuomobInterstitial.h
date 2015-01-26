//
//  AdMoGoAdapterGuomobInterstitial.h
//  wanghaotest
//
//  Created by MOGO on 13-9-27.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "GMInterstitialAD.h"
@interface AdMoGoAdapterGuomobInterstitial : AdMoGoAdNetworkInterstitialAdapter<GMInterstitialDelegate>
{
    GMInterstitialAD *interstitialAD;
    NSTimer *timer;
    BOOL isStop;
    BOOL isReady;
    BOOL isSuccess;
    BOOL isFail;
}
@end
