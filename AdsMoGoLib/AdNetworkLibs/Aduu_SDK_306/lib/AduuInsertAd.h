//
//  AduuInsertAd.h
//  AduuLibSDK
//
//  Created by LingYun on 13-9-9.
//  Copyright (c) 2013年 LingYun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AduuInsertAdDelegate.h"

@interface AduuInsertAd : NSObject

// 
@property (nonatomic,assign) id<AduuInsertAdDelegate>delegate;

/**
 *	加载insertAd
 */
- (void)loadingInsertAd;

/**
 *	显示insertAd
 */
- (void)showInsertAd;

/**
 *	检查是否加载完成insertAd
 *
 *	@return	布尔值
 */
- (BOOL)isReady;

@end
