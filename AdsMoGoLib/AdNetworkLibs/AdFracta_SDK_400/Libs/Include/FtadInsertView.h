//
//  FtadInsertView.h
//  FtadSdkIos3Lib
//
//  Created by Verna on 11-12-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FtadStatusDelegate.h"

@interface FtadInsertView : UIView {
    
}

//
//
@property (nonatomic,retain) NSString * adIdentify;
//
//
@property (nonatomic,assign) id <FtadStatusDelegate> adstatus;

//
//
+ (FtadInsertView*)newAndShowFtadInsertViewInView:(UIView*)view adIdentify:(NSString*)adIdentify delegate:(id<FtadStatusDelegate>)adstatus;

@end
