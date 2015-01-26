//
//  AdViewProtocol.h
//  MdotMiOSSDK2
//
//  Created by MdotM on 8/6/12.
//  Copyright (c) 2012 MdotM. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MdotMAdViewDelegate <NSObject>
@optional
-(void) onReceiveBannerAd;
-(void) onReceiveBannerAdError:(NSString *)error;
-(void) onReceiveClickInBannerAd;
-(void) adWillLeaveApplication;
@end
