//
//  AdSplashController.h
//  ADSDK
//
//  Created by ad on 13-9-25.
//  Copyright (c) 2013年 mrdundun. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum {
    type320_50 = 0,
    type160_50 = 1,
    type320_100 = 2,
    type768_100 = 3,
    type768_150 = 4,
    type384_100 = 5,
    type384_150 = 6,
    //开屏
    //iphone
    type320_240 = 7,
    //ipad
    type600_500 = 8,
    
    //插屏
    //iphone
    type300_250 = 9,
    //ipad
    type600_500_w = 10,
    
    //应用推荐
    typeapprecomend = 11,
    
    //开屏全屏
    //iphone
    type320_480 = 12,
    //ipad
    type1024_768 = 13,
    //iphone
    type480_320 = 14,
    //ipad
    type768_1024 = 15,
} LAYOUT_TYPE;

@interface AdSplashController : NSObject

-(id)initWithPublisherId:(NSString *)publishid window:(UIWindow *)window defaultName:(NSString *)defaultName defaultrect:(CGRect)defaultrect layoutType:(int)type X:(float)x Y:(float)y;

-(void)start;

-(void)stopSlash;


@end
