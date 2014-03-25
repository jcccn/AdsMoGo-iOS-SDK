//
//  FtadSdk.h
//  FtadSdkIos3Lib
//
//  Created by Verna on 11-12-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FtadStatusDelegate.h"

@interface FtadSdk : NSObject {
    
}

+(id<FtadStatusDelegate>)getFtadFullScreenAdStatusDelegate;
+(void)setFtadFullScrrenAdStatusDelegate:(id<FtadStatusDelegate>)delegate;
//
//
+(void)initSdkConfig:(NSString*)pid;
//
//
+(void)releaseSdkConfig;
//
//
+(void)setNeedFullScreenStartView:(BOOL)isneed;
//
//
+(BOOL)isNeedFullScreenStartView;
//
//
+(void)setNeedInsertView:(BOOL)isneed;
//
//
+(BOOL)isneedInsertView;
//
//
+(void)setNeedLocation:(BOOL)isneed;
//
//
+(BOOL)isNeedLocation;
//
//
+(void)updateLocationWithLatitudeAndLongitude:(double)latitude longitude:(double)longitude;
//
//
+(void)setRootViewController:(id)root;
//
//
+(id)getRootViewController;
//
//
+(void)setClickViewFullScreen:(BOOL)isCan;
//
//
+(BOOL)canClickViewFullScreen;

@end
