//
//  Created by xingzhe on 14-2-15.
//  Copyright (c) 2014年 xingzhe. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PobFrameWallDelegate <NSObject,NSURLConnectionDelegate>
@optional
-(void)showPobFrameSucess;//插屏弹出成功
-(void)showPobFrameFail;//插屏弹出失败
-(void)closeGuFrameWall;//插屏关闭
-(void)initPobFrameSuccess;//获取数据成功
-(void)initPobFrameFail;//获取数据失败
@end



NSMutableString *interstitialPar;

@interface PobFrameWall : NSObject<PobFrameWallDelegate>
{
    id<PobFrameWallDelegate> delegate;
    NSMutableArray *array;
    NSString *orientation;
  
}
@property (assign) id<PobFrameWallDelegate> delegate;
@property (nonatomic, assign) UIViewController* viewController;
@property (nonatomic,retain) NSMutableData *receivedData;
@property (assign) NSString *uniquePath;
@property CGRect picFrame;
@property CGRect uiFrame;


+ (PobFrameWall *)getInstance;
+ (void)destroy;

-(id)orientation:(NSString *)orientations andDelegate:(id<PobFrameWallDelegate>)_delegate andUIViewController:(UIViewController *) mviewController;

/**
 *  展示广告
 */
- (void)showpobFrame;
@end
