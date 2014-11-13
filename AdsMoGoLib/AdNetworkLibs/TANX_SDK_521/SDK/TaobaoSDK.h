//
//  TaobaoSDK.h
//  UFP
//
//  Created by yuandao.yz on 14-2-12.
//  Copyright (c) 2014年 Realcent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaobaoSDK : NSObject

+ (BOOL)handleOpenUrl:(NSURL *) url;
+ (void)initWithAppkey:(NSString *)appkey appSecret:(NSString *)appsecret callback:(NSString *)callback;

+(TaobaoSDK *)sharedInstance;

@end
