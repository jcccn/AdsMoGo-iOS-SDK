//
//  MdotMInterstitialAdView.h
//  MdotMiOSSDK2
//
//  Created by MdotM on 8/6/12.
//  Copyright (c) 2012 MdotM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MdotMInterstitialDelegate.h"
#import <UIKit/UIKit.h>

@class MdotMRequestParameters;
@interface MdotMInterstitial : NSObject<MdotMInterstitialDelegate> {
	
	id<MdotMInterstitialDelegate>		interstitialDelegate;
}
@property (nonatomic,assign) id<MdotMInterstitialDelegate>		interstitialDelegate;

-(BOOL)loadInterstitialAd:(MdotMRequestParameters *)request;
-(void) showInterstitial:(UIViewController *)viewController animated:(BOOL)animated;
@end
