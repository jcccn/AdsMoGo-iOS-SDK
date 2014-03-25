//
//  FtadDoorCurtainView.h
//  FtadSdkIos3Lib
//
//  Created by Verna on 11-12-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FtadStatusDelegate.h"
@class FtadManager;

typedef enum DOOR_POSITION{
	
	POSITION_TOP = 1,
	POSITION_BOTTOM
	
}MCDoorPositionType;

@interface FtadDoorCurtainView : UIView {
    
}

//
//
@property (nonatomic,retain) NSString * adIdentify;
//
//
@property (nonatomic, assign) id <FtadStatusDelegate> adstatus;
//
//
@property (nonatomic,assign) FtadManager * manager;

//
//
+(FtadDoorCurtainView*)newAndShowDoorCurtainViewInView:(UIView*)view doorBannerAdViewSize:(CGSize)size doorViewPosition:(MCDoorPositionType)position adIdentify:(NSString*)adIdentify delegate:(id<FtadStatusDelegate>)adstatus;

-(void)orientainChanged;
-(BOOL)canReceiveAd;
-(void)receiveAd:(id)ad;
-(void)setShowCloseBtn:(BOOL)isShowCloseBtn;

@end
