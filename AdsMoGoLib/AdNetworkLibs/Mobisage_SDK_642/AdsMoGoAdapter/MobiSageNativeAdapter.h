//
//  MobiSageNativeAdapter.h
//  test
//
//  Created by Castiel Chen on 15/1/21.
//  Copyright (c) 2015年 Castiel Chen. All rights reserved.
//

#import "AdMoGoNativeAdNetworkAdapter.h"
#import "MobiSageAdFactory.h"
@interface MobiSageNativeAdapter : AdMoGoNativeAdNetworkAdapter<MobiSageAdFactoryDelegate>
{
    MobiSageAdFactory * nativeGroup;
}
@end
