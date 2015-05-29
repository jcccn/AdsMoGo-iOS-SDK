#import <Foundation/Foundation.h>
#import <UIKit/UIkit.h>

#define LIB_VERSION_NUMBER         @"3.1"

#define CS_CONNECT_SUCCESS                @"CS_Connect_Success"
#define CS_CONNECT_FAILED                 @"CS_Connect_Failed"

#define CS_GET_BANNER_SUCCESS             @"cs_get_banner_success"
#define CS_GET_BANNER_FAILED              @"cs_get_banner_failed"
#define CS_HF_SHOW                          @"CS_HF_SHOW"
#define CS_HF_CLICK                         @"CS_HF_CLICK"
#define CS_HF_FAILED                        @"CS_HF_FAILED"
#define CS_HF_CLOSED                        @"CS_HF_CLOSED"

#define CS_CP_INIT_SUCESS              @"CS_CP_INIT_SUCESS"
#define CS_CP_INIT_NULL                @"CS_CP_INIT_NULL"
#define CS_CP_INIT_FAILED              @"CS_CP_INIT_FAILED"
#define CS_CP_SHOW_SUCESS              @"CS_CP_SHOW_SUCESS"
#define CS_CP_SHOW_FAILED              @"CS_CP_SHOW_FAILED"
#define CS_CP_CLOSED                   @"CS_CP_CLOSED"
#define CS_CP_CLICK                    @"CS_CP_CLICK"

#define AD_SIZE_320X50        @"320x50"
#define AD_SIZE_375x65        @"375x60"
#define AD_SIZE_414x70        @"414x70"
#define AD_SIZE_480X75        @"480X75"
#define AD_SIZE_640X100       @"640x100"
#define AD_SIZE_768X90        @"768x90"
#define AD_SIZE_768X100       @"768x100"

@protocol CSConnectDelegate;
static  NSString *appID_;
@interface CSConnect : NSObject{
    NSString *userID_;
    NSString *plugin_;
    NSMutableData *data_;
    int connectAttempts_;
    BOOL isInitialConnect_;
    NSInteger responseCode_;
    NSURLConnection *connectConnection_;
    NSURLConnection *userIDConnection_;
    NSURLConnection *SDKLessConnection_;
    NSString *appChannel_;
    NSString *appleID_;
    UIView *bannerView;
}
@property(nonatomic, copy) NSString *appChannel;
@property(nonatomic, copy) NSString *userID;
@property(nonatomic, copy) NSString *plugin;
@property(nonatomic, copy) NSMutableDictionary *configItems;
@property(nonatomic, copy) NSString *appleID;
@property(assign) BOOL isInitialConnect;
@property(assign) BOOL isAutoGetPoints;
@property(nonatomic, retain) id <CSConnectDelegate> delegate;


+ (CSConnect *)getConnect:(NSString *)id;

+ (CSConnect *)getConnect:(NSString *)id pid:(NSString *)channel;

+ (CSConnect *)getConnect:(NSString *)id pid:(NSString *)channel userID:(NSString *)theUserID;

+ (CSConnect *)sharedCSConnect;

+ (NSString *)getUserID;

+ (NSMutableDictionary *)getConfigItems;

+ (NSString *)getAPPID;

@end

@interface CSConnect (CSHFViewHandler)

+ (void)showHF:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;

+ (void)showHF:(UIViewController *)vController adSize:(NSString *)aSize;

+ (void)showHF:(UIViewController *)vController;

+ (void)showHF:(UIViewController *)vController showX:(CGFloat)x showY:(CGFloat)y;

+ (void)closeHF;

+ (void)initHFView:(NSString *)aSize;

@end

@interface CSConnect (CSCPViewController)

+ (void)initCP;

+ (void)showCP:(UIViewController *)controller;

+ (void)showCP:(UIViewController *)controller urlStr:(NSString *)urlStr;

+ (void)closeCP;

@end

@interface CSCallsWrapper : UIViewController {
    UIInterfaceOrientation currentInterfaceOrientation;
}

@property(assign) UIInterfaceOrientation currentInterfaceOrientation;

+ (CSCallsWrapper *)sharedCSCallsWrapper;

- (void)updateViewsWithOrientation:(UIInterfaceOrientation)interfaceOrientation;

@end






