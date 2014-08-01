//
//  NSObject+ShareByDict.h
//  Sample
//
//  Created by donson on 14-4-2.
//  Copyright (c) 2014年 donson. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kWBAppKey         @"1665013266"
#define kRedirectURI      @"https://api.weibo.com/oauth2/default.html"
#define kWXAppKey         @"wxd0dd3021efaf3cd4"

#import "WXApi.h"
#import "WeiboSDK.h"

@interface NSObject (ShareByDict)

- (void)ShareByDict:(NSDictionary *)infoDict;

@end
