/**
 * @note Copyright (C) 2012~, Vpon Incorporated. All Rights Reserved.
 *       This program is an unpublished copyrighted work which is proprietary to
 *       Vpon Incorporated and contains confidential information that is
 *       not to be reproduced or disclosed to any other person or entity without
 *       prior written consent from Vpon, Inc. in each and every instance.
 *
 * @warning Unauthorized reproduction of this program as well as unauthorized
 *          preparation of derivative works based upon the program or distribution of
 *          copies by sale, rental, lease or lending are violations of federal
 *          copyright laws and state trade secret laws, punishable by civil and
 *          criminal penalties.
 *
 * @file    AdShowBanner.h
 *
 * @brief   support publisher to use AdShow ad
 *
 * @author  Alan(alan.tseng@vopn.com)
 *
 *
 * @date    2014/2/14
 *
 * @version 4.2.0
 *
 * @remark
 *
 **/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
	adshow_male, adshow_female
} AdShowUserInfoGender;

#pragma mark AdShowAdType
typedef enum {
	ADSHOW_BANNER,
    ADSHOW_RECTANGLE,
    ADSHOW_PAD_BANNER,
    ADSHOW_LEADERBOARD,
    ADSHOW_SMART,
    ADSHOW_STANDARD_PORTRAIT,
    ADSHOW_SMART_PORTRAIT,
    ADSHOW_INTERSTITIAL,
    ADSHOW_SPLASH,
    ADSHOW_MEDIUM_RECTANGLE,
    ADSHOW_SMART_LANDSCAPE,
    ADSHOW_VIDEO_INTERSTITIAL
} AdShowSizeTypeEnum;

#pragma mark AdShowAdSize
typedef struct  AdShowAdSize {
    CGSize size;
    int    adType;
}AdShowAdSize;

extern AdShowAdSize const AdShowAdSizeBanner;               // use for 320 * 50
extern AdShowAdSize const AdShowAdSizeFullBanner;           // use for 468 * 60   for iPad
extern AdShowAdSize const AdShowAdSizeLeaderboard;          // use for 728 * 90   for iPad
extern AdShowAdSize const AdShowAdSizeMediumRectangle;      // use for 300 * 250  for iPad
extern AdShowAdSize const AdShowAdSizeSmartBannerLandscape; // use for landscape smart banner
extern AdShowAdSize const AdShowAdSizeSmartBannerPortrait;  // use for portrait smart banner

CGSize CGSizeFromAdShowAdSize(AdShowAdSize size);   // get banner size


#pragma mark AdShowBannerDelegate
@protocol AdShowBannerDelegate <NSObject>
@optional
#pragma mark 通知有廣告可供拉取
- (void)onVpadnGetAd:(UIView *)bannerView;
#pragma mark 通知拉取廣告成功pre-fetch完成
- (void)onVpadnAdReceived:(UIView *)bannerView;
#pragma mark 通知拉取廣告失敗
- (void)onVpadnAdFailed:(UIView *)bannerView didFailToReceiveAdWithError:(NSError *)error;
#pragma mark 通知開啟AdShow廣告頁面
- (void)onVpadnPresent:(UIView *)bannerView;
#pragma mark 通知關閉AdShow廣告頁面
- (void)onVpadnDismiss:(UIView *)bannerView;
#pragma mark 通知離開publisher application
- (void)onVpadnLeaveApplication:(UIView *)bannerView;
#pragma mark View size change publisher can not to use
- (void)onVpadnViewSizeChange:(CGRect)ViewSize;
#pragma mark View size change publisher can not to use
- (void)onVpadnViewColorChange:(UIColor*)bgColor;
#pragma mark Ad auto refresh notify
-(void)onVpadnRefreshAd;

@end
#pragma mark AdShowBanner
@interface AdShowBanner : NSObject<AdShowBannerDelegate>  {
}
@property (nonatomic, copy) NSString *strBannerId;
@property (nonatomic, retain) UIViewController *rootViewController;
@property (nonatomic, assign) NSObject<AdShowBannerDelegate> *delegate;
@property (nonatomic, retain) NSString* platform;
@property (nonatomic, copy) NSArray* arrayTestIdentifiers;

#pragma mark 回傳AdShow SDK版本
+ (NSString *)getVersionAdShow;
- (void)dealloc;
#pragma mark 取得AdShowBanner物件
- (id)initWithAdSize:(AdShowAdSize)adSize origin:(CGPoint)origin;
#pragma mark 取得AdShowBanner物件 位置預設為(0,0)
- (id)initWithAdSize:(AdShowAdSize)adSize;

#pragma mark 設定廣告是否自動更新. (Default NO)
- (void)setAdAutoRefresh:(BOOL)bSetAutoRefresh;
#pragma mark 開始取得廣告
- (void)startGetAd:(NSArray *)arrayTestIdentifiers;
#pragma mark 取得廣告View
- (UIView *)getAdShowAdView;
- (void)bannerPositionChange;

#pragma mark - UserInfomation
#pragma mark 設定使用者資訊-年齡
- (void)setUserInfoAge:(NSInteger)age;
#pragma mark 設定使用者資訊-生日
- (void)setUserInfoBirthdayWithYear:(NSInteger)year Month:(NSInteger)month andDay:(NSInteger)day;
#pragma mark 設定使用者資訊-性別
- (void)setUserInfoGender:(AdShowUserInfoGender)gender;
#pragma mark 設定使用者資訊-關鍵字
- (void)setUserInfoKeyword:(NSString *)keyword;

#pragma mark 設定Location開關
- (void)setLocationOnOff:(BOOL)isOn;
#pragma mark  回傳Location狀態
- (BOOL)isUseLocation;
- (void)destroyBanner;
@end
