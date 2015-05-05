//
//  AdMoGoNativeRegistry.h
//  AdsMoGoNative
//
//  Created by MOGO on 15-1-5.
//  Copyright (c) 2015年 MOGO. All rights reserved.
//
#import "AdMoGoNativeClassWrapper.h"
@interface AdMoGoNativeRegistry : NSObject{
    NSMutableDictionary *adapterDict;
}
- (NSMutableDictionary *)getAdapterDict;
- (void)setAdapterDict:(NSMutableDictionary *)adapterDict;
- (void)registerClass:(Class)adapterClass;

- (AdMoGoNativeClassWrapper *)adapterClassFor:(NSInteger)adNetworkType;
+ (AdMoGoNativeRegistry *)sharedRegistry;
@end
