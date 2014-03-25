//
//  FtadHtml5BannerView.h
//  FtadSdkIos3Lib
//
//  Created by Verna on 11-12-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FtadBannerView.h"
#import "FtadStatusDelegate.h"
@class FtadManager;

@interface FtadHtml5BannerView : FtadBannerView {
	
}

//
//
+ (FtadHtml5BannerView*)newFtadHtml5BannerViewWithPointAndSize:(CGPoint)point size:(CGSize)size adIdentify:(NSString*)adIdentify delegate:(id<FtadStatusDelegate>)adstatus;

-(BOOL)canReceiveAd;
-(void)receiveAd:(id)ad;

@end
