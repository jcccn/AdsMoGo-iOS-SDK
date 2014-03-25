//
//  GMInterADView.h
//  GuomobAdSDK
//
//  Created by qq on 12-11-9.
//  Copyright (c) 2012年 AK. All rights reserved.
//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GMInterADViewDelegate <NSObject>

@required
- (void)loadInterADSuccess:(BOOL)success;//加载成功
- (void)closeInterAD;//关闭广告
- (void)InterADConnectionDidFailWithError:(NSError *)error;//请求内容返回的错误
@end

@interface GMInterADView : UIView<GMInterADViewDelegate>
{
    id< GMInterADViewDelegate > delegate; 
}

@property(nonatomic,retain)id< GMInterADViewDelegate > delegate;
//接口参数
//appKey 应用密钥
//isalloc 是否允许旋转
- (id)initWithId:(NSString *)appKey; // 应用密钥

//加载展示广告
- (void)loadInterAd:(BOOL)isalloc;


@end