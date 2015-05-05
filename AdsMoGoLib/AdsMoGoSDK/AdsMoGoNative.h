//
//  AdsMoGoNative.h
//  AdsMoGoNative
//
//  Created by MOGO on 15-1-4.
//  Copyright (c) 2015年 MOGO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsMoGoNativeDelegate.h"
#import "AdsMoGoNativeType.h"

@class AdsMogoNativeAdInfo;


@interface AdsMoGoNative : NSObject
@property(nonatomic,retain)NSString *mogoid;
@property(nonatomic,assign) id<AdsMoGoNativeDelegate> delegate;

+ (id)shareInstance;

// 初始化
// mogoid:芒果ID
// delegate:信息流delegate
// type:AdsMoGoNativeType 类型
-(void)initWithMoGoID:(NSString *)mogoid withDelegate:(id<AdsMoGoNativeDelegate>)delegete withNativeType:(AdsMoGoNativeType)type;
// 请求广告
- (void)loadAd;

@end
