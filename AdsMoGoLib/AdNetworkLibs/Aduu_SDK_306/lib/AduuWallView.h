//
//  AppListView.h
//  libAduu
//
//  Created by LingYun on 13-8-20.
//  Copyright (c) 2013年 LingYun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AduuWallDelegate.h"
@interface AduuWallView : UIView

//委托代理
@property (nonatomic,assign) id<AduuWallDelegate> delegate;

/**
 *	加载aduuwall
 */
- (void)loadingWall;

/**
 *	清除aduuwall数据
 */
- (void)clearWall;

/**
 *	显示aduuwall
 */
- (void)showAduuWall;

@end
