//
//  BTAdverView.h
//  BialinTimesAdvertExample
//
//    13-9-16.
//
//

#import <UIKit/UIKit.h>
#import "BTAdvertProtocol.h"


@class APIAdvert;

/**
 *  各种广告View的基类
 */

@interface BTAdverView : UIView

@property (nonatomic, weak) id<BTAdvertProtocol> delegate;
@property (nonatomic, strong) NSTimer *durationShowTimer;
@property (nonatomic, strong) NSTimer *durationLogTimer;

@property (nonatomic, strong) UIButton *imageButton;
@property (nonatomic, strong) APIAdvert *apiAdvert;


- (id)initWithDelegate:(id<BTAdvertProtocol>)delegate;

/**
 *  给子类实现, 用于发送请求到服务器获取广告, 并显示广告
 */
- (void)start;


- (void)stop;

/**
 *  发送ShowTrackLog 给服务器
 */
- (void)sendShowTrackLog;

/**
 *  发送ClickTrackLog 给服务器
 */
- (void)sendClickTrackLog;

/**
 *  发送RequestTrackLog 给服务器
 */
- (void)sendRequestTrackLog;

- (void)setButtonImage:(UIImage *)image;

/**
 *  push到WebView
 */
- (void)pushToWebview;

@end
