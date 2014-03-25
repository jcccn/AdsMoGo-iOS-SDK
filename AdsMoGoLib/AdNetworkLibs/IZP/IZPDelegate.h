//
//  IZPDelegate.h
//  TestADExchange
//
//  Created by quan zheng on 11-5-10.
//  Copyright 2011年 Jinuoxun Technology Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
@class IZPView;

@protocol IZPDelegate <NSObject>
@optional


/* 是否请求一条广告
 *
 * 详解：默认是请求一条广告，如果返回是fasle 则不请求广告，SDK会定时调用该函数
 */
-(BOOL)shouldRequestFreshAd:(IZPView*)view;


/*
 *成功请求到一则广告
 *
 *详解:count代表请求到第几条广告，从1开始，累加计数
 */
- (void)didReceiveFreshAd:(IZPView*)view adCount:(NSInteger)count;




/* 是否显示请求到的广告
 *
 * 详解：默认是显示，如果返回是fasle 则不显示，SDK会定时调用该函数
 */
-(BOOL)shouldShowFreshAd:(IZPView*)view;


/*
 *新的广告已经成功显示了
 *
 */
-(void)didShowFreshAd:(IZPView*)view;


/*
 *错误报告
 * 
 *详解:code 是错误代码  info是对错误的说明
 * 1：系统错误 2：参数错误 3：接口不存在 4：应用被冻结 5：无合适广告 6：应用用户不存在  100：没有产品id  101:没有广告类型 102:参数已经设置了 103:请求广告时无法建立连接 104：请求广告时发生连接错误 105：解析广告出错 106：没能成功请求到广告资源  107:请求配置参数失败 108:广告没有成功显示 109:广告没有正确放置
 */
- (void) errorReport:(NSInteger)code erroInfo:(NSString*) info;



/*
 *
 *用户点击广告后将切换到浏览器
 *
 */
- (void)willLeaveApplication:(IZPView*)view;


/*用户停止贴片广告
 *
 *详解:在显示全屁贴片广告的时候，当用户点击了跳过按钮时候，调用此方法。此时广告请求已经停止，
 *
 */
- (void)didStopFullScreenAd:(IZPView*)view;

@end
