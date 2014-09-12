#import <Foundation/Foundation.h>
#import "AppConnect.h"
#import "WapsFetchResponseProtocol.h"


#define WAPS_AD_REFRESH_DELAY        (15.0)

extern NSString *kWapsAdFailStr;

@class WapsAdRequestHandler;

@interface WapsAdView : UIView <WapsFetchResponseDelegate> {
@private
    NSURL *redirectURL_;
    NSString *clickURL_;
    NSString *imageDataStr_;
    UIImageView *imageView_;
    UIImageView *previousImageView_;
    NSString *contentSizeStr_;
    UIView *adViewOverlay_;
    UIViewController *controller_;

    WapsAdRequestHandler *adHandlerObj_;
}

@property(copy) NSURL *redirectURL;
@property(copy) NSString *clickURL;
@property(copy) NSString *imageDataStr;
@property(nonatomic, retain) UIImageView *imageView;
@property(nonatomic, retain) UIImageView *previousImageView;
@property(copy) NSString *contentSizeStr;
@property(nonatomic, retain) UIView *adViewOverlay;
@property(nonatomic, retain) UIViewController *controller;

@property(nonatomic, retain) WapsAdRequestHandler *adHandlerObj;

+ (WapsAdView *)sharedWapsAdView;

- (id)getAdWithDelegate:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;

- (void)fetchResponseSuccessWithData:(void *)dataObj withRequestTag:(int)aTag;

- (void)fetchResponseError:(WapsResponseError)errorType errorDescription:(id)errorDescObj requestTag:(int)aTag;

- (void)refreshAd:(NSTimer *)timer;

- (BOOL)isAdLoaded;

@end


@interface AppConnect (WapsAdView)

+ (id)displayAd:(UIViewController *)vController;

+ (id)displayAd:(UIViewController *)vController adSize:(NSString *)aSize;

+ (id)displayAd:(UIViewController *)vController showX:(CGFloat)x showY:(CGFloat)y;

+ (id)displayAd:(UIViewController *)vController adSize:(NSString *)aSize showX:(CGFloat)x showY:(CGFloat)y;

+ (BOOL)isDisplayAdLoaded;

+ (WapsAdView *)getDisplayAdView;

@end

