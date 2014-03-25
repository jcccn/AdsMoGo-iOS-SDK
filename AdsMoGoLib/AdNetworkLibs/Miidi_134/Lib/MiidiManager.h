//
//  MiidiManager.h
//  MiidiAd
//
//  Created by adpooh miidi on 12-2-15.
//  Copyright 2012 miidi. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface MiidiManager : NSObject 

// 设置发布应用的应用id, 应用密码等信息,必须在应用启动的时候呼叫
// 参数 appID		:开发者应用ID ;     开发者到 www.miidi.net 上提交应用时候,获取id和密码
// 参数 appPassword	:开发者的安全密钥 ;  开发者到 www.miidi.net 上提交应用时候,获取id和密码
// 参数 testMode		:广告条请求模式 ;    正式发布应用,务必设置为NO,否则不能计费
+(void) setAppPublisher:(NSString*) appID withAppSecret:(NSString*)appPassword withTestMode:(BOOL) testMode;

// 应用发布的渠道号
// 详解:该参数主要给推广该应用的时候，打包的渠道号
+(void) setMarketChannelID:(NSInteger) channelID;

// 获取Miidi广告IOS 版本号
+(NSString*) getMiidiSdkVersion;

@end
