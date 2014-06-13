//
//  AdMoGoAdapterIomarkBanner.h
//  wanghaotest
//
//  Created by mogo on 14-4-4.
//
//


#import "LomarkAdView.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoConfigData.h"

@interface AdMoGoAdapterlomarkBanner : AdMoGoAdNetworkAdapter<LomarkAdViewDelegate>{
    BOOL isStop;
    LomarkAdView *_bannerView;
    NSTimer *timer;
}

@end
