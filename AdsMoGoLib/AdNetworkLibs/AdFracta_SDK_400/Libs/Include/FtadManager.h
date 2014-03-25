//
//  FtadManager.h
//  FtadSdkIos3Lib
//
//  Created by Verna on 11-12-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
@class FtadBannerView;
@class FtadDoorCurtainView;
@class FtadWindowCurtainView;
@class FtadHtml5BannerView;
@class FtadPushView;

@interface FtadManager : NSObject {
    
}

//
//
@property (nonatomic) int timeInterval;

//
//
-(void)setPublisherid:(NSString*)pid;
//
//
-(void)start;
//
//
-(void)stop;

//
//
-(BOOL)addFtadBannerView:(FtadBannerView*)ftadBannerView;
//
//
-(BOOL)removeFtadBannerView:(FtadBannerView*)ftadBannerView;

//
//
-(BOOL)addFtadDoorCurtainView:(FtadDoorCurtainView*)ftadDoorCurtainView;
//
//
-(BOOL)removeFtadDoorCurtainView:(FtadDoorCurtainView*)ftadDoorCurtainView;

//
//
-(BOOL)addFtadWindowCurtainView:(FtadWindowCurtainView*)ftadWindowCurtainView;
//
//
-(BOOL)removeFtadWindowCurtainView:(FtadWindowCurtainView*)ftadWindowCurtainView;

//
//
-(BOOL)addFtadHtml5BannerView:(FtadHtml5BannerView*)ftadHtml5BannerView;
//
//
-(BOOL)removeFtadHtml5BannerView:(FtadHtml5BannerView*)ftadHtml5BannerView;

//
//
-(BOOL)addFtadPushView:(FtadPushView*)ftadPushView;
//
//
-(BOOL)removeFtadPushView:(FtadPushView*)ftadPushView;

@end
