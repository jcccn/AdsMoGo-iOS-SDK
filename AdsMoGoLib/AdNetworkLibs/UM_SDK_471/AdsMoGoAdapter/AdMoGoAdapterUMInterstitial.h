//
//  AdMoGoAdapterUMInterstitial.h
//  CTAdsMogoSample
//
//  Created by Chasel on 14-3-19.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import "AdMoGoAdNetworkAdapter.h"
#import "UMUFPDialog.h"
@interface AdMoGoAdapterUMInterstitial :  AdMoGoAdNetworkAdapter<UMUFPDialogDelegate>
{
    UMUFPDialog *dialog;
    NSTimer *timer;
    BOOL isStop;
    BOOL isReady;
    BOOL isSuccess;
    BOOL isFail;
}

@end
