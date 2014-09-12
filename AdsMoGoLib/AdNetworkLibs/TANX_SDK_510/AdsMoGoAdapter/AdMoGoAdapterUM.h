//
//  AdMoGoAdapterUM.h
//  Project: AdsMOGO iOS SDK
//  Version: 1.5.0


#import "AdMoGoAdNetworkAdapter.h"
#import "MMUBannerView.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoConfigDataCenter.h"

@interface AdMoGoAdapterUM : AdMoGoAdNetworkAdapter<MMUBannerViewDelegate> {
    AdMoGoConfigData *configData;
    MMUBannerView *adView;
    BOOL isStop;
    NSTimer *timer;
}
+ (AdMoGoAdNetworkType)networkType;
//+ (NSDictionary *)networkType;
@end
