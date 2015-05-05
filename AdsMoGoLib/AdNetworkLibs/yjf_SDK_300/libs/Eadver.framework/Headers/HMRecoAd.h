//
//  YJFAdWallViewController.h
//  YJF_iosSDK_Html
//
//  Created by emaryjf on 13-12-21.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMAdRecoDelegate <NSObject>
@optional
-(void)OpenAdReco:(int)_value;//1 打开成功  0 打开失败
-(void)CloseAdReco;//墙关闭
@end

@interface HMRecoAd : UIViewController<UIWebViewDelegate,NSURLConnectionDataDelegate,UIAlertViewDelegate>

@property (nonatomic,retain) NSMutableData *receiveData;
@property (assign) id<HMAdRecoDelegate> delegate;
@property (assign) UIWebView *adRecoWebView;
//@property (assign) UIButton *backBut;
@property (assign) UIActivityIndicatorView *progressInd;
- (BOOL) isAdShow;

@end
