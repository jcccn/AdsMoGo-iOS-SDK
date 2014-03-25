//
//  testsdk.h
//  testsdk
//
//  Created by qq on 12-8-29.
//  Copyright (c) 2012年 AK. All rights reserved.
//
//************************************说明*****************************************//
//*GuomobAdSDK 在iphone ipod 上展示尺寸为320*50的广告  在ipad上展示尺寸为728*90的广告   *//
//********************************************************************************//


#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol GuomobAdSDKDelegate <NSObject>

@required
//返回true为成功
- (void)loadBannerAdSuccess:(BOOL)success;//加载成功
- (void)BannerConnectionDidFailWithError:(NSError *)error;//请求内容返回的错误
@end

@interface GuomobAdSDK : UIView<GuomobAdSDKDelegate>
{
   id< GuomobAdSDKDelegate > delegate; 
}

@property(nonatomic,assign)id< GuomobAdSDKDelegate > delegate;

//appKey 应用密钥

//接口参数
+(id)initWithAppId:(NSString *)appkey delegate:(id)delegate; // 应用密钥
                
//加载展示广告(isalloc是否允许旋转)
- (void)loadAd:(BOOL)isalloc;


@end