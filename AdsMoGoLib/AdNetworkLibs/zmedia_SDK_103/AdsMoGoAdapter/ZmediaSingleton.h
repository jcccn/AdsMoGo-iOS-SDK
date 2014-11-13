//
//  ZmediaSingleton.h
//  wanghaotest
//
//  Created by mogo on 14-7-28.
//
//

#import <Foundation/Foundation.h>
@protocol ZmediaSingletonDelegate ;

@interface ZmediaSingleton : NSObject
@property (assign) id<ZmediaSingletonDelegate> delegate;
+ (id)shareInstance;
@end

@protocol ZmediaSingletonDelegate <NSObject>
@optional
-(void)ZMSDKIntervalViewDelegateRequestSuccess:(BOOL)flag;
-(void)ZMSDKBannerDelegateRequestSuccess:(BOOL)flag;

-(void)ZMSDKBannerDelegateShowSuccess:(BOOL)flag;//banner是否显示成功

-(void)ZMSDKBannerDelegateClick;//banner点击


-(void)ZMSDKIntervalViewDelegateLoadSuccess:(BOOL)flag;
-(void)ZMSDKIntervalViewDelegateShowSuccess:(BOOL)flag;
-(void)ZMSDKIntervalViewDelegateClick;
-(void)ZMSDKIntervalViewDelegateClose;
@end
