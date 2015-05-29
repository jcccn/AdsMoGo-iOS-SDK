//
//  JWFullScreenAdView.h
//  全屏广告
//  Ver:2.0.0
//

/*!
 @protocol JWFullScreenAdDelegate
 @abstract 全屏广告代理协议类
 */
@protocol JWFullScreenAdDelegate <NSObject>
@optional

/*!
 @method
 @abstract 全屏广告加载成功时调用本方法
 */
- (void)didReceviedFullScreenAd;

/*!
 @method
 @abstract 全屏广告加载失败时调用本方法
 @param errorCode (错误码)
 */
- (void)didFailReceiveFullScreenAd:(NSString *)errorCode;

/*!
 @method
 @abstract 全屏广告成功展示时调用本方法
 */
- (void)onShowFullScreenAd;

/*!
 @method
 @abstract 全屏广告展示失败时调用本方法
 @param errorCode (错误码)
 */
- (void)didFailShowFullScreenAd:(NSString *)errorCode;

/*!
 @method
 @abstract 全屏广告关闭后调用本方法
 */
- (void)onCloseFullScreenAd;
@end

/*!
 @class JWFullScreenAdView
 @superclass NSObject
 @abstract 全屏广告类
 */
@interface JWFullScreenAdView : NSObject

/** 初始化全屏广告
 @param fullScreenAdID:全屏广告位ID
              delegate:代理类
         enableLogging:是否打印log日志
                isTest:是否测试数据
 */
+ (void)createFullScreenAdWithID:(NSString *)fullScreenAdID
                        delegate:(id<JWFullScreenAdDelegate>)delegate
                   enableLogging:(BOOL)enable
                          isTest:(BOOL)isTest;

/*!
 @method
 @abstract 加载全屏广告，每次需要展示广告前请先调用本方法，并根据加载是否成功来决定是否展示广告
 */
+ (void)loadFullScreenAd;

/*!
 @method
 @abstract 展示全屏广告
 */
+ (void)showFullScreenAd;

@end
