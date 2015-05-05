//
//  AdsMoGoNativeDelegate.h
//  AdsMoGoNative
//
//  Created by MOGO on 15-1-4.
//  Copyright (c) 2015年 MOGO. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AdsMoGoNativeDelegate <NSObject>
- (UIViewController *)viewControllerForPresentingModalView;
- (void)requestNativeAdSuccess:(NSArray *)adsmogonativeadlist;
- (void)requestNativeAdFail:(int) errorCode;
@end
