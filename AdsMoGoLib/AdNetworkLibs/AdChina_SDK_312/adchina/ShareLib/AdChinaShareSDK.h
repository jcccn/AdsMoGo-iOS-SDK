//
//  AdChinaShareSDK.h
//  AdChinaSShareKitTest
//
//  Created by Chasel on 14-1-20.
//  Copyright (c) 2014年 Chasel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "ACShareView.h"

#define  AdChinaShareText  @"text"
#define  AdChinaShareImage @"img"
#define  AdChinaShareHtml  @"html"
#define  AdChinaShareAudio @"audio"
#define  AdChinaShareVideo @"video"

@class AdShareContext;
typedef enum {
    AdChinaShareAdapterTypeSinaWeiWx             = 1,
    AdChinaShareAdapterTypeSinaWeiWxFriend       = 2,
    AdChinaShareAdapterTypeSinaQQfriend          = 3,
    AdChinaShareAdapterTypeSinaQzone             = 4,
    AdChinaShareAdapterTypeSinaWeibo             = 6,
    AdChinaShareAdapterTypeSinaEmail             = 7,
    AdChinaShareAdapterTypeSinaMessage           = 8,
    AdChinaShareAdapterTypeSinaPassbook          = 9,
    AdChinaShareAdapterTypeSinaPhone             = 10
} AdChinaShareAdapterType;
@protocol AdChinaShareSDKDelegate<NSObject>
- (UIViewController *)AdChinaSShareKitViewControllerForPresent;
//开始分享
-(void)shareStart:(NSNumber*)shareType;
//开始授权
-(void)oAuthStart:(NSNumber*)shareType;
-(void)oAuthFinish:(NSNumber*)isSucceed  shareType:(NSNumber*)shareType;
-(void)shareFinish:(NSNumber*)isSucceed  shareType:(NSNumber*)shareType;

-(AdShareContext*)AdChinaShareContext;

@end

@interface AdChinaShareSDK : UIView
/**
 *  注册应用,此方法在应用启动时调用一次并且只能在主线程中调用。
 *
 *  @param appKey 	应用Key,在AdChinaSDK官网中注册的应用Key
 */
+ (void)registerAdChinaApp:(NSString *)appKey;
/**
 *  一键分享按钮
 *
 *  @param point 按钮位置
 *
 *  @return 分享按钮
 */
-(void)createShareBtn:(CGPoint)point appKey:(NSString*)appkey delegate:(id<AdChinaShareSDKDelegate>)delegate inView:(UIView*)view;
-(ACShareView *)createShareViewByAppKey:(NSString*)appkey delegate:(id<AdChinaShareSDKDelegate>)delegate;



@end


@interface AdShareContext : NSObject
@property(strong,nonatomic) NSString * title;
@property(strong,nonatomic) NSString * detail;
@property(strong,nonatomic) NSString * ctype;
@property(strong,nonatomic) NSString * conturl;
@property(strong,nonatomic) NSString * thumbnail;
@property(strong,nonatomic) NSString * clickUrl;
@end





