//
//  NativeAd.h
//  DomobAdSDK
//
//  Copyright (c) 2014年 Domob Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DOARCMacros.h"

@interface DMNativeResourceModel : NSObject


//资源URL
@property (nonatomic, DO_STRONG) NSString *adUrl;
//资源宽
@property (nonatomic, assign) NSUInteger adWidth;
//资源高
@property (nonatomic, assign) NSUInteger adHeight;

@end

@interface DMNativeAdModel : NSObject

//广告标题
@property (nonatomic, DO_STRONG) NSString *adTitle;
//简介 字数限制是8-32字
@property (nonatomic, DO_STRONG) NSString *adBrief;
//描述 字数限制是33-80字
@property (nonatomic, DO_STRONG) NSString *adDescription;
//要处理的事件的文字
@property (nonatomic, DO_STRONG) NSString *adActionText;

//广告icon
@property (nonatomic, DO_STRONG) DMNativeResourceModel *adIcon;
//广告大图
@property (nonatomic, DO_STRONG) DMNativeResourceModel *adMedia;
//星级
@property (nonatomic, assign) NSUInteger adRatings;
//下载数
@property (nonatomic, assign) NSUInteger adDownloads;
//资源大小
@property (nonatomic, assign) NSUInteger adSize;


@end

@protocol DMNativeAdDelegate <NSObject>

@required
//数据加载成功
- (void)dmNativeAdSuccessToLoadAd:(DMNativeAdModel *)adDataModel;
//数据加载失败
- (void)dmNativeAdFailToLoadAdWithError:(NSError *)error;

@end

@interface DMNativeAd : NSObject

@property (nonatomic, DO_WEAK) DMNativeAdModel *nativeModel;

@property (nonatomic, DO_WEAK) id<DMNativeAdDelegate> delegate;

- (id)initWithPublisherId:(NSString *)publisherId // Publisher ID
              placementId:(NSString *)placementId // Placement ID
       rootViewController:(UIViewController *)rootViewController
                 delegate:(id<DMNativeAdDelegate>)delegate;
//加载广告
- (void)loadAd;
//展现报告的发送
- (void)trackImpression;
//处理事件的方法
- (void)processClickAction;

@end
