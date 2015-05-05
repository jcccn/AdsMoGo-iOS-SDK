//
//  AdMoGoFeedsAdNetworkAdapter.h
//  AdsMoGoNatives
//
//  Created by MOGO on 15-1-4.
//  Copyright (c) 2015年 MOGO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AdsMoGoNativeDelegate.h"
#import "AdsMoGoNative.h"
#import "AdMoGoNativeRegistry.h"
#define NativeTimerOut 8
typedef enum {
    AdMoGoNativeAdNetworkTypeCustom       = 9,
    AdMoGoNativeAdNetworkTypeInMobi       = 18,
    
    AdMoGoNativeAdNetworkTypeMoGo         = 27,
    AdMoGoNativeAdNetworkTypeDoMob        = 29,
    AdMoGoNativeAdNetworkTypeMobiSage     = 31,
    AdMoGoNativeAdNetworkTypeAdwo         = 33,
    AdMoGoNativeAdNetworkTypeBaiduMobAd   = 44,
    AdMoGoNativeAdNetworkTypeExchange     = 45,
    AdMoGoNativeAdNetworkTypePremiumAD    = 48,
    AdMoGoNativeAdNetworkTypeRecommendAD  = 54,
    AdMoGoNativeAdNetworkTypeTanx = 55,
    
    
    AdMoGoNativeAdNetworkTypeGDTMob        = 107,
    
    AdMoGoNativeAdNetworkTypeS2S_First         = 1000,
    AdMoGoNativeAdNetworkTypeS2S_Last          = 1499,
    AdMoGoNativeAdNetworkTypeAutoOptimization  = 2000,
    
} AdMoGoNativeAdNetworkType;


@class AdMoGoNativeAdNetworkAdapter;






//适配器约定
@protocol AdMoGoNativeAdNetworkAdapterDelegate <NSObject>
- (void)requestAdNetworkAdapterAdSuccess:(NSArray *)adsmogonativeadlist adapter:(AdMoGoNativeAdNetworkAdapter*)adapter;
- (void)requestAdNetworkAdapterAdFail:(int) errorCode adapter:(AdMoGoNativeAdNetworkAdapter*)adapter;
- (NSDictionary *)getInmobiinbis;
@end

@interface AdMoGoNativeAdNetworkAdapter : NSObject
// 保存每个平台数据
@property (nonatomic,retain) NSDictionary *ration;
@property (nonatomic,retain) NSDictionary * appKeys;
@property (nonatomic,assign) id<AdMoGoNativeAdNetworkAdapterDelegate> adsMoGoNative;
@property (nonatomic,assign) id<AdsMoGoNativeDelegate> delegate;
@property (nonatomic,retain) NSString *adCount;
@property (nonatomic,retain) NSString *mogoID;
@property (nonatomic,retain) NSTimer  * adTimeout;




- (id)initWithAdMoGoDelegate:(id<AdsMoGoNativeDelegate>)delegate
                        core:(id<AdMoGoNativeAdNetworkAdapterDelegate>)core
               networkConfig:(NSDictionary *)netConf;
//开始请求平台广告
//adcount请求广告条数
- (void)loadAd:(int)adcount;
//展示广告
-(void)attachAdView:(UIView*)view nativeData:(AdsMogoNativeAdInfo*)info;
//点击广告
-(void)clickAd:(AdsMogoNativeAdInfo*)info;
//停止请求广告
- (void)stopAd;
//请求广告超时
- (void)loadAdTimeOut:(NSTimer*)theTimer;
//获取ViewController
-(UIViewController*)getAdMogoViewController;
//获取芒果转换成芒果数据
-(NSDictionary*)getMogoJsonByDic:(AdsMogoNativeAdInfo*)info;
-(NSDictionary*)getMogoDicByInfo:(AdsMogoNativeAdInfo*)info;


//反馈的list必须是子类必须是AdsMogoNativeAdInfo
-(void)adMogoNativeSuccessAd:(NSArray*)adList;
-(void)adMogoNativeFailAd:(int)errorCode;
-(NSDictionary *)inmobiinbis;

@end


