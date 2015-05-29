//
//  JWPopScreenAdView.h
//  插屏广告
//  Ver:2.0.0
//

/*!
 @protocol JWPopScreenAdDelegate
 @abstract 插屏广告代理协议类
 */
@protocol JWPopScreenAdDelegate <NSObject>
@optional

/*!
 @method
 @abstract 插屏广告加载成功时调用本方法
 */
- (void)didReceviedPopScreenAd;

/*!
 @method
 @abstract 插屏广告加载失败时调用本方法
 @param errorCode (错误码)
 */
- (void)didFailReceivePopScreenAd:(NSString *)errorCode;

/*!
 @method
 @abstract 插屏广告成功展示时调用本方法
 */
- (void)onShowPopScreenAd;

/*!
 @method
 @abstract 插屏广告展示失败时调用本方法
 @param errorCode (错误码)
 */
- (void)didFailShowPopScreenAd:(NSString *)errorCode;

/*!
 @method
 @abstract 插屏广告关闭后调用本方法
 */
- (void)onClosePopScreenAd;
@end

/*!
 @class JWPopScreenAdView
 @superclass NSObject
 @abstract 插屏广告类
 */
@interface JWPopScreenAdView : NSObject

/*!
 @method
 @abstract 初始化插屏广告
 @param popScreenAdID (插屏广告位ID)
 @param delegate (代理类, 设置回调函数用)
 @param enable (是否打印log日志)
 @param isTest (是否测试数据)
 */
+ (void)createPopScreenAdWithID:(NSString *)popScreenAdID
                       delegate:(id<JWPopScreenAdDelegate>)delegate
                  enableLogging:(BOOL)enable
                         isTest:(BOOL)isTest;

/*!
 @method
 @abstract 加载插屏广告，每次需要展示广告前请先调用本方法，并根据加载是否成功来决定是否展示广告
 */
+ (void)loadPopScreenAd;

/*!
 @method
 @abstract 展示插屏广告
 */
+ (void)showPopScreenAd;
@end
