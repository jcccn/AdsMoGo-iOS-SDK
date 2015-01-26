//
//  YQLSDK.h
//  UITest
//
//  Created by Wen Yunlong on 14-8-8.
//  Copyright (c) 2014年 YuJie. All rights reserved.
//
#import "label_time.h"

#define DR_INSERSCREEN  3   //插播广告
#define DR_FULLSCREEN   4   //全屏广告
#define DR_BANNER       5   //BANNER

//初始化
/*
 key:applicationKey
 isuse:是否开启定位
 appuserid:用户提供的唯一标示, 推荐使用应用程序的用户名
 */
#define DR_INIT(key, isuse, userid) [YQLSDK dianruInitialize:key dianruLocation:isuse dianruAppuserid:userid];

//广告显示
#define DR_SHOW(type, view, dg) [YQLSDK dianruShow:type dianruOn:view dianruDelegate:dg];

//创建广告 param2:delegate
#define DR_CREATE(type, dg) [YQLSDK dianruCreate:type dianruDelegate:dg];

//取得积分
#define GETSCORE(score_block) [YQLSDK getDianruScore:score_block];

//消费积分
#define SPENDSCORE(sore,score_block) [YQLSDK getDianruSpendScore:sore dianruCallback:score_block];


@protocol YQLDelegate <NSObject>
@optional

/*
 请求广告条数
 如果广告条数大于0，那么code=0，代表成功
 反之code = -1
 */
- (void)dianruDidDataReceivedView:(UIView *)view dianruCode:(int)code;

/*
 广告弹出时回调
 */
- (void)dianruDidViewOpenView:(UIView *)view;

/*
 点击广告关闭按钮的回调，不代表广告从内存中释放
 */
- (void)dianruDidMainCloseView:(UIView *)view;

/*
 广告释放时回调，从内从中释放
 */
- (void)dianruDidViewCloseView:(UIView *)view;

/*
 曝光回调
 */
- (void)dianruDidReportedView:(UIView *)view dianruData:(id)data;

/*
 点击广告回调
 */
- (void)dianruDidClickedView:(UIView *)view dianruData:(id)data;

/*
 点击跳转回调
 */
- (void)dianruDidJumpedView:(UIView *)view dianruData:(id)data;

@end

typedef void (^dianruScoreResultCallback)(int result);
typedef void (^dianruSpendScoreResultCallback)(NSString *result);

@interface YQLSDK : NSObject<NSURLConnectionDelegate>

+(void)dianruInitialize:(NSString *)key dianruLocation:(BOOL)value dianruAppuserid:(NSString *)appuserid;
// 广告显示位置
+(void)dianruShow:(NSInteger)space dianruOn:(UIView *)view dianruDelegate:(id<YQLDelegate>)delegate;
//创建广告视图
+(void)dianruCreate:(NSInteger)space dianruDelegate:(id<YQLDelegate>)delegate;
//取得积分
+(void)getDianruScore:(dianruScoreResultCallback) score;
//消费积分
+(void)getDianruSpendScore:(int) point dianruCallback :(dianruSpendScoreResultCallback) score;
#pragma mark 获取积分/积分回调 callback ?

@end


