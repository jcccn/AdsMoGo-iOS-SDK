//
//  MMUPromotersDataObject.h
//  MraidLib
//
//  Created by liuyu on 12/16/14.
//  Updated by liu yu on 12/30/14.
//  Copyright 2007-2015 Alimama.com. All rights reserved.
//  Version 5.3.2
//
//  Support Email: mobilesupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>

@interface MMUPromotersDataObject : NSObject <NSCopying>

- (id)initWithAttributes:(NSDictionary *)attributes;
- (NSArray *)promoters;

@end
