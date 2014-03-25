//
//  pingcooSDK.h
//  pingcooSDK_1.0.1
//
//  Created by jason on 13-7-4.
//  Copyright (c) 2013年 jason. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol pingcooSDKDelegate;
@interface pingcooSDK : NSObject
{
    id<pingcooSDKDelegate>_delegate;
}
@property (nonatomic,assign)id<pingcooSDKDelegate>delegate;
//控制调用的服务器 isTest = YES 是测试服务器 isTest = NO 是线上服务器。默认的是isTest = NO
@property (nonatomic,assign)BOOL isTest;

//当前广告所在的视图控件
@property (nonatomic,assign)UIViewController *rootViewController;

+(pingcooSDK *)initWithKey:(NSString *)theAdKey;


//显示在应用顶部
-(void)bannerShowTop;


//显示在应用底部
-(void)bannerShowBottom;


//自定义位置 (通过设置customview)
@property (assign,nonatomic)UIView *customView;//移除的时候要把它设置为nil；
-(void)bannerCustom;


-(void)pauseShow;


-(void)popShow:(NSString *)codenumber addName:(NSString *)name;


@end


@protocol pingcooSDKDelegate <NSObject>

//图片显示完成
-(void)show:(pingcooSDK *)show didFinishAppearWithResult:(id)result;
//错误
-(void)show:(pingcooSDK *)show didFailWithError:(NSError *)error;
//图片消失
-(void)show:(pingcooSDK *)show didFinishDisappearWithResult:(id)result;


@end
