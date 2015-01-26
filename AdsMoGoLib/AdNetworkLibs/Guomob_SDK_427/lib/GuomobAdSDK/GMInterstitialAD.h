//
//  GMInterstitialAD.h
//  GMInterstitialAD
//
//  Created by qq on 13-1-7.
//  Copyright (c) 2013年 AK. All rights reserved.
//

//************************************说明*****************************************//
//*GuomobAdSDK 在iphone ipod 上展示尺寸为300*250的广告  在ipad上展示尺寸为480*320的广告   *//
//********************************************************************************//

#import <Foundation/Foundation.h>
//#import <QuartzCore/QuartzCore.h>
@protocol GMInterstitialDelegate <NSObject>

@optional
- (void)loadInterstitialAdSuccess:(BOOL)success;//加载成功
- (void)closeInterstitialAD;//关闭广告
- (void)InterstitialConnectionDidFailWithError:(NSString *)error;//请求内容返回的错误
@end


@interface GMInterstitialAD : UIView<UIGestureRecognizerDelegate,GMInterstitialDelegate>
{
    id< GMInterstitialDelegate > delegate; 
}
@property(nonatomic,retain)id< GMInterstitialDelegate > delegate;
//参数 appkey 为应用密钥
- (id)initWithId:(NSString *)appKey;// ad ID

//加载展示广告 参数isalloc 设置是否允许旋转
- (void)loadInterstitialAd:(BOOL)isalloc;
@end
