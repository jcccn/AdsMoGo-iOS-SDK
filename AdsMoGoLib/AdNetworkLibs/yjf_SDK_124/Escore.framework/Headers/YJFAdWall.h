//
//  adWall.h
//  yjfSDKDemo_beta1
//
//  Created by nemo on 13-1-25.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJFAdWallDelegate <NSObject>
@optional
-(void)OpenAdWall:(int)_value;//1 打开成功  0 打开失败
-(void)CloseAdWall;//墙关闭
@end

@interface YJFAdWall: UIViewController<UITableViewDataSource, UITableViewDelegate,NSURLConnectionDelegate>
{
    int page;
    id<YJFAdWallDelegate> delegate;
    int flag1;
    
    UIActivityIndicatorView *progressInd;
}
//@property (nonatomic, retain) id vc;

@property (assign) id<YJFAdWallDelegate> delegate;


@property (nonatomic, retain) NSMutableArray* array;
@property (nonatomic, retain) NSMutableArray* displayArray;
@property (nonatomic, retain) UITableView* tableView;
@property (retain) NSMutableData *receivedData;


@property (assign) UILabel *title_demo;
@property (assign) UILabel *title_demo2;
@property (assign) UIButton *backBut;
@property (assign) UIImageView *logoImage;

@end
