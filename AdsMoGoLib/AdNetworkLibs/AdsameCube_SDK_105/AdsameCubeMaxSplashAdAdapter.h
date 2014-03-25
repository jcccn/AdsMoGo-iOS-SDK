//
//  AdsameCubeMaxSplashAdAdapter.h
//  wanghaotest
//
//  Created by mogo on 14-2-24.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import <AdsameCubeMaxSDK/AdsameCubeMaxSDK.h>

@interface AdsameCubeMaxSplashAdAdapter : AdMoGoAdNetworkAdapter<AdsameCubeMaxDelegate>{

    
    BOOL isStop;
    NSTimer *timer;
    BOOL isLoaded;
    BOOL isFail;
    BOOL isSuccess;
}

@end
