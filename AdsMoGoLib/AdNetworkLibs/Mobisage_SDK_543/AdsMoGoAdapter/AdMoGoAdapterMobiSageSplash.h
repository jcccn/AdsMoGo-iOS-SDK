//
//  AdMoGoAdapterMobiSageSplash.h
//  wanghaotest
//
//  Created by mogo on 14-2-24.
//
//

#import "AdMoGoAdNetworkAdapter.h"

#import "MobiSageSDK.h"
@interface AdMoGoAdapterMobiSageSplash : AdMoGoAdNetworkAdapter<MobiSageAdSplashDelegate>
{
    BOOL isStop;
    NSTimer *timer;
    BOOL isLoaded;
    BOOL isFail;
    BOOL isSuccess;
    MobiSageAdSplash *mobiSageAdSplash;
}
@end
