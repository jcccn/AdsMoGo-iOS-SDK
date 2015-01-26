//
//  RmobInterstitial.h
//  Rmob-SDK
//
//  Copyright (c) 2013年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RmobInterstitialDelegate.h"
#import "RmobSDK.h"

//插屏广告尺寸，按宽高以下比例显示
typedef enum
{
    RMOB_INTERSTITIALAD_SIZE_50 =0,                               
    RMOB_INTERSTITIALAD_SIZE_75,        
    RMOB_INTERSTITIALAD_SIZE_100,
} RMOB_INTERSTITIALAD_SIZE;

@interface RmobInterstitial : NSObject

#pragma mark 初始化

//插屏广告的delegate，在请求广告之前设置
//在释放插屏广告实例之前请把delegate设为nil
/**
 
 */
@property (nonatomic, assign) id<RmobInterstitialDelegate> delegate;

//adAppID:应用id
//adSize:广告显示尺寸
//model:广告类型（测试广告/正式广告）
- (id)initWithAppId:(NSString *)appID adzoneid:(NSString *)adzoneid adSize:(RMOB_INTERSTITIALAD_SIZE)adSize mode:(Mode)mode;

//请求插屏广告
//通常在显示插屏广告之前几秒请求广告，等要显示时可以及时显示，减少延时
- (void)loadRequest;

//插屏广告是否准备就绪
@property (nonatomic, readonly) BOOL isReady;

//使用viewController显示插屏广告
- (void)presentFromRootViewController:(UIViewController *)rootViewController;


@end

