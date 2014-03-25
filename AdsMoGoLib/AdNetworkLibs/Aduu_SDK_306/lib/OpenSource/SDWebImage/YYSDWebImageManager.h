/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "YYSDWebImageCompat.h"
#import "YYSDWebImageDownloaderDelegate.h"
#import "YYSDWebImageManagerDelegate.h"
#import "YYSDImageCacheDelegate.h"

@interface YYSDWebImageManager : NSObject <YYSDWebImageDownloaderDelegate, YYSDImageCacheDelegate>
{
    NSMutableArray *delegates;
    NSMutableArray *downloaders;
    NSMutableDictionary *downloaderForURL;
    NSMutableArray *failedURLs;
}

+ (id)sharedManager;
- (UIImage *)imageWithURL:(NSURL *)url;
- (void)downloadWithURL:(NSURL *)url delegate:(id<YYSDWebImageManagerDelegate>)delegate;
- (void)downloadWithURL:(NSURL *)url delegate:(id<YYSDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed;
- (void)downloadWithURL:(NSURL *)url delegate:(id<YYSDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed lowPriority:(BOOL)lowPriority;
- (void)cancelForDelegate:(id<YYSDWebImageManagerDelegate>)delegate;

@end
