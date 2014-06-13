//
//  Created by xingzhe on 14-2-15.
//  Copyright (c) 2014年 xingzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuHotWallDelegate <NSObject>
@optional
-(void)OpenGuHotWall:(int)_value;//1 打开成功  0 打开失败
-(void)CloseGuHotWall;//墙关闭
@end

@interface AdHotWall : UIViewController<UIWebViewDelegate>


@property (assign) id<GuHotWallDelegate> delegate;
@property (assign) UIWebView *adWallWebView;
@property (assign) UIButton *backBut;
@property (assign) UIActivityIndicatorView *progressInd;
@end
