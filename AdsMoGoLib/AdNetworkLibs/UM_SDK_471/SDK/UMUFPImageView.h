//
//  UMUFPImageView.h
//  UFP
//
//  Created by liu yu on 1/17/12.
//  Updated by liu yu on 12/26/13.
//  Copyright 2010-2013 Umeng.com. All rights reserved.
//  Version 4.7

#import <UIKit/UIKit.h>

@protocol UMUFPImageViewDelegate;

/**
 
 UMUFPImageView is a subclass of UIImageView class that support remote image loading and cache.
 
 */

@interface UMUFPImageView : UIImageView {
@private
    NSURL   *_imageURL;
    UIImage *_placeholderImage;
    
    id<UMUFPImageViewDelegate> _dataLoadDelegate;
}

/**
 
 This method return a UMUFPImageView object
 
 @param  anImage placeholder image for the imageview
 
 @return a UMUFPImageView object
 
 */

- (id)initWithPlaceholderImage:(UIImage*)anImage;

/**
 
 This method check whether image for certain url loaded
 
 @param  imageUrl url for a remote image
 
 @return a BOOL value
 
 */

- (BOOL)isCachedImageWithUrl:(NSURL *)imageUrl; //Check whether image for the releated url has been downloaded

@property(nonatomic, retain) NSURL   *imageURL; //Url of the image releated the imageview currently
@property(nonatomic, retain) UIImage *placeholderImage; //Placeholder image for the imageview during image loading progress
@property(nonatomic, assign) id<UMUFPImageViewDelegate> dataLoadDelegate; //Delegate
@property(nonatomic) NSTimeInterval cacheTimeoutInterval; // Default is 604800 seconds
@property(nonatomic) BOOL shouldRedrawImageToAdaptImageViewSize; //Default is YES, for the case of imageview size is far less than the actual size of releated image, the default zoom strategy of UIImageView may lead to fuzzy(not clear) of the original image. Set shouldRedrawImageToAdaptImageViewSize to YES, UMUFPImageView will handle this case, making original image adapt to the size of UMUFPImageView, while the definition also acceptable.

@property (nonatomic) BOOL shouldShowFadeInAnimation; // fade in animation when image appear, default is NO

@property (nonatomic) BOOL showGif;
@end

/**
 
 delegate is a protocol for UMUFPImageView.
 Optional methods of the protocol allow the delegate to capture UMUFPImageView releated events, and perform other actions.
 
 */

@protocol UMUFPImageViewDelegate <NSObject>

@optional

- (void)didLoadFinish:(UMUFPImageView *)imageview; //releated image load finished
- (void)didLoadFailed:(UMUFPImageView *)imageview; //releated image load failed

- (void)imageView:(UMUFPImageView *)imageView originalImageSize:(CGSize)imageSize; //actual size for the raw image

@end