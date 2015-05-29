//
//  IndependentVideoVideoManager.h
//  IndependentVideoSDK
//
//  Created by Domob on 8/8/14.
//  Copyright (c) 2014 domob. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 *  消费结果状态码
 *  IndependentVideoConsumeStatus
 */
typedef enum {
    
    /**
     *  消费成功
     *  Consume Successfully
     */
    eIndependentVideoConsumeSuccess = 1,
    /**
     *  剩余积分不足
     *  Not enough point
     */
    eIndependentVideoConsumeInsufficient,
    /**
     *  订单重复
     *  Duplicate consume order
     */
    eIndependentVideoConsumeDuplicateOrder
} IndependentVideoConsumeStatus;

@class IndependentVideoManager;

@protocol IndependentVideoManagerDelegate <NSObject>
@optional
#pragma mark - independent video present callback 视频广告展现回调

/**
 *  开始加载数据。
 *  Independent video starts to fetch info.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidStartLoad:(IndependentVideoManager *)manager;
/**
 *  加载完成。
 *  Fetching independent video successfully.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidFinishLoad:(IndependentVideoManager *)manager;
/**
 *  加载失败。可能的原因由error部分提供，例如网络连接失败、被禁用等。
 *   Failed to load independent video.
 
 *
 *  @param manager IndependentVideoManager
 *  @param error   error
 */
- (void)ivManager:(IndependentVideoManager *)manager
failedLoadWithError:(NSError *)error;
/**
 *  被呈现出来时，回调该方法。
 *  Called when independent video will be presented.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerWillPresent:(IndependentVideoManager *)manager;
/**
 *  页面关闭。
 *  Independent video closed.
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerDidClosed:(IndependentVideoManager *)manager;
/**
 *  当视频播放完成后，回调该方法。
 *  Independent video complete play
 *
 *  @param manager IndependentVideoManager
 */
- (void)ivManagerCompletePlayVideo:(IndependentVideoManager *)manager;

/**
 *  成功获取视频积分
 *  Complete independent video.
 *
 *  @param manager IndependentVideoManager
 *  @param totalPoint
 *  @param consumedPoint
 *  @param currentPoint
 */

- (void)ivCompleteIndependentVideo:(IndependentVideoManager *)manager
                    withTotalPoint:(NSNumber *)totalPoint
                     consumedPoint:(NSNumber *)consumedPoint
                      currentPoint:(NSNumber *)currentPoint;

/**
 *  获取视频积分出错
 *  Uncomplete independent video.
 *
 *  @param manager IndependentVideoManager
 *  @param error
 */

- (void)ivManagerUncompleteIndependentVideo:(IndependentVideoManager *)manager
                            withError:(NSError *)error;

#pragma mark - point manage callback 积分管理

/**
 *  积分查询成功之后，回调该接口，获取总积分和总已消费积分。
 *  Called when finished to do point check.
 *
 *  @param totalPoint
 *  @param consumedPoint
 */
- (void)ivManager:(IndependentVideoManager *)manager
receivedTotalPoint:(NSNumber *)totalPoint
totalConsumedPoint:(NSNumber *)consumedPoint;
/**
 *  积分查询失败之后，回调该接口，返回查询失败的错误原因。
 *  Called when failed to do point check.
 *
 *  @param IndependentVideoManager
 *  @param error
 */
- (void)ivManager:(IndependentVideoManager *)manager
failedCheckWithError:(NSError *)error;
/**
 *  消费请求正常应答后，回调该接口，并返回消费状态（成功或余额不足），以及总积分和总已消费积分。
 *  Called when finished to do point consume.
 *
 *  @param IndependentVideoManager
 *  @param statusCode
 *  @param totalPoint
 *  @param consumedPoint
 */
- (void)ivManager:(IndependentVideoManager *)manager
consumedWithStatusCode:(IndependentVideoConsumeStatus)statusCode
       totalPoint:(NSNumber *)totalPoint
totalConsumedPoint:(NSNumber *)consumedPoint;
/**
 *  消费请求异常应答后，回调该接口，并返回异常的错误原因。
 *  Called when failed to do consume request.
 *
 *  @IndependentVideoManager
 *  @param error
 */
- (void)ivManager:(IndependentVideoManager *)manager
failedConsumeWithError:(NSError *)error;

#pragma mark - independent video status callback 积分墙状态
/**
 *  视频广告墙是否可用。
 *  Called after get independent video enable status.
 *
 *  @param IndependentVideoManager
 *  @param enable
 */
- (void)ivManager:(IndependentVideoManager *)manager
didCheckEnableStatus:(BOOL)enable;

/**
 *  是否有视频广告可以播放。
 *  Called after check independent video available.
 *
 *  @param IndependentVideoManager
 *  @param available
 */
- (void)ivManager:(IndependentVideoManager *)manager
isIndependentVideoAvailable:(BOOL)available;


@end

@interface IndependentVideoManager : NSObject {
    
}

@property(nonatomic,assign)id<IndependentVideoManagerDelegate>delegate;

/**
 *禁用StoreKit库提供的应用内打开store页面的功能，采用跳出应用打开OS内置AppStore。默认为NO，即使用StoreKit。
 */
@property (nonatomic, assign) BOOL disableStoreKit;

/**
 *  用于展示sotre或者展示类广告
 */
@property(nonatomic,assign)UIViewController *rootViewController;

#pragma mark - init 初始化相关方法
/**
 *  使用Publisher ID初始化积分墙
 *  Create IndependentVideoManager with your own Publisher ID
 *
 *  @param publisherID 媒体ID
 *
 *  @return IndependentVideoManager
 */
- (id)initWithPublisherID:(NSString *)publisherID;
/**
 *  使用Publisher ID和应用当前登陆用户的User ID初始化IndependentVideoManager
 *   Create IndependentVideoManager with your own Publisher ID and User ID.
 *
 *  @param publisherID 媒体ID
 *  @param userID      应用中唯一标识用户的ID
 *
 *  @return IndependentVideoManager
 */
- (id)initWithPublisherID:(NSString *)publisherID andUserID:(NSString *)userID;

/**
 *  更新登陆用户的User ID
 *  Update User ID.
 *
 *  @param userID      应用中唯一标识用户的ID
 */
- (void)updateUserID:(NSString *)userID;

#pragma mark - independent video present 积分墙展现相关方法
/**
 *  使用App的rootViewController来弹出并显示列表积分墙。
 *  Present independent video in ModelView way with App's rootViewController.
 *
 *  @param type 积分墙类型
 */
- (void)presentIndependentVideo;
/**
 *  使用开发者传入的UIViewController来弹出显示积分墙。
 *  Present IndependentVideo with developer's controller.
 *
 *  @param controller UIViewController
 *  @param type 积分墙类型
 */
- (void)presentIndependentVideoWithViewController:(UIViewController *)controller;

#pragma mark - independent video status 检查视频积分墙是否可用
/**
 *  是否有视频广告可以播放
 *  check independent video available.
 */
- (void)checkVideoAvailable;

#pragma mark - point manage 积分管理相关广告
/**
 *  检查已经得到的积分，成功或失败都会回调代理中的相应方法。
 *
 */
- (void)checkOwnedPoint;
/**
 *  消费指定的积分数目，成功或失败都会回调代理中的相应方法（请特别注意参数类型为unsigned int，需要消费的积分为非负值）。
 *
 *  @param point 要消费积分的数目
 */
- (void)consumeWithPointNumber:(NSUInteger)point;

@end

