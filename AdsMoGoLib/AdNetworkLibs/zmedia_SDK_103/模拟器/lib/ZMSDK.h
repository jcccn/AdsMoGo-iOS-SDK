//
//  ADSDK.h
//  lanmeiSDK
//
//  Created by 牛哲 on 14-4-2. qq:282570141  mail:383144384@163.com
//  Copyright (c) 2014年 牛哲. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Foundation/Foundation.h>
#import<SystemConfiguration/SCNetworkReachability.h>
#import <SystemConfiguration/SystemConfiguration.h>
#import <netinet/in.h>
#import <UIKit/UIKit.h>
#import "zlib.h"
#import "sys/sysctl.h"
#import <CoreLocation/CoreLocation.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <CoreTelephony/CTCarrier.h>
#import <ifaddrs.h>
#import <arpa/inet.h>
#import <AdSupport/AdSupport.h>
#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>
#import <SystemConfiguration/CaptiveNetwork.h>  
#import <MessageUI/MessageUI.h>
#import <StoreKit/StoreKit.h>
#define kOpenUDIDErrorNone          0
#define kOpenUDIDErrorOptedOut      1
#define kOpenUDIDErrorCompromised   2
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
typedef enum
{
	SinoNotReachable = 0,
	SinoReachableViaWiFi,
	SinoReachableViaWWAN,
    SinoReachableVia3G,
    SinoReachableVia2G
} SinoNetworkStatus;

#define SinoReachabilityChangedNotification @"kNetworkReachabilityChangedNotification"
@class SinoReachability;
@class InFoManagement;
@class PageInFoManagement;
@class TheNetworkStatus;
@interface ZMSDK : NSObject
{
    
    InFoManagement * infomaster;
}
@property (nonatomic) int AllianceFlag;
+(ZMSDK *) createSharedObjectWithPublishID:(NSString *)PublishID;
+(ZMSDK *) createSharedObjectWithPublishID:(NSString *)PublishID andLocation:(BOOL)flag;
+(ZMSDK *) sharedObject;
+(void) appResign;
+(void)sendErrInfo:(NSMutableDictionary *)dic;
+(UIWebView *)GetBannerWithADSpace:(NSString *)space;
+(void)hiddenBannerWithADSpace:(NSString *)space;
+(void)GetIntervalWithADSpace:(NSString *)space;
+(void)showIntervalWithADSpace:(NSString *)space;//保留方法
+(BOOL)loadIntegralWallWithADSpace:(NSString *)space;
+(BOOL)showIntegralwall;
+(BOOL)closeIntegralwall;
+(void)integralManagement;
+(void)ADReportWithADID:(NSString *)adID andSpace:(NSString *)space andADType:(NSString *)ADtype andReportType:(int)reportType andADIC:(NSString *)adIC;
+(BOOL)JudgementADCanShowWith:(NSDictionary *)ADDic;
+(void)setRequestDelegate:(id)delegate;
+(void)DestructionIntervalWithADSpace:(NSString *)space;
@end

@protocol ZMSDKRequestDelegate

@optional
-(void)ZMSDKIntervalViewDelegateRequestSuccess:(BOOL)flag;
-(void)ZMSDKBannerDelegateRequestSuccess:(BOOL)flag;
@end




@interface InFoManagement : NSObject<CLLocationManagerDelegate>
{
    
    NSString * appStartTime;
    BOOL isFristRun;
    bool isSend;
    bool isErrSend;
    bool isEventSend;
    NSString * appKey;
    NSString * ipaFree;
    CLLocationManager *locationManager;
    CLLocation *checkinLocation;
    NSString *terminalInfoPath;
    NSString *errInfoPath;
    NSString *eventInfoPath;
    NSString *channel;
    NSMutableArray * events;
    TheNetworkStatus * networkManagement;
    NSArray * sendKeyArr;
    
    NSMutableArray * adBigDic;
    
    BOOL haveIntegralWall;
    
}
@property (nonatomic, retain) id<ZMSDKRequestDelegate> RequestDelegate;


