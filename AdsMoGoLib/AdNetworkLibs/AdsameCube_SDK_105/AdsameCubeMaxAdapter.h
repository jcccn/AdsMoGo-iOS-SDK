//
//  AdsameCubeMaxAdapter.h
//  wanghaotest
//
//  Created by mogo on 14-2-20.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import <AdsameCubeMaxSDK/AdsameCubeMaxSDK.h>

@interface AdsameCubeMaxAdapter : AdMoGoAdNetworkAdapter<AdsameCubeMaxDelegate>
{
    NSTimer *timer;
    BOOL isloadfail;
    BOOL isStop;
    BOOL isSuccess;
}
@end
