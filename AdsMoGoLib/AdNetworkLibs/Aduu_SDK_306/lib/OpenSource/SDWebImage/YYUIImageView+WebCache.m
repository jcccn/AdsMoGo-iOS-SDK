/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "YYUIImageView+WebCache.h"
#import "YYSDWebImageManager.h"

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    YYSDWebImageManager *manager = [YYSDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self];
    }
}

- (void)cancelCurrentImageLoad
{
    [[YYSDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(YYSDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
    self.alpha = 0.0;
    
    [UIView beginAnimations: nil context: nil];
    [UIView setAnimationDuration: 2.0];
    self.alpha = 1.0;
    [UIView commitAnimations];
}

@end
