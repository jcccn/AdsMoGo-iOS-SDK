//
//  Insert.h
//  yjfSDKDemo_beta1
//
//  Created by emaryjf on 13-2-5.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMInterstitialDelegate <NSObject,NSURLConnectionDelegate>
@optional
-(void)openInterstitial:(int)_value;//1 插屏弹出成功  0 插屏弹出失败
-(void)closeInterstitial;//插屏关闭
-(void)getInterstitialDataSuccess;//获取数据成功
-(void)getInterstitialDataFail;//获取数据失败

@end



NSMutableString *interstitialPar;

@interface HMInterstitial : NSObject<HMInterstitialDelegate>
{
    id<HMInterstitialDelegate> delegate;
    NSMutableArray *array;
    NSString *orientation;
    NSMutableArray *imageArrays;
    NSArray *imagePathes;
    NSUInteger downloadIndex;
  
}
@property (assign) id<HMInterstitialDelegate> delegate;
@property (nonatomic, assign) UIViewController* viewController;
@property (nonatomic,retain) NSMutableData *receivedData;
@property (assign) NSString *uniquePath;
//@property CGRect picFrame;
@property CGRect uiFrame;


+ (HMInterstitial *)shareInstance;
+ (void)destroyDealloc;

-(id)initWithFrame:(CGRect)frame andDelegate:(id<HMInterstitialDelegate>)_delegate;
-(void)cancle_Interstitial;
/**
 *  展示广告
 */
- (void)show;
- (BOOL) isShow;
@end
