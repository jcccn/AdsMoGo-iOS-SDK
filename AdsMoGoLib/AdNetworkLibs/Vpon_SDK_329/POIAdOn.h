//
//  POIAdOn.h
//  iphone-sdk3.1
//
//  Created by vpon on 12/3/16.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>
#import "AdOnPlatform.h"

@protocol POIAdOnDelegate;
@protocol VponAdOnDelegate;

@interface POIAdOn : NSObject <CLLocationManagerDelegate> {
    
}
@property (nonatomic, retain) id<POIAdOnDelegate> delegate;

#pragma mark 初始化
+ (POIAdOn *)sharedInstance:(id<POIAdOnDelegate>)POIDelegate;
+ (POIAdOn *)sharedInstance;
#pragma mark 請求POI List
- (void)requestPOIList:(NSString *)licensekey withLocation:(CLLocation *)location withRadius:(int)radius platform:(Platform)platform;
#pragma mark 請求廣告
- (void)requestPOIAd:(NSString *)poiId withSize:(CGSize)size;
#pragma mark 請求POI細節
- (void)requestPOIDetail:(NSString *)poiId;
#pragma mark 取得完整POI List
- (NSDictionary *)getFullPOIList;
#pragma mark return plat
- (Platform)getPlatformVpon;
@end

@protocol POIAdOnDelegate <VponAdOnDelegate>

@required

#pragma mark 回傳部分新增的POI List
- (void)onPOIAddAdList:(NSDictionary *)addList;
#pragma mark 回傳部分移除的POI List
- (void)onPOIDelAdList:(NSDictionary *)delList;
#pragma mark 回傳廣告
- (void)onPOIAd:(UIViewController *)banner;
#pragma mark 回傳POI Detail
- (void)onPOIDetail:(NSDictionary *)detail;
#pragma mark 回傳POI List錯誤訊息
- (void)onPOIListFailed:(NSString *)error;
#pragma mark 回傳Banner錯誤訊息
- (void)onPOIAdFailed:(NSString *)error withPOIId:(NSString *)poiId;
#pragma mark 回傳Detail錯誤訊息
- (void)onPOIDetailFailed:(NSString *)error withPOIId:(NSString *)poiId;

@end
