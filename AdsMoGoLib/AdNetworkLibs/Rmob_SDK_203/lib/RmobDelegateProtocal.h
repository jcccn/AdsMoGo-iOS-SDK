//
//  RmobDelegateProtocal.h
//  Rmob-SDK
//
//  Copyright (c) 2012年 renren. All rights reserved.

#import <Foundation/Foundation.h>

@protocol RmobDelegateProtocal <NSObject>
@optional

//成功接收并显示新广告后调用，count表示当前广告是第几条广告，SDK启动后从1开始，累加计数
- (void)didSucceedToReceiveAd:(NSInteger)count;

/*
 接受SDK返回的错误报告
 code 1: 参数错误
 code 2: 服务端错误
 code 3: 应用被冻结
 code 4: 无合适广告
 code 5: 应用账户不存在
 code 6: 频繁请求
 code 7: 广告为空
 code 101: 网络请求失败
 case 102: 广告关闭
*/
- (void)didReceiveError:(NSError *)error;

//将要弹出新的视图
- (void)rmobAdWillPresentViewController;

//Dismiss弹出的视图
- (void)rmobAdDidDismissViewController;

//开启定位  默认值YES
- (BOOL)rmobOpenLocation;

//广告被点击
- (void)rmobAdDidClicked;

//点击广告打开的广告详情页面加载完成
- (void)adInfoViewDidFinishLoad;

@end
