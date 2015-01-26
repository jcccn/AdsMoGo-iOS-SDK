//
//  RmobSDK.h
//  Rmob-SDK
//
//  Copyright (c) 2012年 renren. All rights reserved.
//
#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, Mode) {
    ModeTest = 0,
    ModeRelease = 1
};

@interface RmobSDK : NSObject

//启动广告服务程序，启动后将轮询调度广告展示，此服务只启动一次
+ (void)startAdService:(UIView *)_parentView appID:(NSString *)appID adzoneid:(NSString *)adzoneid adFrame:(CGRect)frame mode:(Mode)mode;

//暂停或继续广告服务程序(pause为YES执行暂停，pause为NO执行继续)
+ (void)pauseAdService:(BOOL)pause;

//停止广告服务程序、移除广告、释放内存，需重新启动广告服务程序才能显示广告
+ (void)stopAdService;

//设置委托，接收SDK反馈
+ (void)setDelegate:(id)delegate;

//重新设置AdsView坐标
+ (void)setAdsViewPoint:(CGPoint)point;

//获取当前SDK版本号
+ (NSString *)getCurrentVersion;
@end
