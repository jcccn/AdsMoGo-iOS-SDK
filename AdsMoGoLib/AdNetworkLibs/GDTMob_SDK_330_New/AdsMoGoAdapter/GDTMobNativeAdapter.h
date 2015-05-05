//
//  GDTMobNativeAdapter.h
//  mogoNativeDemo
//
//  Created by Castiel Chen on 15/1/7.
//  Copyright (c) 2015年 ___ADSMOGO___. All rights reserved.
//

#import "AdMoGoNativeAdNetworkAdapter.h"
#import "GDTNativeAd.h"
@interface GDTMobNativeAdapter : AdMoGoNativeAdNetworkAdapter<GDTNativeAdDelegate>
{
    GDTNativeAd  * nativeAd;
}


@end
