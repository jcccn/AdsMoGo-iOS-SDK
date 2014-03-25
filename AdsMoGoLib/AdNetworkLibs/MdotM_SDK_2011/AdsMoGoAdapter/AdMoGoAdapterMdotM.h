
#import "AdMoGoAdNetworkAdapter.h"
#import "MdotMAdViewDelegate.h"
#import "MdotMAdView.h"
#import "MdotMRequestParameters.h"

@interface AdMoGoAdapterMdotM : AdMoGoAdNetworkAdapter <MdotMAdViewDelegate> {
    
    BOOL isStop;
    
    MdotMAdView *adView;
    
    MdotMRequestParameters *requestParameters;
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
@end
