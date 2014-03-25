//
//  immobView.h
//
//  Version 2.6.1 BuildTime 130902

#import <UIKit/UIKit.h>

@class immobView;
@protocol immobViewDelegate <NSObject>

@required
/**
 *email phone sms 等所需要
 */
- (UIViewController *)immobViewController;

@optional

/**
 *用于实时回调通知当前的广告状态
 */
- (void) immobViewDidReceiveAd:(immobView*)immobView;

- (void) immobView: (immobView*) immobView didFailReceiveimmobViewWithError: (NSInteger) errorCode;

- (void) emailNotSetupForAd:(immobView *)immobView;

/**
 *查询积分接口回调
 */
- (void) immobViewQueryScore:(NSUInteger)score WithMessage:(NSString *)message;

/**
 *减少积分接口回调
 */
- (void) immobViewReduceScore:(BOOL)status WithMessage:(NSString *)message;


/**
 * Called when an ad is clicked and about to return to the application. 
 * 当（全屏）广告被点击或者被关闭，将要返回返回主程序见面时被调用。
 *
 */
- (void) onDismissScreen:(immobView *)immobView;


/**
 * Called when an ad is clicked and going to start a new page that will leave the application
 * 当广告调用一个新的页面并且会导致离开目前运行程序时被调用。如：调用本地地图程序。
 *
 */
- (void) onLeaveApplication:(immobView *)immobView;

/**
 * Called when an page is created in front of the app.
 * 当广告页面被创建并且显示在覆盖在屏幕上面时调用本方法。
 */
- (void) onPresentScreen:(immobView *)immobView;

@end

@interface immobView : UIView

/**
 *AdUnitIDString
 *在力美广告平台获取到的广告位ID.
 *此ID为与广告平台通信的依据.
 */
@property (nonatomic, retain) NSString *AdUnitIDString;

/**
 *delegate
 *immobview 的Delegate.
 *用于实现一些方法回调.
 */
@property (nonatomic, assign) id<immobViewDelegate> delegate;

/**
 *UserAttribute
 *此属性主要针对多账户的应用程序,可以设置一些用户信息(比如：账户名称),以便于多账户之前积分的区分.
 */
@property (nonatomic, assign) NSMutableDictionary *UserAttribute;

/**
 *isAdReady
 *此属性用于标识当前广告是否可用，用户可以根据当前广告的状态来决定当前广告是否显示.
 *用于实现一些方法回调.
 */

@property (nonatomic, assign) BOOL isAdReady;

/**
 *此方法用于immobView的初始化
 */
-(id) initWithAdUnitID:(NSString *)adUnitID;


/**
 *此方法用于开始加载广告
 */
-(void)immobViewRequest;
/**
 *此方法用于immobView的展示
 *此方法与immobViewrequest相对应，
 *调用immobViewrequest后
 *需调用immobViewDisplay广告才能正常加载展示
 */
-(void)immobViewDisplay;
/**
 *此方法用于immobView的显示
 */
-(void)immobViewShow;
/**
 *此方法用于immobView的隐藏
 */
-(void)immobViewHide;
/**
 *此方法用于immobView的暂停
 */
-(void)immobViewOnPause;
/**
 *此方法用于immobView的恢复
 */
-(void)immobViewOnResume;
/**
 *此方法用于immobView的销毁
 */
-(void)immobViewDestroy;

/**
 *此方法用于获取由力美提供的Udid
 */

-(NSString *)getLimeiUDID;

/**
 *此方法用于查询服务器上的积分
 *适用于单账户用户
 */
-(void)immobViewQueryScoreWithAdUnitID:(NSString *)adUnitId;
/**
 *此方法用于查询服务器上的积分
 *适用于多账户用户
 *accountId 用户的账户名称
 */
-(void)immobViewQueryScoreWithAdUnitID:(NSString *)adUnitId WithAccountID:(NSString *)accountId;
/**
 *此方法用于向服务器申请减少积分
 *适用于单账户用户
 */
-(void)immobViewReduceScore:(NSInteger)score WithAdUnitID:(NSString *)adUnitId;
/**
 *此方法用于向服务器申请减少积分
 *适用于多账户用户
 *accountId 用户的账户名称
 */
-(void)immobViewReduceScore:(NSInteger)score WithAdUnitID:(NSString *)adUnitId WithAccountID:(NSString *)accountId;

@end
