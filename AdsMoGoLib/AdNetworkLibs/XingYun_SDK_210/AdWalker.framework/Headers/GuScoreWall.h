//
//  Created by xingzhe on 14-2-15.
//  Copyright (c) 2014年 xingzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GuScoreWallDelegate <NSObject>
@optional
-(void)getAdScoreSucess:(int)_score unit:(NSString *) unit;
-(void)getAdSCoreFailed:(int)_code error:(NSString *) error;
-(void)consumptionAdScoreSucess:(int)_score balance:(int)balance unit:(NSString *) unit;
-(void)consumptionAdScoreFailed:(int)_code error:(NSString *)error;
-(void)CloseScoreWall;//墙关闭

@end

@interface GuScoreWall : UIViewController<UIWebViewDelegate>

@property (assign) id<GuScoreWallDelegate> delegate;
@property (assign) UIWebView *GuScoreWallWebView;
@property (assign) UIButton *backBut;
@property (assign) UIActivityIndicatorView  *progressInd;

@end
