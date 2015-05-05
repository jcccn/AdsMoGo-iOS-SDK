//
//  HMTail.h
//  ScoreSDK2.0
//
//  Created by emaryjf on 14-10-14.
//  Copyright (c) 2014年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMTailDelegate <NSObject>

@optional
-(void)openHMTail:(int)_value;//1 开屏弹出成功  0 开屏弹出失败
@optional
-(void)closeHMTail;//开屏关闭

-(void)loadTailData:(int)_value;//1 加载数据成功 2 加载数据失败

@end

@interface HMTail : NSObject<HMTailDelegate>
{
    id<HMTailDelegate> delegate;
    NSMutableArray *array;
    int timeInter;
    NSString *imagePath;
    NSString *orientation;
    int flag1;
}
@property (nonatomic,retain) NSMutableData *receivedData;
@property (nonatomic, assign) UIViewController *viewController;
@property (assign) id<HMTailDelegate> delegate;
@property (assign) NSString *imagePath;
-(void)tailShow;
-(void)getTailData;
+(HMTail *)shareInstance;
+(void)destroyInstance;
@end
