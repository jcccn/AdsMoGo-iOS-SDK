/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "YYSDWebImageManager.h"
#import "YYSDImageCache.h"
#import "YYSDWebImageDownloader.h"

static YYSDWebImageManager *instance;

@implementation YYSDWebImageManager

- (id)init
{
    if ((self = [super init]))
    {
        delegates = [[NSMutableArray alloc] init];
        downloaders = [[NSMutableArray alloc] init];
        downloaderForURL = [[NSMutableDictionary alloc] init];
        failedURLs = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [delegates release], delegates = nil;
    [downloaders release], downloaders = nil;
    [downloaderForURL release], downloaderForURL = nil;
    [failedURLs release], failedURLs = nil;
    [super dealloc];
}


+ (id)sharedManager
{
    if (instance == nil)
    {
        instance = [[YYSDWebImageManager alloc] init];
    }

    return instance;
}

/**
 * @deprecated
 */
- (UIImage *)imageWithURL:(NSURL *)url
{
    return [[YYSDImageCache sharedImageCache] imageFromKey:[url absoluteString]];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<YYSDWebImageManagerDelegate>)delegate
{
    [self downloadWithURL: url delegate:delegate retryFailed:NO];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<YYSDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed
{
    [self downloadWithURL:url delegate:delegate retryFailed:retryFailed lowPriority:NO];
}

- (void)downloadWithURL:(NSURL *)url delegate:(id<YYSDWebImageManagerDelegate>)delegate retryFailed:(BOOL)retryFailed lowPriority:(BOOL)lowPriority
{
    if (!url || !delegate || (!retryFailed && [failedURLs containsObject:url]))
    {
        return;
    }
    
    // Check the on-disk cache async so we don't block the main thread
    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:delegate, @"delegate", url, @"url", [NSNumber numberWithBool:lowPriority], @"low_priority", nil];
    [[YYSDImageCache sharedImageCache] queryDiskCacheForKey:[url absoluteString] delegate:self userInfo:info];
}

- (void)cancelForDelegate:(id<YYSDWebImageManagerDelegate>)delegate
{
    NSUInteger idx = [delegates indexOfObjectIdenticalTo:delegate];

    if (idx == NSNotFound)
    {
        return;
    }

    YYSDWebImageDownloader *downloader = [[downloaders objectAtIndex:idx] retain];

    [delegates removeObjectAtIndex:idx];
    [downloaders removeObjectAtIndex:idx];

    if (![downloaders containsObject:downloader])
    {
        // No more delegate are waiting for this download, cancel it
        [downloader cancel];
        [downloaderForURL removeObjectForKey:downloader.url];
    }

    [downloader release];
}

#pragma mark SDImageCacheDelegate

- (void)imageCache:(YYSDImageCache *)imageCache didFindImage:(UIImage *)image forKey:(NSString *)key userInfo:(NSDictionary *)info
{
    id<YYSDWebImageManagerDelegate> delegate = [info objectForKey:@"delegate"];
    if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:)])
    {
        [delegate performSelector:@selector(webImageManager:didFinishWithImage:) withObject:self withObject:image];
    }
}

- (void)imageCache:(YYSDImageCache *)imageCache didNotFindImageForKey:(NSString *)key userInfo:(NSDictionary *)info
{
    NSURL *url = [info objectForKey:@"url"];
    id<YYSDWebImageManagerDelegate> delegate = [info objectForKey:@"delegate"];
    BOOL lowPriority = [[info objectForKey:@"low_priority"] boolValue];

    // Share the same downloader for identical URLs so we don't download the same URL several times
    YYSDWebImageDownloader *downloader = [downloaderForURL objectForKey:url];

    if (!downloader)
    {
        downloader = [YYSDWebImageDownloader downloaderWithURL:url delegate:self userInfo:nil lowPriority:lowPriority];
        [downloaderForURL setObject:downloader forKey:url];
    }
    
    // If we get a normal priority request, make sure to change type since downloader is shared
    if (!lowPriority && downloader.lowPriority)
        downloader.lowPriority = NO;
    
    [delegates addObject:delegate];
    [downloaders addObject:downloader];
}

#pragma mark SDWebImageDownloaderDelegate

- (void)imageDownloader:(YYSDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image
{
    [downloader retain];

    // Notify all the delegates with this downloader
    for (NSInteger idx = [downloaders count] - 1; idx >= 0; idx--)
    {
        YYSDWebImageDownloader *aDownloader = [downloaders objectAtIndex:idx];
        if (aDownloader == downloader)
        {
            id<YYSDWebImageManagerDelegate> delegate = [delegates objectAtIndex:idx];

            if (image)
            {
                if ([delegate respondsToSelector:@selector(webImageManager:didFinishWithImage:)])
                {
                    [delegate performSelector:@selector(webImageManager:didFinishWithImage:) withObject:self withObject:image];
                }
            }
            else
            {
                if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:)])
                {
                    [delegate performSelector:@selector(webImageManager:didFailWithError:) withObject:self withObject:nil];
                }
            }

            [downloaders removeObjectAtIndex:idx];
            [delegates removeObjectAtIndex:idx];
        }
    }

    if (image)
    {
        // Store the image in the cache
        [[YYSDImageCache sharedImageCache] storeImage:image
                                          imageData:downloader.imageData
                                             forKey:[downloader.url absoluteString]
                                             toDisk:YES];
    }
    else
    {
        // The image can't be downloaded from this URL, mark the URL as failed so we won't try and fail again and again
        [failedURLs addObject:downloader.url];
    }


    // Release the downloader
    [downloaderForURL removeObjectForKey:downloader.url];
    [downloader release];
}

- (void)imageDownloader:(YYSDWebImageDownloader *)downloader didFailWithError:(NSError *)error;
{
    [downloader retain];

    // Notify all the delegates with this downloader
    for (NSInteger idx = [downloaders count] - 1; idx >= 0; idx--)
    {
        YYSDWebImageDownloader *aDownloader = [downloaders objectAtIndex:idx];
        if (aDownloader == downloader)
        {
            id<YYSDWebImageManagerDelegate> delegate = [delegates objectAtIndex:idx];

            if ([delegate respondsToSelector:@selector(webImageManager:didFailWithError:)])
            {
                [delegate performSelector:@selector(webImageManager:didFailWithError:) withObject:self withObject:error];
            }

            [downloaders removeObjectAtIndex:idx];
            [delegates removeObjectAtIndex:idx];
        }
    }

    // Release the downloader
    [downloaderForURL removeObjectForKey:downloader.url];
    [downloader release];
}

@end
