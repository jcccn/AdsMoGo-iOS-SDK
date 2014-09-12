//
//  pingcooSDK.h
//  BingcooSDK_2.1
//
//  Created by jason on 13-5-10.
//  Copyright (c) 2013年 jason. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol pingcooSDKDelegate;
@interface pingcooSDK : NSObject
{
    id<pingcooSDKDelegate> _delegate;
}
@property(nonatomic,assign) id<pingcooSDKDelegate> delegate;

+(pingcooSDK *)initWithKey:(NSString *)theAdKey;
-(void)getOneAd:(NSString *)adnumber;
-(void)PauseAdShow:(NSString *)adnumber;
-(void)bannerShowUp:(UIView *)bottomView;
-(void)bannerShowDown:(UIView *)bottomView;
//显示一个banner
-(void)bannerShow:(UIView *)bannerView;


-(void)popShow:(UIView *)popView showTime:(CGFloat)_timesize;
@end
@protocol pingcooSDKDelegate <NSObject>
@optional
//图片显示完成
-(void)show:(pingcooSDK *)show didFinishAppearWithResult:(id)result;
//错误
-(void)show:(pingcooSDK *)show didFailWithError:(NSError *)error;
//图片消失
-(void)show:(pingcooSDK *)show didFinishDisappearWithResult:(id)result;
@end