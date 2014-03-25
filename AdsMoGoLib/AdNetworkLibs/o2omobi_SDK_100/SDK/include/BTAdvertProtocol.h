//
//  BTAdvertProtocol.h
//  BialinTimesAdvertExample
//
//    13-9-16.
//
//

#import <Foundation/Foundation.h>

@class BTAdverView;
@protocol BTAdvertProtocol <NSObject>

@optional
- (void)bannerWillGetAdvert:(BTAdverView *)adverView;
- (void)bannerDidGetAdvert:(BTAdverView *)adverView;
- (void)bannerDidFailedGetAdvert:(BTAdverView *)adverView error:(NSError *)error;

/**
 *  广告退出回调
 *
 *  @param adverView 广告视图
 */
- (void)btadInterstitialDidDismissScreen:(BTAdverView *)adverView;

@end
