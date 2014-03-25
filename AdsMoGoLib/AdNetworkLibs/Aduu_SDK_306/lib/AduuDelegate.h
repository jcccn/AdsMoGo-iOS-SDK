//
//  AduuDelegate.h
//  libAduu
//
//  Created by LingYun on 13-8-19.
//  Copyright (c) 2013年 LingYun. All rights reserved.
//

#import <Foundation/Foundation.h>
@class AduuView;

typedef enum {
    AduuBannerAnimationTypeNone = 0,
    AduuBannerAnimationTypeSlideFromLeft,
    AduuBannerAnimationTypeSlideFromRight,
    AduuBannerAnimationTypeFadeIn,
    AduuBannerAnimationTypeCurlUp,
    AduuBannerAnimationTypeCurlDown,
    AduuBannerAnimationTypeFlipFromLeft,
    AduuBannerAnimationTypeFlipFromRight,
    AduuBannerAnimationTypeRandom
}AduuBannerAnimationType;

@protocol AduuDelegate <NSObject>

@optional
/**
 *	广告获取成功回调该方法
 *
 *	@param	adView	
 */
- (void)didReceiveAd:(AduuView *)adView;

/**
 *	广告获取失败回调该方法
 *
 *	@param	adView
 *	@param	error	
 */
- (void)didFailToReceiveAd:(AduuView *)adView error:(NSError*)error;

/**
 *	广告点击后回调该方法
 *
 *	@param	adView	
 */
- (void)didClickAd:(AduuView *)adView;

@end
