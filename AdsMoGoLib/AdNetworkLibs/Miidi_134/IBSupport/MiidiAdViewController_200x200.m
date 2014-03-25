    //
//  MiidiAdViewController_200x200.m
//  MiidiSdkSample_Banner
//
//  Created by adpooh miidi on 12-5-18.
//  Copyright 2012 miidi. All rights reserved.
//

#import "MiidiAdViewController_200x200.h"


@implementation MiidiAdViewController_200x200
@synthesize adView;


- (void)awakeFromNib {
	[super awakeFromNib];
	//
	// 创建广告条
	adView = [[MiidiAdView alloc]initMiidiAdViewWithContentSizeIdentifier:MiidiAdSize200x200 delegate:nil];
	
	[self.view addSubview:adView];
}



- (void)dealloc {
	[adView release];
	
    [super dealloc];
}


@end
