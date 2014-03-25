//
//  AdMoGoAdapterGuomob.h
//  TestMOGOSDKAPP
//
//  Created by mogo_wenyand on 13-4-10.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "GuomobAdSDK.h"

@interface AdMoGoAdapterGuomob : AdMoGoAdNetworkAdapter<GuomobAdSDKDelegate>{
    NSTimer *timer;
    BOOL isStop;
    GuomobAdSDK *adView;
    BOOL isSuccess;
    BOOL isFail;
}

+ (AdMoGoAdNetworkType)networkType;


@end
