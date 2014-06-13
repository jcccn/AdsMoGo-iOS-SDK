//
//  PBOfferWall.h
//  PBADSDK
//
//  Created by CocoaChina_yangjh on 13-11-12.
//  Copyright (c) 2013年 CocoaChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "PBADRequest.h"
#import "PBRequestError.h"

@protocol PBOfferWallDelegate;

@interface PBOfferWall : NSObject

// 是否准备好
@property (nonatomic, readonly) BOOL isReady;

// 支持的方向
@property (nonatomic, assign) PBOrientationSupported orientationSupported;
// 释放PBOfferWall前，必须将delegate设置为nil。
@property (nonatomic, assign) id <PBOfferWallDelegate> delegate;

// 积分墙只有一个
+ (PBOfferWall *)sharedOfferWall;

/**
 *	@brief	查询积分。
 *
 *  注意：查询前须设置delegate并实现相当协议方法
 */
- (void)queryRewardCoin;

/**
 *	@brief	加载积分墙数据
 *
 *	@param 	pbRequest 	请求积分墙时的参数
 */
- (void)loadOfferWall:(PBADRequest *)pbRequest;

/**
 *	@brief	显示积分墙
 *
 *	@param 	scale 	显示比例
 *
 *	@return	是否能展现出来
 */
- (BOOL)showOfferWallWithScale:(CGFloat)scale;

/**
 *	@brief	显示积分墙
 *
 *	@param 	rootView 	积分墙的父视图
 *	@param 	scale 	显示比例
 *
 *	@return	是否能展现出来
 */
- (BOOL)showOfferWallOnRootView:(UIView *)rootView withScale:(CGFloat)scale;


/**
 *	@brief	关闭积分墙
 */
- (void)closeOfferWall;

@end


@protocol PBOfferWallDelegate <NSObject>

/**
 *	@brief	用户完成积分墙任务的回调
 *
 *	@param 	pbOfferWall 	pbOfferWall
 *	@param 	taskCoins 	taskCoins中的元素为NSDictionary类型（taskCoins为空表示无积分返回，为nil表示查询出错）
 *                            键值说明：taskContent  NSString   任务名称
 //                                   coins        NSNumber    赚得金币数量
 *	@param 	error 	taskCoins为nil时有效，查询失败原因
 */
- (void)pbOfferWall:(PBOfferWall *)pbOfferWall queryResult:(NSArray *)taskCoins
          withError:(NSError *)error;


@optional

// 积分墙加载完成
- (void)pbOfferWallDidLoadAd:(PBOfferWall *)pbOfferWall;

// 积分墙加载错误
- (void)pbOfferWall:(PBOfferWall *)pbOfferWall
loadAdFailureWithError:(PBRequestError *)requestError;

// 积分墙打开完成
- (void)pbOfferWallDidPresentScreen:(PBOfferWall *)pbOfferWall;

// 积分墙将要关闭
- (void)pbOfferWallWillDismissScreen:(PBOfferWall *)pbOfferWall;

// 积分墙关闭完成
- (void)pbOfferWallDidDismissScreen:(PBOfferWall *)pbOfferWall;

@end
