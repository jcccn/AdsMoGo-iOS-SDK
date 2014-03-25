//
//  AduuInsertAdDelegate.h
//  libAduu
//
//  Created by LingYun on 13-9-9.
//  Copyright (c) 2013年 LingYun. All rights reserved.
//

#import <Foundation/Foundation.h>

@class AduuInsertAd;

@protocol AduuInsertAdDelegate <NSObject>

@optional

/**
 *	获取insertAd数据
 *
 *	@param	insertAd	
 */
- (void)didInsertAdRequestFinished:(AduuInsertAd *)insertAd;

/**
 *	获取insertAd数据失败
 *
 *	@param	insertAd
 *	@param	error	错误信息
 */
- (void)didInsertAdRequestFailed:(AduuInsertAd *)insertAd error:(NSError *)error;

/**
 *	insertAd 将要呈现
 *
 *	@param	insertAd
 */
- (void)insertAdWillPresentScreen:(AduuInsertAd *)insertAd;

/**
 *	insertAd 消失
 *
 *	@param	insertAd	
 */
- (void)insertAdDidDismissScreen:(AduuInsertAd *)insertAd;

/**
 *	点击insertAd
 */
- (void)didClickInsertAd;

@end
