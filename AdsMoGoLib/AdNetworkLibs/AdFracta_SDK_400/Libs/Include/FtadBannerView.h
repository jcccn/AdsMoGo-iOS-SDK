//
//  AdFractaView.h
//  ADS
//
//  Created by jack on 10/12/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import "FtadStatusDelegate.h"
@class FtadManager;

#define AD_SIZE_320x48     CGSizeMake(320,48)
#define AD_SIZE_320x270    CGSizeMake(320,270)
#define AD_SIZE_488x80     CGSizeMake(488,80)
#define AD_SIZE_768x116    CGSizeMake(768,116)

typedef enum AD_OPEN_TYPE{
	
	ADOpenInSafari = 1,
	ADOpenInViewController    //requeir rootViewController
	
}AdOpenType;

@interface FtadBannerView : UIView{
	
}

//
//
@property (nonatomic,retain) NSString * adIdentify;
//
//
@property (nonatomic,assign) id <FtadStatusDelegate> adstatus;
//
//
@property (nonatomic,assign) id rootViewController_;
//
//
@property (nonatomic) BOOL isClose;
//
//
@property (nonatomic,assign) FtadManager * manager;

//
//
+ (FtadBannerView*)newFtadBannerViewWithPointAndSize:(CGPoint)point size:(CGSize)size adIdentify:(NSString*)adIdentify delegate:(id<FtadStatusDelegate>)adstatus;

-(void)receiveAd:(id)ad;
-(BOOL)canReceiveAd;

@end
