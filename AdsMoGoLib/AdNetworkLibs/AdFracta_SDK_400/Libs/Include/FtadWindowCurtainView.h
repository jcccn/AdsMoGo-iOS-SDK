//
//  FtadWindowCurtainView.h
//  FtadSdkIos3Lib
//
//  Created by Verna on 11-12-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FtadStatusDelegate.h"
@class FtadManager;

@interface FtadWindowCurtainView : UIView {
	
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
+(FtadWindowCurtainView*)newAndShowWindowCurtainViewInView:(UIView*)view adIdentify:(NSString*)adIdentify delegate:(id<FtadStatusDelegate>)adstatus;

-(void)orientainChanged;
-(BOOL)canReceiveAd;
-(void)receiveAd:(id)ad;

@end
