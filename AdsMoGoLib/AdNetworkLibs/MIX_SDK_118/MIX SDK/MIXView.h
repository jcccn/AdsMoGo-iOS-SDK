//
//  MIXView.h
//  GuoHeMixiOSDev
//
//  Created by Lynn Woo on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "MIXViewDelegate.h"

@interface MIXView : UIView <UIWebViewDelegate>


+ (MIXView *)initWithID:(NSString *)adUnitId setTestMode:(BOOL)testFlag;
+ (void)showAdWithDelegate:(id)delegate viewController:(UIViewController *)viewController;
+ (void)showAdWithDelegate:(id)delegate;
+ (void)showAdWithDelegate:(id)delegate withPlace:(NSString *)place;
+ (void)showAdWithDelegate:(id)delegate withPlace:(NSString *)place viewController:(UIViewController *)parentViewController;
+ (void)dismissAd;
+ (BOOL)canServeAd:(NSString *)place;

@end
