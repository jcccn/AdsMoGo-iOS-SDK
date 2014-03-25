//
//  AdMoGoAdapterMiidi.h
//  TestMOGOSDKAPP
//
//  Created by 孟令之 on 13-1-11.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "MiidiAdView.h"
#import "MiidiAdViewDelegate.h"

@interface AdMoGoAdapterMiidi :AdMoGoAdNetworkAdapter<MiidiAdViewDelegate>
{
    NSTimer *timer;
    MiidiAdView *adMiidiView;
    BOOL isStop;
}
- (void)loadAdTimeOut:(NSTimer*)theTimer;
+ (AdMoGoAdNetworkType)networkType;
@end
