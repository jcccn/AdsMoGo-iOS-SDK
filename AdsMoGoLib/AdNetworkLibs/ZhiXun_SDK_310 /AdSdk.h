//
//  AdSdk.h
//  AdSdk
//
//  Created by yhxx on 13-3-26.
//  Copyright (c) 2013年 Object. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface AdSdk : UIView



/*
 superController 把广告view 加到哪个controller上边，就填写哪个
 sdkId 你的sdkid
 */


//iphone的sdk尺寸
- (id)initAdWith320X50:(UIViewController*)superController AppId:(NSString*)sdkId X:(float)x Y:(float)y;
- (id)initAdWith160X50:(UIViewController*)superController AppId:(NSString*)sdkId X:(float)x Y:(float)y;
- (id)initAdWith320X100:(UIViewController*)superController AppId:(NSString*)sdkId X:(float)x Y:(float)y;


//ipad的sdk尺寸
- (id)initAdWith768X100:(UIViewController*)superController AppId:(NSString*)sdkId X:(float)x Y:(float)y;
- (id)initAdWith768X150:(UIViewController*)superController AppId:(NSString*)sdkId X:(float)x Y:(float)y;
- (id)initAdWith384X150:(UIViewController*)superController AppId:(NSString*)sdkId X:(float)x Y:(float)y;
- (id)initAdWith384X100:(UIViewController*)superController AppId:(NSString*)sdkId X:(float)x Y:(float)y;


//插屏广告
//iphone
- (id)initAdWith300X250:(UIViewController*)superController AppId:(NSString*)sdkId X:(float)x Y:(float)y;
//ipad
- (id)initAdWith600X500w:(UIViewController*)superController AppId:(NSString*)sdkId X:(float)x Y:(float)y;

-(void)startAd;
-(void)stopAd;

@end
