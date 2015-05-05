//
//  CocoBVideo.h
//  CocoBVideo
//
//  Created by 陈建峰 on 14/11/28.
//  Copyright (c) 2014年 HuaiNan. All rights reserved.
//  视频sdk版本号：1.1.1
//

#import <UIKit/UIKit.h>

@interface CocoBVideo : UIWebView
// !!!:初始化sdk【必须】
/*
 *传入你在有米网站开发者后台创建应用时生成的appid与appSecret
 */
+(void)cBVideoInitWithAppID:(NSString *)appid cBVideoAppIDSecret:(NSString *)appSecret;

// !!!:开始播放视频
/*
 *传入当前的viewController。视频将会以viewController presentMoviePlayerViewControllerAnimated:VideoController的方式呈现
 *Unity3D或者其他游戏引擎最好传入[[[UIApplication sharedApplication] keyWindow] rootViewController]
 *
 *cBVideoPlayFinishCallBackBlock是视频播放完成后马上回调,isFinishPlay为true则是用户完全播放，为false则是用户中途退出
 *
 *cBVideoPlayConfigCallBackBlock会在有米的服务器最终确认这次播放是否有效后回掉（播放完成后有网络请求，网络不好可能有延时）。isLegal为true为有效，否则为无效。
 */
+(void)cBVideoPlay:(UIViewController *)viewController cBVideoPlayFinishCallBackBlock:(void(^)(BOOL isFinishPlay))block cBVideoPlayConfigCallBackBlock:(void(^)(BOOL isLegal))configBlock;

// !!!:是否还有视频可以播放
/*
 isHaveVideoStatue的值目前有两个
  0：有视频可以播放
  1：暂时没有可播放视频
  2：网络状态不好
 */
+(void)cBIsHaveVideo:(void(^)(int isHaveVideoStatue))backCallBlock;

// !!!:设置是否强制横屏，默认是强制横屏
+(void)cBisForceLandscape:(BOOL)isForce;

// !!!:播放视频期间不显示关闭按钮
+(void)cBCloseButtonHide;
@end
