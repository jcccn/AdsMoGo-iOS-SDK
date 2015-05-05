//
//  yjfScore.h
//  yjfSDKDemo_beta1
//
//  Created by emaryjf on 13-4-9.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HMIntegralScore.h"

@interface HMScore : NSObject


+(void)getScore:(id<HMIntegralScoreDelegate>)_delegate;;//查询积分
+(void)consumptionScore:(int)_score delegate:(id<HMIntegralScoreDelegate>)_delegate;//消耗积分


@end
