//
//  MIXViewDelegate.h
//  GuoHeMixiOSDev
//
//  Created by Lynn Woo on 12-6-12.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MIXView;

@protocol MIXViewDelegate <NSObject>

@optional
//加载推广橱窗失败时调用
- (void)mixViewDidFailToShowAd:(MIXView *)view withPlace:(NSString *)place;

//加载推广橱窗成功时调用
- (void)mixViewDidShowAd:(MIXView *)view withPlace:(NSString *)place;

//推广橱窗点击出现内容窗口时调用
- (void)mixViewDidClickedAd:(MIXView *)view withPlace:(NSString *)place;

//推广橱窗的关闭按钮被点击时调用
- (void)mixViewDidClosed:(MIXView *)view withPlace:(NSString *)place;

//没有推广橱窗返回时调用
- (void)mixViewNoAdWillPresent:(MIXView *)view withPlace:(NSString *)place;


@end
