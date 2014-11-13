
#import <UIKit/UIKit.h>
#import "MBJoy_public.h"
extern NSString * const   MBJoyAccountname;     // 多帐号，用于区分APP用户
extern NSString * const   MBJoySDKVer;

/*!
 @enum MBJoyType
 @constant MBJoyTypeBanner = 1, //banner 横幅广告
 @constant MBJoyTypeFullScreen=2, //全屏广告
 @constant MBJoyTypeList = 3, //积分墙广告
 @constant MBJoyTypeMediumRectangle=4  //插屏广告
 @constant MBJoyTypeDefault=5 //定制FW
 */

typedef enum  {
    MBJoyTypeBanner = 1, //banner 横幅广告
    MBJoyTypeFullScreen=2, //全屏广告
    MBJoyTypeList = 3, //积分墙广告
    MBJoyTypeMediumRectangle=4,  //插屏广告
    MBJoyTypeDefault=5 //定制FW
} MBJoyType;


@class MBJoyView;

/*!
 @protocol
 @abstract 这个MBJoyView类的一个protocol
 @discussion 用于实时通知MBJoyView的一系列行为
 */

@protocol MBJoyViewDelegate <NSObject>


@optional


/*!
 @method
 @abstract  用于实时回调通知当前的广告状态
 @discussion 用于实时回调通知当前的广告状态。
 @param MBJoyView 当前的实例对象
 */
- (void)mBJoyViewDidReceiveAd:(MBJoyView*)mBJoyView;
/*!
 @method
 @abstract  返回MBJoyView执行过程中的error信息
 @discussion 用于实时回调通知当前的广告状态。
 @param MBJoyView 当前的实例对象
 @param errorCode 服务器返回的错误码
 */
- (void)mBJoyView: (MBJoyView*) mBJoyView didFailToReceiveMBJoyAdWithError: (NSInteger) errorCode;


/*!
 @method
 @abstract  广告从界面上移除或被关闭时被调用
 @param MBJoyView 当前的实例对象
 */
- (void)mBJoyOnDismissScreen:(MBJoyView *)mBJoyView;

/*!
 @method
 @abstract  当广告调用一个新的页面并且会导致离开目前运行程序时被调用,如:打开appStore
 @param MBJoyView 当前的实例对象
 */
- (void)mBJoyOnLeaveApplication:(MBJoyView *)mBJoyView;


/*!
 @method
 @abstract  广告页面被创建或显示在覆盖在屏幕上面时调用本方法
 @param MBJoyView 当前的实例对象
 */
- (void)mBJoyOnPresentScreen:(MBJoyView *)mBJoyView;

/*!
 @method
 @abstract  用于通知账户设置情况
 @discussion 用于通知账户设置情况,如果email账号未设置,此方法会被调用到。
 @param MBJoyView 当前的实例对象
 */
- (void)mBJoyEmailNotSetupForAd:(MBJoyView *)mBJoyView;

/*!
 @method
 @abstract  积分查询回调方法
 @discussion 用于通知账户设置情况。
 @param score 积分总数
 @param message 错误信息
 */
- (void)mBJoyQueryScore:(NSUInteger)score withMessage:(NSString *)message;
/*!
 @method
 @abstract  积分减少回调方法
 @discussion 用于通知账户设置情况。
 @param status 状态返回 YES\NO
 @param message 错误信息
 */
- (void)mBJoyReduceScore:(BOOL)status withMessage:(NSString *)message;
@end

/*!
 @class
 @abstract MBJoyView是展示广告的载体。
 */

@interface MBJoyView : UIView

/*!
 @property
 @abstract 在力美广告平台获取到的广告位ID,此ID为与广告平台通信的依据,注:此ID需审核通过后方可使用。广告位无效或关闭会报100021的错误。
 */
@property (nonatomic, retain) NSString *unitId;

/*!
 @property
 @abstract MBJoyView 的Delegate,用于实现一些方法回调。
 */
@property (nonatomic, assign) id<MBJoyViewDelegate> delegate;

/*!
 @property
 @abstract 此属性用于标识当前广告是否可用，用户可以根据当前广告的状态来决定当前广告是否显示,适用于插屏及全屏广告。
 */
@property (nonatomic, assign) BOOL isReady;


/*!
 @method
 @abstract  初始化MBJoyView
 @discussion 用于MBJoyView的初始化,需要把从广告平台申请的广告位作的参数传进去。
 @param adUnitId (NSString --required)从力美广告平台获取到的广告位
 @param type (AdType --required)当前的广告类型，详情请参见AdType
 @param rootVC (UIViewController --optional)此参数为可选参数
 @param userinfo (NSDictionary --optional) 用户信息设置  @{accountname: @"user's id"}
 @result MBJoyView的实例
 */
-(id)initWithUnitId:(NSString *)unitIdStr mBJoyType:(MBJoyType)type rootViewController:(UIViewController *)rootVC userInfo:(NSDictionary *)userinfo;


/*!
 @method
 @abstract 加载广告。
 @discussion  MBJoyViewRequest方法被调用后,会开始加载广告内容并展示出来(插屏广告除外)。
 */
-(void)mBJoyRequest;
/*!
 @method
 @abstract 用于展示广告。
 @discussion  MBJoyViewDisplay被调用时,必须保证MBJoyView在最上层,如不在最上层，会导致广告无法正常展示。
 */
-(void)mBJoyDisplay;

/*!
 @method
 @abstract MBJoyView的显示。
 @discussion 此方法与MBJoyViewHide相对应。
 */
-(void)mBJoyShow;
/*!
 @method
 @abstract MBJoyView的隐藏。
 @discussion 此方法与MBJoyViewShow相对应。
 */
-(void)mBJoyHide;
/*!
 @method
 @abstract 此方法调用后,所有的广告逻辑，将被暂停。
 @discussion 此方法与OnResume相对应。
 */
-(void)mBJoyOnPause;
/*!
 @method
 @abstract 此方法调用后,所有暂停的广告逻辑将会恢复正常运行。
 @discussion 此方法与OnPause相对应。
 */
-(void)mBJoyOnResume;
/*!
 @method
 @abstract MBJoyView的销毁。
 @discussion 此方法执行后,所有的广告逻辑将会停止，如果需要重新加载MBJoyView,需要重新初始化对象。
 */
-(void)mBJoyDestroy;
/*!
 @method
 @abstract  积分查询
 */
-(void)mBJoyQueryScore;
/*!
 @method
 @abstract  积分减少
 @param score （NSInteger--required）要减少的分数
 */
-(void)mBJoyReduceScore:(NSInteger)score;


#pragma block method

/*!
 @method
 @abstract  获取当前广告位的状态。
 */
-(void)mBJoyCanOpen:(void (^)(BOOL isCanOpen)) handle;
/*!
 @method
 @abstract  查询积分。
 */
-(void)mBJoyQueryScoreCompletionHandler:(void (^)(NSInteger score,NSString *message)) handle;

/*!
 @method
 @abstract  减少积分。
 @param score （NSInteger--required）需要减少的积分数。注:score要大于0
 */
-(void)mBJoyReduceScore:(NSInteger)score completionHandler:(void (^)(BOOL success,NSString *message)) handle;


@end
