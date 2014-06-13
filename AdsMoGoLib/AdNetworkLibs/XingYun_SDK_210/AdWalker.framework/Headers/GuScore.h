//
//  Created by xingzhe on 14-2-15.
//  Copyright (c) 2014年 xingzhe. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GuScoreWall.h"

@interface GuScore : NSObject


+(void)getScore:(id<GuScoreWallDelegate>)_delegate;;//查询积分
+(void)consumptionScore:(int)_score delegate:(id<GuScoreWallDelegate>)_delegate;//消耗积分


@end
