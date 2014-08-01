//
//  AdMoGoAdapterMobiSageSplash.h
//  wanghaotest
//
//  Created by mogo on 14-2-24.
//
//

#import "AdMoGoAdNetworkAdapter.h"

#import "MobiSageSDK.h"
@interface AdMoGoAdapterMobiSageSplash : AdMoGoAdNetworkAdapter<MobiSageSplashDelegate>
{
    BOOL isStop;
    NSTimer *timer;
    BOOL isLoaded;
    BOOL isFail;
    BOOL isSuccess;
    MobiSageRTSplash *mobiSageAdSplash;
}
@end
