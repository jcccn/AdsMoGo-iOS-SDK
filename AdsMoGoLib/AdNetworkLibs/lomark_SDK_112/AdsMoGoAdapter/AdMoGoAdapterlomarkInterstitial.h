//
//  AdMoGoAdapterlomarkInterstitial.h
//  wanghaotest
//
//  Created by mogo on 14-4-4.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "LomarkAdView.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoConfigData.h"
@interface AdMoGoAdapterlomarkInterstitial : AdMoGoAdNetworkInterstitialAdapter<LomarkAdViewDelegate>
{
    BOOL isStop;
    NSTimer *timer;
    BOOL isLoaded;
    LomarkAdView *_fwView;
}
@end
