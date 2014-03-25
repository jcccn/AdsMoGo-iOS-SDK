//
//  WapsWAdRequestHandler.h
//  WapsOfferLib
//
//  Created by guang on 12-12-18.
//  Copyright (c) 2012年 celles.cn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WapsCoreFetcherHandler.h"
#import "AppConnect.h"

@interface WapsWAdRequestHandler : WapsCoreFetcherHandler <WapsWebFetcherDelegate>
{
    UIViewController * viewController_;
}

@property (nonatomic) UIViewController * viewController;

- (id)initRequestWithDelegate:(id <WapsFetchResponseDelegate>)aDelegate andRequestTag:(int)aTag;
- (void)initADWithVersion:(NSString *)popVersion;
- (void)getPopAd:(UIViewController*)controller;

@end
