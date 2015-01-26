//
//  MdotMAdBannerView.h
//  MdotMiOSSDK2
//
//  Created by MdotM on 8/6/12.
//  Copyright (c) 2012 MdotM. All rights reserved.
//



#import "MdotMAdViewDelegate.h"
#import <UIKit/UIKit.h>

@class MdotMRequestParameters;
@interface MdotMAdView:UIView<MdotMAdViewDelegate> {
	
		 id<MdotMAdViewDelegate>		adViewDelegate;
}
@property (nonatomic,assign)id<MdotMAdViewDelegate>		adViewDelegate;

-(BOOL)loadBannerAd:(MdotMRequestParameters *)request withSize:(CGSize)adSize;
-(void)setAdRefreshInterval:(CGFloat)seconds;
@end

