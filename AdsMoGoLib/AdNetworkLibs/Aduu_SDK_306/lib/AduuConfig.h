//
//  AduuConfig.h
//  NewAduu
//
//  Created by LingYun on 13-8-16.
//  Copyright (c) 2013年 LingYun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AduuBannerContentSizeIdentifierUnknow     = 0,
    AduuBannerContentSizeIdentifier320x50     = 1, // iPhone and iPod Touch ad size
    AduuBannerContentSizeIdentifier320x480    = 2, // Full Banner size for the iPhone
    AduuBannerContentSizeIdentifier728x90     = 3, // iPad size
    AduuBannerContentSizeIdentifier400x400    = 4,
    AduuBannerContentSizeIdentifier300x250    = 5,
    AduuBannerContentSizeIdentifier600x500    = 6
}AduuBannerContentSizeIdentifier;


@interface AduuConfig : NSObject

/**
 *	注册广告
 *
 *	@param	appid	http://www.aduu.cn/中注册
 *	@param	appsecret	http://www.aduu.cn/中注册
 *	@param	channelid	应用发布对应的市场名字例如:AppStore则为appstore
 */
+ (void)launchWithAppID:(NSString *)appid appSecret:(NSString *)appsecret channelID:(NSString *)channelid;

@end
