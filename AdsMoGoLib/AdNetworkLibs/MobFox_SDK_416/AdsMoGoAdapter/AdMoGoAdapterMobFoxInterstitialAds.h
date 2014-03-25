//
//  AdMoGoAdapterMobFoxInterstitialAds.h
//  wanghaotest
//
//  Created by MOGO on 13-7-18.
//
//

#import <MobFox/MobFoxVideoInterstitialViewController.h>
#import "AdMoGoAdNetworkAdapter.h"
@interface AdMoGoAdapterMobFoxInterstitialAds : AdMoGoAdNetworkAdapter<MobFoxVideoInterstitialViewControllerDelegate>
{
    MobFoxVideoInterstitialViewController *interstitialViewController;
    NSString *requestURL;
    NSString *publisherID;
    NSTimer *timer;
    BOOL isStop;
    BOOL isStopTimer;
    BOOL isReady;
    MobFoxAdType _advertType;
    UIView *mainView;
}
+ (AdMoGoAdNetworkType)networkType;
@end
