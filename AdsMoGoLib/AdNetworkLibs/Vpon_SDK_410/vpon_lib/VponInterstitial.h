//
//  InterstitialAdOn.h
//  iphone-vpon-sdk
//
//  Created by vpon on 13/1/16.
//  Copyright (c) 2013年 com.vpon. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "VponBanner.h"

#pragma mark -
#pragma mark VponInterstitialDelegate
@protocol VponInterstitialDelegate <VponBannerDelegate>
@optional
#pragma mark 通知取得插屏廣告成功pre-fetch完成
- (void)onVponInterstitialAdReceived:(UIView *)bannerView;
#pragma mark 通知取得插屏廣告失敗
- (void)onVponInterstitialAdFailed:(UIView *)bannerView;
#pragma mark 通知關閉vpon廣告頁面
- (void)onVponInterstitialAdDismiss:(UIView *)bannerView;
@end

@interface VponInterstitial : NSObject<VponInterstitialDelegate>
{
}
@property (nonatomic, assign) NSObject<VponInterstitialDelegate> *delegate;
@property (nonatomic, copy) NSString *strBannerId;
@property (nonatomic, copy) NSArray* arrayTestIdentifiers;
@property (nonatomic, assign) Platform platform;
- (id)init;
#pragma mark 取得插屏廣告
- (void)getInterstitial:(NSArray*)arrayTestIdentifiers;
#pragma mark - 顯示插屏廣告
- (void)show;
#pragma mark 設定Location開關
- (void)setLocationOnOff:(BOOL)isOn;
#pragma mark  回傳Location狀態
- (BOOL)isUseLocation;
@end


