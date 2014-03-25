//
//  AdShareContext.h
//  AdChinaSDK3
//
//  Created by AdChina on 14-3-11.
//  Copyright (c) 2014年 AdChina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdShareContext : NSObject
@property(copy,nonatomic) NSString *title;
@property(copy,nonatomic) NSString *detail;
@property(copy,nonatomic) NSString *ctype;
@property(copy,nonatomic) NSString *conturl;
@property(copy,nonatomic) NSString *thumbnail;
@property(copy,nonatomic) NSString *clickUrl;
@end