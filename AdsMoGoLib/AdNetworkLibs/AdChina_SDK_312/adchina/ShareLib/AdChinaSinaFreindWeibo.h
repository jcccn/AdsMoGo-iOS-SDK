//
//  AdChinaSinaFreindWeibo.h
//  AdChinaSShareKit
//
//  Created by AdChina on 14-3-7.
//  Copyright (c) 2014年 Daxiong. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AdChinaSShareAdapterSinaWeibo.h"

@interface AdChinaSinaFreindWeibo : AdChinaSShareAdapterSinaWeibo


@property (nonatomic, strong) NSURLConnection *freindConnection;
@property (nonatomic, strong) UIViewController *parentController;

-(void)friendshipsCreateAccessToken;
@end
