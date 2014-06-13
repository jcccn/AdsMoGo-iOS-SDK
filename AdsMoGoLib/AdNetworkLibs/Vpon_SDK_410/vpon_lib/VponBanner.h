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
 * @file    VponBanner.h
 *
 * @brief   support publisher to use Vpon ad
 *
 * @author  Alan(alan.tseng@vopn.com)
 *
 *
 * @date    2013/4/9
 *
 * @version 4.0.0
 *
 * @remark
 *
 **/

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
	CN, TW
} Platform;

typedef enum {
	male, female
} UserInfoGender;

#pragma mark VponAdType
typedef enum {
	BANNER,
    RECTANGLE,
    PAD_BANNER,
    LEADERBOARD,
    SMART,
    STANDARD_PORTRAIT,
    SMART_PORTRAIT,
    INTERSTITIAL,
    SPLASH,
    MEDIUM_RECTANGLE,
    SMART_LANDSCAPE,
} SizeTypeEnum;

#pragma mark VponAdSize
typedef struct  VponAdSize {
    CGSize size;
    int    adType;
}VponAdSize;

extern VponAdSize const VponAdSizeBanner;               // use for 320 * 50
extern VponAdSize const VponAdSizeFullBanner;           // use for 468 * 60 for iPad
extern VponAdSize const VponAdSizeLeaderboard;          // use for 728 * 90 for iPad
extern VponAdSize const VponAdSizeMediumRectangle;      // use for 300 * 250
extern VponAdSize const VponAdSizeSmartBannerLandscape; // use for landscape smart banner
extern VponAdSize const VponAdSizeSmartBannerPortrait;  // use for portrait smart banner

CGSize CGSizeFromVponAdSize(VponAdSize size);   // get banner size


#pragma mark VponBannerDelegate
@protocol VponBannerDelegate <NSObject>
@optional
#pragma mark 通知有廣告可供拉取
- (void)onVponGetAd:(UIView *)bannerView;
#pragma mark 通知拉取廣告成功pre-fetch完成
- (void)onVponAdReceived:(UIView *)bannerView;
#pragma mark 通知拉取廣告失敗
- (void)onVponAdFailed:(UIView *)bannerView didFailToReceiveAdWithError:(NSError *)error;
#pragma mark 通知開啟vpon廣告頁面
- (void)onVponPresent:(UIView *)bannerView;
#pragma mark 通知關閉vpon廣告頁面
- (void)onVponDismiss:(UIView *)bannerView;
#pragma mark 通知離開publisher application
- (void)onVponLeaveApplication:(UIView *)bannerView;
#pragma mark View size change publisher can not to use
- (void)onVponViewSizeChange:(CGRect)ViewSize;
#pragma mark View size change publisher can not to use
- (void)onVponViewColorChange:(UIColor*)bgColor;
#pragma mark Ad auto refresh notify
-(void)onVponRefreshAd;

@end
#pragma mark VponBanner
@interface VponBanner : NSObject<VponBannerDelegate>  {
}
@property (nonatomic, copy) NSString *strBannerId;
@property (nonatomic, assign) UIViewController *rootViewController;
@property (nonatomic, assign) NSObject<VponBannerDelegate> *delegate;
@property (nonatomic, assign) Platform platform;
@property (nonatomic, copy) NSArray* arrayTestIdentifiers;

#pragma mark 回傳Vpon SDK版本
+ (NSString *)getVersionVpon;
- (void)dealloc;
#pragma mark 取得VponBanner物件
- (id)initWithAdSize:(VponAdSize)adSize origin:(CGPoint)origin;
#pragma mark 取得VponBanner物件 位置預設為(0,0)
- (id)initWithAdSize:(VponAdSize)adSize;

#pragma mark 設定廣告是否自動更新. (Default NO)
- (void)setAdAutoRefresh:(BOOL)bSetAutoRefresh;
#pragma mark 開始取得廣告
- (void)startGetAd:(NSArray *)arrayTestIdentifiers;
#pragma mark 取得廣告View
- (UIView *)getVponAdView;
- (void)bannerPositionChange;

#pragma mark - UserInfomation
#pragma mark 設定使用者資訊-年齡
- (void)setUserInfoAge:(NSInteger)age;
#pragma mark 設定使用者資訊-生日
- (void)setUserInfoBirthdayWithYear:(NSInteger)year Month:(NSInteger)month andDay:(NSInteger)day;
#pragma mark 設定使用者資訊-性別
- (void)setUserInfoGender:(UserInfoGender)gender;
#pragma mark 設定使用者資訊-關鍵字
- (void)setUserInfoKeyword:(NSString *)keyword;

#pragma mark 設定Location開關
- (void)setLocationOnOff:(BOOL)isOn;
#pragma mark  回傳Location狀態
- (BOOL)isUseLocation;
@end
