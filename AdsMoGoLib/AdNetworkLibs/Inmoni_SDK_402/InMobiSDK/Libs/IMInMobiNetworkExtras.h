//
//  IMInMobiNetworkExtras.h
//  InMobi Monetization SDK
//
//  Copyright (c) 2013 InMobi. All rights reserved.
//

#import "IMNetworkExtras.h"
#import <UIKit/UIKit.h>

/**
 * Additional parameters that you want to pass to InMobi ad network
 */
@interface IMInMobiNetworkExtras : NSObject<IMNetworkExtras>

/**
 * A free form NSDictionary for any demographic information,
 * not available via InMobi class.
 */
@property (nonatomic,retain) NSDictionary *additionaParameters;

/**
 * A free form set of keywords, separated by ','
 * E.g: "sports,cars,bikes"
 */
@property (nonatomic,copy) NSString *keywords;
/**
 * The animation transition, when a banner ad is refresh.
 * @note: Applicable for banner ads only.
 */
@property (nonatomic,assign) UIViewAnimationTransition transition;

/**
 * Ref-tag key to be passed to an ad instance.
 */
@property (nonatomic,copy) NSString *refTagKey;
/**
 * Ref-tag value to be passed to an ad instance.
 */
@property (nonatomic,copy) NSString *refTagValue;
@end
