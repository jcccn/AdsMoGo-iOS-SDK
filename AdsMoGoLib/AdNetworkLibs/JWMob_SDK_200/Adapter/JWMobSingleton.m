//
//  JWMobSingleton.m
//  wanghaotest
//
//  Created by MOGO on 15-4-24.
//
//
#import "AdMoGoLogCenter.h"
#import "JWMobSingleton.h"
#import <JWMobAdSDK/JWPopScreenAdView.h>
#import <JWMobAdSDK/JWFullScreenAdView.h>
// 如果请求全屏请将FullScreen 设置1
// 如果请求插屏请将FullScreen 设置0
#define FullScreen 0
typedef NS_ENUM(NSUInteger, JWMobStatus) {
    JWMobDefault,
    JWMobRequestSuccess,
    JWMobRequestFail,
    JWMobShowSuccess,
    JWMobShowFail,
};

static JWMobSingleton *jwmobsingleton= nil;
@interface JWMobSingleton ()<JWPopScreenAdDelegate,JWFullScreenAdDelegate>{
    JWMobStatus jwmobstatus;
}
@end


@implementation JWMobSingleton
+ (id)shareInstance{
    if (jwmobsingleton==nil) {
        jwmobsingleton = [[JWMobSingleton alloc] init];
        
    }
    return jwmobsingleton;
}

-(id)init{
    if ((self = [super init])) {

        
    }
    return self;
}

- (void)setJWinitByID:(NSString *)idstr{
#if FullScreen
    [JWFullScreenAdView createFullScreenAdWithID:idstr
                                        delegate:self
                                   enableLogging:NO
                                          isTest:NO];
    
#else
    [JWPopScreenAdView createPopScreenAdWithID:idstr
                                      delegate:self
                                 enableLogging:NO
                                        isTest:NO];
    
#endif
}

- (void)loadAd{
    jwmobstatus = JWMobDefault;
#if FullScreen
   [JWFullScreenAdView loadFullScreenAd];
#else
    [JWPopScreenAdView loadPopScreenAd];
#endif
    
}

- (void)showAd{
#if FullScreen
     [JWFullScreenAdView showFullScreenAd];
#else
     [JWPopScreenAdView showPopScreenAd];
#endif
   
}
#pragma mark - JWPopScreenAdDelegate
/*!
 @method
 @abstract 插屏广告加载成功时调用本方法
 */
- (void)didReceviedPopScreenAd{
    if (jwmobstatus != JWMobDefault) {
        return;
    }
    jwmobstatus = JWMobRequestSuccess;
    if ([self.delegate respondsToSelector:@selector(requestAdSuccess)]) {
        [self.delegate requestAdSuccess];
    }
}

/*!
 @method
 @abstract 插屏广告加载失败时调用本方法
 @param errorCode (错误码)
 */
- (void)didFailReceivePopScreenAd:(NSString *)errorCode{
    MGLog(MGT,@"errorcode %@", errorCode);
    if (jwmobstatus != JWMobDefault) {
        return;
    }
    jwmobstatus = JWMobRequestFail;
    if ([self.delegate respondsToSelector:@selector(requestAdFail)]) {
        [self.delegate requestAdFail];
    }
}


/*!
 @method
 @abstract 插屏广告成功展示时调用本方法
 */
- (void)onShowPopScreenAd{
    if (jwmobstatus != JWMobDefault) {
        return;
    }
    jwmobstatus = JWMobShowSuccess;
    if ([self.delegate respondsToSelector:@selector(loadAdSuccess)]) {
        [self.delegate loadAdSuccess];
    }
}


/*!
 @method
 @abstract 插屏广告展示失败时调用本方法
 @param errorCode (错误码)
 */
- (void)didFailShowPopScreenAd:(NSString *)errorCode{
    if (jwmobstatus != JWMobDefault) {
        return;
    }
    jwmobstatus = JWMobShowFail;
    if ([self.delegate respondsToSelector:@selector(loadAdFail)]) {
        [self.delegate loadAdFail];
    }
}


/*!
 @method
 @abstract 插屏广告关闭后调用本方法
 */
- (void)onClosePopScreenAd{
    if ([self.delegate respondsToSelector:@selector(adClose)]) {
        [self.delegate adClose];
    }
}


#pragma mark - JWFullScreenAdDelegate
/*!
 @method
 @abstract 全屏广告加载成功时调用本方法
 */
- (void)didReceviedFullScreenAd{
    if (jwmobstatus != JWMobDefault) {
        return;
    }
    jwmobstatus = JWMobRequestSuccess;
    if ([self.delegate respondsToSelector:@selector(requestAdSuccess)]) {
        [self.delegate requestAdSuccess];
    }
}

/*!
 @method
 @abstract 全屏广告加载失败时调用本方法
 @param errorCode (错误码)
 */
- (void)didFailReceiveFullScreenAd:(NSString *)errorCode{
    MGLog(MGT,@"errorcode %@", errorCode);
    
    if (jwmobstatus != JWMobDefault) {
        return;
    }
    jwmobstatus = JWMobRequestFail;
    if ([self.delegate respondsToSelector:@selector(requestAdFail)]) {
        [self.delegate requestAdFail];
    }
}

/*!
 @method
 @abstract 全屏广告成功展示时调用本方法
 */
- (void)onShowFullScreenAd{
    if (jwmobstatus != JWMobDefault) {
        return;
    }
    jwmobstatus = JWMobShowSuccess;
    if ([self.delegate respondsToSelector:@selector(loadAdSuccess)]) {
        [self.delegate loadAdSuccess];
    }
}

/*!
 @method
 @abstract 全屏广告展示失败时调用本方法
 @param errorCode (错误码)
 */
- (void)didFailShowFullScreenAd:(NSString *)errorCode{
    if (jwmobstatus != JWMobDefault) {
        return;
    }
    jwmobstatus = JWMobShowFail;
    if ([self.delegate respondsToSelector:@selector(loadAdFail)]) {
        [self.delegate loadAdFail];
    }
}

/*!
 @method
 @abstract 全屏广告关闭后调用本方法
 */
- (void)onCloseFullScreenAd{
    if ([self.delegate respondsToSelector:@selector(adClose)]) {
        [self.delegate adClose];
    }
}

@end
