//
//  Created by xingzhe on 14-2-15.
//  Copyright (c) 2014年 xingzhe. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GuUserConfig : NSObject



@property (nonatomic,copy) NSString *guChannel;
@property (nonatomic,copy) NSString *guAppKey;
@property (nonatomic,copy) NSString *guUser_info;


+ (GuUserConfig *)getInstance;

@end
