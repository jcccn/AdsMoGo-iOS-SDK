//
//  AdMoGoAdapterZmedia.h
//  wanghaotest
//
//  Created by mogo on 14-7-28.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "ZMSDK.h"
#import "ZmediaSingleton.h"
@interface AdMoGoAdapterZmedia : AdMoGoAdNetworkAdapter<ZmediaSingletonDelegate>{
    UIWebView *adView;
    NSTimer *timer;
    BOOL isStopTimer;
    BOOL isStop;
    BOOL isSuccess;
    BOOL isFail;
}
+ (AdMoGoAdNetworkType)networkType;
- (void)loadAdTimeOut:(NSTimer*)theTimer;
@end
