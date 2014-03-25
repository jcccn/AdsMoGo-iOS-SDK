//
//  FractalStartFullScreenAdView.h
//  FtadSdkIosDemo
//
//  Created by Verna on 11-9-9.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FtadStatusDelegate.h"

@interface FtadFullScreenStartView : UIView {
	
}

//
//
@property (nonatomic,retain) NSString * adIdentify;
//
//
@property (nonatomic, assign) id <FtadStatusDelegate> adstatus;

//will read full screen start ad config,and load it
//if suceess,return a FtadFullScreenStartView object,and add it to rootView 's subviews
//if fail,return nil
//将会读取
//
//
+(FtadFullScreenStartView*)newAndShowFtadFullScreenStartViewInView:(UIView *)rootView adIdentify:(NSString*)adIdentify delegate:(id<FtadStatusDelegate>)adstatus;

@end
