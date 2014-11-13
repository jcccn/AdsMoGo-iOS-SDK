//
//  UserMessage.h
//  InsetDemo
//
//  Created by emaryjf on 13-1-25.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HMUserMessage : NSObject


@property (nonatomic,copy) NSString *hmUserAppId;
@property (nonatomic,copy) NSString *hmChannel;
@property (nonatomic,copy) NSString *hmUserDevId;
@property (nonatomic,copy) NSString *hmAppKey;
@property (nonatomic,copy) NSString *hmCoop_info;

@property (nonatomic,copy) NSString *hmSid;

+ (HMUserMessage *)shareInstance;

@end
