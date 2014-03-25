    //
//  MiidiAdViewController_320x50.m
//  MiidiSdkSample_Banner
//
//  Created by adpooh miidi on 12-5-18.
//  Copyright 2012 miidi. All rights reserved.
//

#import "MiidiAdViewController_320x50.h"


@implementation MiidiAdViewController_320x50
@synthesize adView;


- (void)awakeFromNib {
	[super awakeFromNib];
	//
	// 创建广告条
	adView = [[MiidiAdView alloc]initMiidiAdViewWithContentSizeIdentifier:MiidiAdSize320x50 delegate:nil];
	
	[self.view addSubview:adView];
}



- (void)dealloc {
	[adView release];
	
    [super dealloc];
}

@end