@property (retain,nonatomic) NSMutableDictionary * terminalInfo;
@property (retain,nonatomic) NSMutableDictionary * errInfo;
@property (retain,nonatomic) NSMutableDictionary * eventInfo;
@property (retain, nonatomic)NSMutableArray * bannerArr;
@property (retain ,nonatomic)NSMutableArray * intervalArr;

@property (nonatomic) bool locationFlag;
@property (nonatomic) int networkFlag;
@property (nonatomic) int sendFlag;
- (id)initWithPublishID:(NSString *)PublishID;
- (id)initWithPublishID:(NSString *)PublishID andLocation:(BOOL)flag;
-(void)locationManager:(CLLocationManager *)manager
   didUpdateToLocation:(CLLocation *)newLocation
          fromLocation:(CLLocation *)oldLocation;
-(void)locationManager:(CLLocationManager *)manager
      didFailWithError:(NSError *)error;
-(NSString *)getUDIDFlag;
-(BOOL)isFirstStart;
-(void)appExit;
-(void)sendErrInfo:(NSMutableDictionary *)dic;
-(UIWebView *)getBannerWithADSpace:(NSString *)space;
-(void)closeBannerWithADSpace:(NSString *)space;
-(void)getIntervalWithADSpace:(NSString *)space;
-(void)DestructionIntervalWithADSpace:(NSString *)space;
-(BOOL)loadIntegralWallWithADSpace:(NSString *)space;
-(void)ADReportWithADID:(NSString *)adID andSpace:(NSString *)space andADType:(NSString *)ADtype andReportType:(int)reportType andADIC:(NSString *)adIC;
//
-(void)ceshiqingqiu;
-(NSString *)getADTimeOutListPath;
-(BOOL)JudgementADCanShowWith:(NSDictionary *)ADDic;
@end


@interface LFCGzipUtility : NSObject
+(NSData*) gzipData: (NSData*)pUncompressedData;
+(NSData*) ungzipData:(NSData *)compressedData;
@end

@interface NdUncaughtExceptionHandler : NSObject{
    
}
+ (void)setDefaultHandler;
+ (NSUncaughtExceptionHandler*)getHandler;
@end


@interface OpenUDID : NSObject {
}
+ (NSString*) value;
+ (NSString*) valueWithError:(NSError**)error;
+ (void) setOptOut:(BOOL)optOutValue;

@end


@interface SinoReachability: NSObject
{
	BOOL localWiFiRef;
	SCNetworkReachabilityRef reachabilityRef;
}

//reachabilityWithHostName- Use to check the reachability of a particular host name.
+ (SinoReachability*) reachabilityWithHostName: (NSString*) hostName;

//reachabilityWithAddress- Use to check the reachability of a particular IP address.
+ (SinoReachability*) reachabilityWithAddress: (const struct sockaddr_in*) hostAddress;

//reachabilityForInternetConnection- checks whether the default route is available.
//  Should be used by applications that do not connect to a particular host
+ (SinoReachability*) reachabilityForInternetConnection;

//reachabilityForLocalWiFi- checks whether a local wifi connection is available.
+ (SinoReachability*) reachabilityForLocalWiFi;

//Start listening for reachability notifications on the current run loop
- (BOOL) startNotifier;
- (void) stopNotifier;

- (SinoNetworkStatus) currentReachabilityStatus;
//WWAN may be available, but not active until a connection has been established.
//WiFi may require a connection for VPN on Demand.
- (BOOL) connectionRequired;
@end



