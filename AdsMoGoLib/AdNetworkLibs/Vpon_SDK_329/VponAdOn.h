//
//  AdView.h
//  AdOn
//
//  Created by Shark on 2010/6/2.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "AdOnPlatform.h"

#define ADON_SIZE_320x48    CGSizeMake(320,48)  //size for iPhone

#define ADON_SIZE_480x72    CGSizeMake(480,72)  //size for iPad

#define ADON_SIZE_640x96    CGSizeMake(640,96)  //size for iPad

#define ADON_SIZE_700x105   CGSizeMake(700,105) //size for iPad

#define ADON_SIZE_320X270   CGSizeMake(320,270) //size for iPad

@protocol VponAdOnDelegate; 

@interface VponAdOn : NSObject {

}
@property (nonatomic, retain) id<VponAdOnDelegate> adOnDelegate;
@property (nonatomic, readwrite) BOOL isVponLogo;

#pragma mark 初始化
+ (VponAdOn *)initializationPlatform:(Platform)platform;
#pragma mark Instance
+ (VponAdOn *)sharedInstance;
#pragma mark 回傳Vpon版本
+ (NSString *)getVersionVpon;
#pragma mark 設定Location開關
- (void)setLocationOnOff:(BOOL)isOn;
#pragma mark  回傳Location狀態
- (BOOL)isUseLocation;
#pragma mark return plat
- (Platform)getPlatformVpon;
#pragma mark for Vpon
- (NSArray *)requestDelegate:(id<VponAdOnDelegate>)delegate LicenseKey:(NSArray *)arrayLicenseKey size:(CGSize)size;
#pragma mark for adwhirl
- (UIViewController *)adwhirlRequestDelegate:(id<VponAdOnDelegate>)delegate licenseKey:(NSString *)licenseKey size:(CGSize)size;

@end

@protocol VponAdOnDelegate <NSObject>

@optional

#pragma mark 回傳點擊點廣是否有效
- (void)onClickAd:(UIViewController *)bannerView withValid:(BOOL)isValid withLicenseKey:(NSString *)adLicenseKey;
#pragma mark 回傳Vpon廣告抓取成功
- (void)onRecevieAd:(UIViewController *)bannerView withLicenseKey:(NSString *)licenseKey;
#pragma mark 回傳Vpon廣告抓取失敗
- (void)onFailedToRecevieAd:(UIViewController *)bannerView withLicenseKey:(NSString *)licenseKey;

@end
