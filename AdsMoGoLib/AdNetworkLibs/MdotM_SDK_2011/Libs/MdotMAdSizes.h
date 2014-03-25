//
//  MdotMAdSizes.h
//  MdotMiOSSDK2
//
//  Created by MdotM on 01/08/12.
//  Copyright (c) 2012 MdotM. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define BANNER_300_50 (CGSizeMake(300,50))
#define BANNER_320_50 (CGSizeMake(320,50))
#define BANNER_300_250 (CGSizeMake(300,250))
#define BANNER_320_480 (CGSizeMake(320,480))
#define BANNER_468_60 (CGSizeMake(468,60))
#define BANNER_480_320 (CGSizeMake(480,320))
#define BANNER_1024_768 (CGSizeMake(1024,768))
#define BANNER_768_1024 (CGSizeMake(768,1024))
#define BANNER_728_90 (CGSizeMake(728,90))

@interface MdotMAdSizes : NSObject
+ (BOOL) checkSize:(CGSize)sizeToCheck;
+(CGSize)getValidInterstitialSizeForDevice;
+(CGSize)screenSizeForOrientation:(UIDeviceOrientation)orientation;
@end
