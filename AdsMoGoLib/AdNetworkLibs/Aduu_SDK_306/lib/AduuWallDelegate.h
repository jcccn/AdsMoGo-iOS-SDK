//
//  AduuWallDelegate.h
//  libAduu
//
//  Created by LingYun on 13-8-29.
//  Copyright (c) 2013年 LingYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AduuWallView;

@protocol AduuWallDelegate <NSObject>

@optional
/**
 *	获取aduuwall数据成功时回调
 *
 *	@param	aduuWall
 */
- (void)didWallAdFinished:(AduuWallView *)aduuWall;

/**
 *	获取aduuwall数据失败时回调
 *
 *	@param	aduuWall
 *	@param	error	错误信息
 */
- (void)didWallAdFailed:(AduuWallView *)aduuWall error:(NSError *)error;

@end
