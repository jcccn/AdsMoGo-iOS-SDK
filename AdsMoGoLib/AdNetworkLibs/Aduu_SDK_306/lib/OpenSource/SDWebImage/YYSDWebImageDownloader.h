/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <Foundation/Foundation.h>
#import "YYSDWebImageDownloaderDelegate.h"
#import "YYSDWebImageCompat.h"

extern NSString *const YYSDWebImageDownloadStartNotification;
extern NSString *const YYSDWebImageDownloadStopNotification;

@interface YYSDWebImageDownloader : NSObject
{
    @private
    NSURL *url;
    id<YYSDWebImageDownloaderDelegate> delegate;
    NSURLConnection *connection;
    NSMutableData *imageData;
	id userInfo;
    BOOL lowPriority;
}

@property (nonatomic, retain) NSURL *url;
@property (nonatomic, assign) id<YYSDWebImageDownloaderDelegate> delegate;
@property (nonatomic, retain) NSMutableData *imageData;
@property (nonatomic, retain) id userInfo;
@property (nonatomic, readwrite) BOOL lowPriority;

+ (id)downloaderWithURL:(NSURL *)url delegate:(id<YYSDWebImageDownloaderDelegate>)delegate userInfo:(id)userInfo lowPriority:(BOOL)lowPriority;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<YYSDWebImageDownloaderDelegate>)delegate userInfo:(id)userInfo;
+ (id)downloaderWithURL:(NSURL *)url delegate:(id<YYSDWebImageDownloaderDelegate>)delegate;
- (void)start;
- (void)cancel;

// This method is now no-op and is deprecated
+ (void)setMaxConcurrentDownloads:(NSUInteger)max __attribute__((deprecated));

@end
