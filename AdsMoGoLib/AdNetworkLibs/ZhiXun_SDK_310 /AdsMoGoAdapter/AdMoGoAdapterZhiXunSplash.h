//
//  AdMoGoAdapterZhiXunSplash.h
//  wanghaotest
//
//  Created by mogo on 14-2-25.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "AdSplashController.h"
@interface AdMoGoAdapterZhiXunSplash : AdMoGoAdNetworkAdapter{
    BOOL isStop;
    NSTimer *timer;
    BOOL isLoaded;
    BOOL isFail;
    BOOL isSuccess;
}

@end
