//
//  AdMoGoAdapterAdvertFullAd.h
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoConfigData.h"
#import "BTAdvertProtocol.h"
#import "BTAdvertFullScreen.h"
@interface AdMoGoAdapterAdvertFullAd : AdMoGoAdNetworkAdapter<BTAdvertProtocol>
{
    BOOL isStop;
    BTAdvertFullScreen *advertFullScreen;
    NSTimer *timer;
    BOOL isRequest;
    BOOL isStopTimer;
     BOOL isReady;
}
@end
