//
//  TalkingDataSDK.h
//  TalkingData
//
//  Created by liweiqiang on 14-5-8.
//  Copyright (c) 2014年 TendCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TalkingDataSDK : NSObject

+ (void)init;
+ (void)initWithAppId:(NSString *)appId;
+ (void)initWithAppId:(NSString *)appId andChannelId:(NSString *)channelId;
+ (void)setSilentMode:(BOOL)val;

@end
