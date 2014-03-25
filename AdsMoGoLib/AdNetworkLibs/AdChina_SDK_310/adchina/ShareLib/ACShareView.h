//
//  ACShareView.h
//  AdChinaSDK3
//
//  Created by jome on 13-11-21.
//  Copyright (c) 2013年 AdChina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import  "AdChinaSShareAdapter.h"

@class AdShareContext;
@protocol ACShareViewDelegate<NSObject>
-(void) shareButtonClick:(id) sender;
-(void)closeShareView:(id)sender;
-(AdShareContext*)AdChinaShareContext;
@end
@interface ACShareView : UIView
{
    
}
@property(strong,nonatomic) id<ACShareViewDelegate,AdChinaSShareKitDelegate> delegate;
@property(strong,nonatomic) AdShareContext *shareContext;


+(ACShareView*)shareShareView;
/**
 *  注册应用,此方法在应用启动时调用一次并且只能在主线程中调用。
 *  @param appKey 	应用Key,在AdChinaSDK官网中注册的应用Key
 */
+ (void)registerApp:(NSString *)appKey;
//init share btn
-(void)initShareBtn;
-(void)showInView:(UIView*)view;
-(UIButton*)createShareBtn:(NSString*)shareStr  shareIco:(NSString*)str  shareType:(AdChinaSShareAdapterType) sharetype;
-(id)initSharePoint:(CGPoint) point  appkey:(NSString*)appkey;

@end






