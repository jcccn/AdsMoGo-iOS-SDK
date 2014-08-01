//
//  AdMoGoAdapterAdvertSplash.h
//  wanghaotest
//
//  Created by Chasel on 4/23/14.
//
//

#import <Foundation/Foundation.h>
#import "BOADInterstitial.h"
#import "AdMoGoAdNetworkAdapter.h"
@interface AdMoGoAdapterAdvertSplash : AdMoGoAdNetworkAdapter<BOADInterstitialDelegate>
{
    BOADInterstitial *intersti;    
    BOOL isStop;
    NSTimer *timer;
    BOOL isLoaded;
    BOOL isFail;
    BOOL isSuccess;
    UIViewController *baseViewController;
}
+ (AdMoGoAdNetworkType)networkType;
@end
