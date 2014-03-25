/**
 * ZestadzDelegateProtocol.h
 * ZestADZ iPhone SDK publisher code.
 *
 * Defines the ZestadzDelegate protocol.
 */

@class ZestadzView;

@protocol ZestadzDelegate<NSObject>

@required

// Use this to provide a client id for an ad request. Get a client id
// from http://www.zestadz.com
- (NSString *)clientId;

@optional
// Sent when an ad request loaded an ad; this is a good opportunity to add
// this view to the hierachy, if it has not yet been added.
// Note that this will only ever be sent once per ZestadzView, regardless of whether
// new ads are subsequently requested in the same ZestadzView.
- (void)didReceiveAd:(ZestadzView *)adView;

// Sent when an ad request failed to load an ad.
// Note that this will only ever be sent once per ZestadzView, regardless of whether
// new ads are subsequently requested in the same ZestadzView.
- (void)didFailToReceiveAd:(ZestadzView *)adView;

- (NSString *)userAgent; // user's mobile agent, e.g. "Apple iPhone OS v2.0 CoreMedia v1.0.0.5A347"
- (NSString *)keywords;  //keyword to target, e.g. "Proffessional,Doctor"
// Defaults to [UIColor colorWithRed:0.443 green:0.514 blue:0.631 alpha:1], which is a chrome-y color.
// Note that the alpha channel in the provided color will be ignored and treated as 1.
- (UIColor *)adBackgroundColor;
@end