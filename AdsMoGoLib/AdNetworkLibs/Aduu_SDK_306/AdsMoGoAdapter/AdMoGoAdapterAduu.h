//
//  AdMoGoAdapterAduu.h
//  wanghaotest
//
//  Created by mogo_wenyand on 13-7-3.
//
//

#import "AdMoGoAdNetworkAdapter.h"
#import "AduuView.h"

@interface AdMoGoAdapterAduu : AdMoGoAdNetworkAdapter<AduuDelegate>
{
    NSTimer *timer;
    AduuView * banner;
    BOOL isRevice;
    BOOL isStopTimer;
}
@end
