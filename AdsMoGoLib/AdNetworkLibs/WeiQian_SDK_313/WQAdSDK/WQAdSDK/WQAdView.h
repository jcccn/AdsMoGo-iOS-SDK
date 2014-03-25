//
//  WQAdView.h
//  ORMMA
//
//  Created by hucent on 9/7/12.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class WQAdView;

@protocol WQAdViewDelegate;
@protocol WQAdViewDelegate <NSObject>
@optional

// Called just before an ad closes
//广告关闭前调用
- (void)adWillClose;

// Called just after an ad closes
//广告关闭后调用
- (void)adDidClose;

//成功接收到广告时调用
- (void)onWQAdReceived:(WQAdView *)adview;

//接收广告失败
- (void)onWQAdFailed:(WQAdView *)adview;

//退出广告时调用
- (void)onWQAdDismiss:(WQAdView *)adview;

//广告点击时调用
- (void)onWQAdClicked:(WQAdView*) adview;

//广告查看成功调用
- (void)onWQAdViewed:(WQAdView*) adview;

//广告进入全屏前回调，如进入内置浏览器
-(void)onWQAdWillPresentScreen:(WQAdView *) adview;

//广告退出全屏时回调，如退出内置浏览器
-(void)onWQAdDidDismissScreen:(WQAdView *) adview;

@end
NS_CLASS_AVAILABLE_IOS(5_0)
@interface WQAdView : UIView
@property(nonatomic,retain) NSMutableArray *adviews;
@property(nonatomic,assign) id <WQAdViewDelegate> delegate;
@property(nonatomic,assign) BOOL isViewable;
@property(nonatomic,assign) BOOL isActiveNotification;
@property BOOL storeKitEnabled;

+(void) openAdWallWithAdSlotId:(NSString*)pSlotId accountKey:(NSString*)pAccountKey inViewController:(UIViewController*)pController withStoreKitEnabled:(BOOL)pStoreKitEnabled;

- (id)init;

- (id)init:(BOOL)enableLocation;

- (id)initWithLocation;

- (id)initWithFrame:(CGRect)frame;

- (id)initWithLocationWithFrame:(CGRect)frame;

- (void)startWithAdSlotID:(NSString *)adslotid AccountKey:(NSString *)accountKey InViewController:(UIViewController *)controller;

@end
