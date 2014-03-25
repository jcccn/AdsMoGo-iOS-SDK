//
//  AdMoGoAdapterGuomobInterstitial.h
//  wanghaotest
//
//  Created by MOGO on 13-9-27.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "GMInterstitialAD.h"
@interface AdMoGoAdapterGuomobInterstitial : AdMoGoAdNetworkAdapter<GMInterstitialDelegate>
{
    GMInterstitialAD *interstitialAD;
    NSTimer *timer;
    BOOL isStop;
    BOOL isReady;
    BOOL isSuccess;
    BOOL isFail;
}
@end