@interface TheNetworkStatus : NSObject
{
    int isNetType;
}
+ (int) connectedToNetwork;
- (void) SetJianCeNetwork;
- (void) reachabilityChanged: (NSNotification* )note;
- (void) updateInterfaceWithReachability: (SinoReachability*) curReach;
+ (NSString *) whatismyipdotcom;
+ (NSString *)sendDataWithDic:(NSMutableDictionary*)infoDic withFlag:(int)flag;
+(id)sendZipDataWithUrl:(NSString *)urlString andDataStr:(NSString *)dataStr;
+ (NSData *)toJSONData:(id)theData;
+ (id)toArrayOrNSDictionary:(NSData *)jsonData ;
+(id)sendMoth:(NSString *)xxx;
+ (NSString *)getIPAddress;
+(NSString *)currentWifiSSID;
+(id)postMoth:(NSString *)xxx andDataStr:(NSString *)str;
@end
//NSObject
@protocol ZMSDKBannerDelegate

@optional
-(void)ZMSDKBannerDelegateShowSuccess:(BOOL)flag;//banner是否显示成功
-(void)ZMSDKBannerDelegateClick;//banner点击
@end


@interface BannerView : UIWebView<UIGestureRecognizerDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>
{
    NSMutableDictionary * adInfDic;
    NSMutableArray * adList;
    NSTimer *timer;
    int imageCount;
}
@property (nonatomic, retain) id<ZMSDKBannerDelegate> bannerDelegate;
@property (nonatomic,retain)NSString * space;
-(id)initWithADInfoDic:(NSMutableDictionary *)dic andADList:(NSMutableArray *)arr;
-(id)initWithADInfoDic:(NSMutableDictionary *)dic andADList:(NSMutableArray *)arr andDelegate:(id)delegate;
-(void)closeBannerView;
-(void)showBannerView;
@end

@protocol ZMSDKIntervalViewDelegate

@optional
-(void)ZMSDKIntervalViewDelegateLoadSuccess:(BOOL)flag;
-(void)ZMSDKIntervalViewDelegateShowSuccess:(BOOL)flag;
-(void)ZMSDKIntervalViewDelegateClick;
-(void)ZMSDKIntervalViewDelegateClose;
@end


@interface IntervalView : UIWebView<UIGestureRecognizerDelegate,MFMessageComposeViewControllerDelegate,MFMailComposeViewControllerDelegate,SKStoreProductViewControllerDelegate>{
    
    NSDictionary * _adDic;
}
@property (nonatomic, retain) id<ZMSDKIntervalViewDelegate> intervalViewDelegate;
-(id)initWithADInfoDic:(NSMutableDictionary *)dic andADDic:(NSDictionary *)adDic andCloseType:(int)closeType;
-(id)initWithADInfoDic:(NSMutableDictionary *)dic andADDic:(NSDictionary *)adDic andCloseType:(int)closeType andDelegate:(id)delegate;
-(void)updataInitView:(NSDictionary *)adDinc;
-(UIWebView *)getBackgroundView;
+(CGSize) screenSize;
@end

@interface IntervalViewManagement : NSObject{
    NSMutableDictionary * adInfDic;
    NSMutableArray * adList;
    int imageCount;
    IntervalView * intervalView;
    
}

@property (nonatomic,retain)NSString * space;
-(UIWebView *)getView;
-(void)updataView;
- (id)initWithADInfoDic:(NSMutableDictionary *)dic andADList:(NSMutableArray *)arr;
- (id)initWithADInfoDic:(NSMutableDictionary *)dic andADList:(NSMutableArray *)arr andDelegate:(id)delegate;

@end


@interface IntegralwallManagement : NSObject<UITableViewDelegate, UITableViewDataSource>{
    
}
@property (nonatomic,retain) NSString* space;
+(IntegralwallManagement *) sharedObject;
+(IntegralwallManagement *) createSharedObjectWithADList:(NSMutableArray *)arr;
-(BOOL)showIntegralwall;
-(BOOL)closeIntegralwall;
-(void)updataWithADList:(NSMutableArray *)arr;
-(void)setTestFlag;
@end


@interface appInfoCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *jifenLabel;

@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *jianjieLabel;
@property (retain, nonatomic) IBOutlet UILabel *renwuLabel;
@property (retain, nonatomic) IBOutlet UILabel *hqjlLabel;
@property (retain, nonatomic) IBOutlet UIImageView *jifenBackgroundImage;

@end
