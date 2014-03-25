//
//  DolphinMobileSDK.h
//  DolphinMobileSDK
//
//  Created by AdSame on 11/16/13.
//  Copyright (c) 2013 AdSame. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol AdsameCubeMaxDelegate <NSObject>

@optional

-(void)onAdsDataReady;
-(void)onAdsLoadingFailed;
-(void)onAdsSwitching;
-(void)onAdsImpressed;
-(Boolean)onAdsClicked:(NSString *)clickUrl;

//这个回调只有全屏广告关闭时才有，Banner没有
-(void)onFullScreenAdsClosed;

@end


@interface AdsameCubeMaxSDK : NSObject

+ (void)initWithPublishID:(NSString *)pId delegate:(id<AdsameCubeMaxDelegate>)delegate;

+ (UIView *)getBannerWithCID:(NSUInteger)cId width:(CGFloat)bannerWidth height:(CGFloat)bannerHeight delegate:(id<AdsameCubeMaxDelegate>)delegate;

//显示全屏广告，返回TRUE表示成功，返回FALSE表示失败（比如未初始化或素材有问题等）
//一般需要在onAdsDataReady之后调用才有效
+(Boolean)showFullScreenAds;

@end
