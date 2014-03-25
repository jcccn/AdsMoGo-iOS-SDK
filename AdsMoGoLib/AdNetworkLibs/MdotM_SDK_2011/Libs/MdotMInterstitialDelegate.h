//
//  InterstitialProtocol.h
//  MdotMiOSSDK2
//
//  Created by MdotM on 8/6/12.
//  Copyright (c) 2012 MdotM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MdotMInterstitialDelegate <NSObject>
@optional
-(void) onReceiveInterstitialAd;
-(void) onReceiveInterstitialAdError:(NSString *)error;
-(void) onReceiveClickInInterstitialAd;
-(void) willShowModalViewController;
-(void) didShowModalViewController;
-(void) willDismissModalViewController;
-(void) didDismissModalViewController;
-(void) willLeaveApplication;
@end
