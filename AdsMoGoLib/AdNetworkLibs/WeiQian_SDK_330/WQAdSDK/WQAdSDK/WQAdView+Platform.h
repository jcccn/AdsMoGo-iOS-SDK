//
//  WQAdView+Platform.h
//  ORMMA
//
//  Created by aaaa aaaa on 13-9-23.
//
//

#import "WQAdView.h"

@interface WQAdView (Platform)

//此方法需在调用startWithAdSlotID: AccountKey: InViewController:前调用
- (void)setAdPlatform:(NSString *)AdPlatform AdPlatformVersion:(NSString *)AdPlatformVersion;

@end
