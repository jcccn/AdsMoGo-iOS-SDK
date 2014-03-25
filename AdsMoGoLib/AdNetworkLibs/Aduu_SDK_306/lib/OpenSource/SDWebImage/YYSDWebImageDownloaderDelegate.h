/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "YYSDWebImageCompat.h"

@class YYSDWebImageDownloader;

@protocol YYSDWebImageDownloaderDelegate <NSObject>

@optional

- (void)imageDownloaderDidFinish:(YYSDWebImageDownloader *)downloader;
- (void)imageDownloader:(YYSDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image;
- (void)imageDownloader:(YYSDWebImageDownloader *)downloader didFailWithError:(NSError *)error;

@end
