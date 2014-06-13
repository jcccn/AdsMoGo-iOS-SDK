//
//  AdMoGoAdapterMillennialFullScreen.h
//  wanghaotest
//
//  Created by MOGO on 13-1-24.
//
//

#import "AdMoGoAdNetworkInterstitialAdapter.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "MMAdView.h"
#import "MMInterstitial.h"
@interface AdMoGoAdapterMillennialFullScreen : AdMoGoAdNetworkInterstitialAdapter  {
	NSMutableDictionary *requestData;
    
    MMAdView *fullAdView;
    NSTimer *timer;
    NSUInteger savedType;
    BOOL isStop;
    NSString *apID;
    BOOL isReady;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
@end