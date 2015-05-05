//
//  AdsMogoNativeAdInfo.h
//  mogoNativeDemo
//
//  Created by Castiel Chen on 15/1/6.
//  Copyright (c) 2015年 ___ADSMOGO___. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdMoGoNativeUserKey.h"
@interface AdsMogoNativeAdInfo : NSObject
//基本参数
@property(nonatomic,retain) NSDictionary * context_dic;//广告数据字典
@property(nonatomic,retain) NSString * adid;// 统计使用

//展示广告
-(void)attachAdView:(UIView*)view;
//点击广告
-(void)clickAd;

@end
