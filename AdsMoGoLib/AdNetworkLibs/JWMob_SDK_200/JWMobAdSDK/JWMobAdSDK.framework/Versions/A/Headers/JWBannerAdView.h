//
//  JWBannerAdView.h
//  横幅广告
//  Ver:2.0.0
//

/*!
 @protocol JWBannerAdDelegate
 @abstract 横幅广告代理协议类
 */
@protocol JWBannerAdDelegate <NSObject>
@optional

/*!
 @method
 @abstract 横幅广告成功展示时调用本方法
 */
- (void)onShowBannerScreenAd;

/*!
 @method
 @abstract 横幅广告展示失败时调用本方法
 @param errorCode (错误码)
 */
- (void)didFailReceiveBannerAd:(NSString *)errorCode;

/*!
 @method
 @abstract 横幅广告隐藏时调用本方法
 */
- (void)onHiddenBannerScreenAd;
@end

/*!
 @class JWBannerAdView
 @superclass NSObject
 @abstract 横幅广告类
 */
@interface JWBannerAdView : NSObject

/*!
 @method
 @abstract 初始化横幅广告
 @param bannerAdID (横幅广告位ID)
 @param delegate (代理类, 设置回调函数用)
 @param enable (是否打印log日志)
 @param isTest (是否测试数据)
 */
+ (void)createBannerAdWithID:(NSString *)bannerAdID
                    delegate:(id<JWBannerAdDelegate>)delegate
               enableLogging:(BOOL)enable
                      isTest:(BOOL)isTest;

/*!
 @method
 @abstract 加载并显示横幅广告
 @param superView (横幅广告的父view)
 */
+ (void)showBannerAd:(UIView *)superView;

/*!
 @method
 @abstract 隐藏横幅广告
 */
+ (void)hiddenBannerAd;

/*!
 @method
 @abstract 改变横幅广告坐标
 @param position (坐标)
 */
+ (void)setPosition:(CGPoint)position;
@end
