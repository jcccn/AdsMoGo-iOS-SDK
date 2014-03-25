//
//  AdMoGoAdapterAdvert.h
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdMoGoAdNetworkAdapter.h"
#import "BTAdvert.h"
#import "BTAdvertBannerStaticImage.h"
#import "BTAdvertBannerDynamicImage.h"

@interface AdMoGoAdapterAdvert : AdMoGoAdNetworkAdapter<BTAdvertProtocol>
{
    NSTimer *timer;
    BOOL isStop;
    BTAdvertBannerStaticImage *advertBanner;
    BOOL isSuccess;
    BOOL isFail;
}
@end
