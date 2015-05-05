//
//  InMobiNativeAdapter.h
//  mogoNativeDemo
//
//  Created by Castiel Chen on 15/1/7.
//  Copyright (c) 2015年 ___ADSMOGO___. All rights reserved.
//

#import "AdMoGoNativeAdNetworkAdapter.h"
#import "IMNative.h"

@interface InMobiNativeAdapter : AdMoGoNativeAdNetworkAdapter<IMNativeDelegate>

@property (nonatomic, retain) IMNative *native;

@end
