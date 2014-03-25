//
//  AduuView.h
//  libAduu
//
//  Created by LingYun on 13-8-15.
//  Copyright (c) 2013年 LingYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AduuDelegate.h"
#import "AduuConfig.h"

@interface AduuView : UIView

//默认是随机切换
@property (nonatomic,assign)                      AduuBannerAnimationType bannerAnimationType;

//切换效果持续时间间隔 默认0.6
@property (nonatomic,assign)                      CGFloat animationDuration;
//刷新广告时间 默认15秒
@property (nonatomic,assign)                      NSInteger updateTime;

/**
 *	初始化AduuView
 *
 *	@param	sizeIdentifier	banner大小标志
 *	@param	delegate	AduuDelegate
 *
 *	@return	AduuView
 */
- (id)initWithContentSizeIdentifier:(AduuBannerContentSizeIdentifier)sizeIdentifier delegate:(id<AduuDelegate>)delegate;

/**
 *	开始获取广告
 */
- (void)start;

/**
 *	停止获取广告
 */
- (void)stop;

/**
 *	设置banner广告位置
 *
 *	@param	point	banner坐标
 */
- (void)setAduuViewOrigin:(CGPoint)point;

@end
