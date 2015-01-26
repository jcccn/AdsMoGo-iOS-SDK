//
//  AdMoGoAdapterAdvert.h
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdMoGoAdNetworkAdapter.h"
#import "BOAD.h"
#import "BOADBannerView.h"

@interface AdMoGoAdapterAdvert : AdMoGoAdNetworkAdapter<BOADBannerViewDelegate>
{
    NSTimer *timer;
    BOOL isStop;
    BOADBannerView *bannerView;
    BOOL isSuccess;
    BOOL isFail;
}
@end
