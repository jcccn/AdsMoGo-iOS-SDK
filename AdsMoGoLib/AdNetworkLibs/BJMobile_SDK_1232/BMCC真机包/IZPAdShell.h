//
//  IZPAdShell.h
//  IZPViewDev
//
//  Created by tanggang on 12-5-28.
//  Copyright 2012年 Jinuoxun Technology Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _RunModel{
    RUN_MODEL_TEST,//测试模式，用于测试开发。
    RUN_MODEL_RELEASE,//发布模式。
}RunModel;

typedef enum _RequestModel{
    REQUEST_MODEL_SEQUENCE_AD,//连续广告请求。
    REQUEST_MODEL_SINGLE_AD,//单则广告请求。
}RequestModel;


typedef enum _AdType{
    
    IPHONE_BANNER_320_50=1,//320_50/640_100手机横幅(根据分辨率自动匹配)
    
    IPAD_BANNER_728_90=2,//728_90/1456_180平板大横幅(根据分辨率自动匹配)
    IPAD_BANNER_468_60=3,//468_60/936_120平板小横幅(根据分辨率自动匹配)
    
    IPAD_RECTANGLE300_250=4,//矩形广告
    
    IPHONE_FULL_SCREEN_320_568=5,//手机全屏
    IPHONE_FULL_SCREEN_568_320=6,//手机全屏
    
    IPHONE_SQUARE_480_700=7,//手机插屏
    IPHONE_SQUARE_780_400=8,//手机插屏
    
    IPAD_FULL_SCREEN_768_1024=9,//ipad全屏
    IPAD_FULL_SCREEN_1024_768=10,//ipad全屏
    
    IPAD_SQUARE_560_750=11,//ipad插屏
    IPAD_SQUARE_750_560=12,//ipad插屏
    
    
}AdType;

//广告开关效果
typedef enum _AdSwitchEffect{
    AD_SWITCH_RANDOM,
    AD_SWITCH_FADE,
    AD_SWITCH_FLIP_FROM_LEFT,
    AD_SWITCH_FLIP_FROM_TOP,
    AD_SWITCH_CUBE_FROM_LEFT,
    AD_SWITCH_CUBE_FROM_TOP,
    AD_SWITCH_RIPPLE,
    AD_SWITCH_CURL_UP,
    AD_SWITCH_CURL_DOWN,
    AD_SWITCH_ZOOM_IN_FROM_CENTER,
}AdSwitchEffect;


@protocol IZPAdDelegate <NSObject>
@optional
-(void)startAdNotification;                 //广告开始请求回调
-(void)receiveAdNotification;               //广告接收成功回调
-(void)failToAdNotification;                //广告接收失败回调
-(void)clickAdNotification;                 //点击广告回调
-(void)pressedBackButtonNotification;       //广告关闭回调

@end

@interface IZPAdShell : NSObject 

//设置广告请求参数
+(void)setAdParam:(NSString *)sn
            adType:(AdType)type
            locationX:(int)x
            locationY:(int)y;
+(void)setRunModel:(RunModel)runMode;
+(void)setadSwitchEffect:(AdSwitchEffect)effect;//设置广告切换效果
+(void)setRequestModel:(RequestModel)requestModel;
+(void)setDelegate:(id<IZPAdDelegate>) delegate;//设置委托代理对象

//control method for sequence ad request
+(void)startRequestAd;//开始请求广告
+(void)pauseRequestAd;//暂停广告请求
+(void)continueRequestAd;//继续广告请求
+(void)removeRequestAd;//移除广告
+(BOOL)canBeRemoveAd;//是否能移除广告
+(void)startShowAd;//执行广告展示
//get ad view , if you retain it ,so you must release it , otherwise you should do nothing
+(UIView*)getAdView;//获得广告View


+(CGRect)getAdSize:(AdType)adType;


+(CGRect)getUploadSize:(AdType)adType;
@end
