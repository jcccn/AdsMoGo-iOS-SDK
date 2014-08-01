//
//  BOAD.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-3-26.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#define BOADLog(f, ...) [BOAD log:NSStringFromSelector(_cmd) line:__LINE__ format:(f), ##__VA_ARGS__]

/**
 *  广告请求的可选参数和SDK相关方法。
 */
@interface BOAD : NSObject

/**
 *!!!广告开始请求前调用。
 *  设置全局的应用ID和应用密钥，调用此方法设置后，其他地方不需要重复设置。
 *
 *  @param appId     广告后台分配的应用ID
 *  @param appScrect 广告后台分配的应用密钥
 */
+ (void)setAppId:(NSString *)appId appScrect:(NSString *)appScrect;

/**
 *!!!广告开始请求前调用。
 *  设置经纬度，用于更精确显示与用户地理位置相关的广告。
 *
 *  @param longitude 经度
 *  @param latitude  纬度
 */
+ (void)setLocationWithLongitude:(CGFloat)longitude latitude:(CGFloat)latitude;

/**
 *  设置是否打开SDK日志信息，默认不开启。
 *
 *  @param enabled 设置YES开启
 */
+ (void)setLogEnabled:(BOOL)enabled;

/**
 *  打印日志。
 *
 *  @param selector 选择器
 *  @param line     行
 *  @param format   格式化日志
 */
+ (void)log:(NSString *)selector line:(NSUInteger)line format:(NSString *)format, ...;

/**
 *  返回SDK版本号。
 *
 *  @return sdk version
 */
+ (NSString *)sdkVersion;

@end
