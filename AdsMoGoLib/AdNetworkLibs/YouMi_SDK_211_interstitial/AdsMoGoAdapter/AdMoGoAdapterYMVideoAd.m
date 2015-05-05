//
//  AdMoGoAdapterYMVideoAdAPI.m
//  wanghaotest
//
//  Created by Castiel Chen on 15/3/9.
//
//

#import "AdMoGoAdapterYMVideoAd.h"
#import "CocoBVideo.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
#import "YouMiNewSpot.h"
#import "AdMoGoAdSDKInterstitialNetworkRegistry.h"
@interface AdMoGoAdapterYMVideoAd ()
{
    BOOL isReady;
}
@end

@implementation AdMoGoAdapterYMVideoAd


+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeYM;
}

+ (void)load{
    [[AdMoGoAdAPIVideoNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isReady=NO;
    
 [self adapter:self didReceiveInterstitialScreenAd:nil];
}

- (BOOL)isReadyPresentInterstitial{
    return YES;
}
-(void)playVideoAd{
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
    AdViewType type =[configData.ad_type intValue];
    NSString *AppID = @"";
    NSString *AppSecret = @"";
    
    if (type ==AdViewTypeVideo) {
        id key = [self.ration objectForKey:@"key"];
        
        if ([key isKindOfClass:[NSDictionary class]]) {
            AppID  = [key objectForKey:@"AppID"];
            AppSecret = [key objectForKey:@"AppSecret"];
        }
        else{
            [self adapter:self didFailAd:nil];
            return;
        }
    }
    [CocoBVideo cBVideoInitWithAppID:AppID cBVideoAppIDSecret:AppSecret];
    UIViewController *viewController = [self rootViewControllerForPresent];
    [self adapter:self didShowAd:nil];
    
    [CocoBVideo cBVideoPlay:viewController cBVideoPlayFinishCallBackBlock:^(BOOL isFinishPlay){
        [self adapter:self didDismissScreen:nil];
    } cBVideoPlayConfigCallBackBlock:^(BOOL isLegal){
    
    }];
    
    [CocoBVideo cBIsHaveVideo:^(int isHaveVideoStatue){
        if (isHaveVideoStatue==2) {
            [self adapter:self didFailAd:nil];
        }
    }];

    
}

- (void)stopBeingDelegate{
    
}


- (void)dealloc{
    [super dealloc];
}


@end
