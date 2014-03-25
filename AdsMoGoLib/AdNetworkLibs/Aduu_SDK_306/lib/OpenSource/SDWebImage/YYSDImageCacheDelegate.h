//
//  SDImageCacheDelegate.h
//  Dailymotion
//
//  Created by Olivier Poitrey on 16/09/10.
//  Copyright 2010 Dailymotion. All rights reserved.
//

#import "YYSDWebImageCompat.h"

@class YYSDImageCache;

@protocol YYSDImageCacheDelegate <NSObject>

@optional
- (void)imageCache:(YYSDImageCache *)imageCache didFindImage:(UIImage *)image forKey:(NSString *)key userInfo:(NSDictionary *)info;
- (void)imageCache:(YYSDImageCache *)imageCache didNotFindImageForKey:(NSString *)key userInfo:(NSDictionary *)info;

@end
