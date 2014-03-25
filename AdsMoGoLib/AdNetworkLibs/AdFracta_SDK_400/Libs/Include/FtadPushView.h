//
//  FtadPushView.h
//  FtadSdkIos3Lib
//
//  Created by Verna on 11-12-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FtadStatusDelegate.h"
@class FtadManager;

@interface FtadPushView : UIView {
	
}

//
//
@property (nonatomic,retain) NSString * adIdentify;
//
//
@property (nonatomic, assign) id <FtadStatusDelegate> adstatus;
//
//
@property (nonatomic, assign) id rootViewController_;
//
//
@property (nonatomic,assign) FtadManager * manager;

//
//
+ (FtadPushView*)newAndShowPushViewInView:(UIView*)view adIdentify:(NSString*)adIdentify delegate:(id<FtadStatusDelegate>)adstatus;

-(BOOL)canReceiveAd;
-(void)receiveAd:(id)ad;

@end
