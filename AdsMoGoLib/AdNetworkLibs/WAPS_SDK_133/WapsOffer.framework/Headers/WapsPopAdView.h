#import <UIKit/UIKit.h>
#import "AppConnect.h"

@class WapsWAdRequestHandler;

@interface WapsPopAdView : UIView
{
    WapsWAdRequestHandler *popAdViewObj_;
}
@property(nonatomic, retain) WapsWAdRequestHandler *popAdViewObj_;

- (id)getPopAdViewWithController:(UIViewController *)controller;

- (void)loadADWithVersion:(NSString *)popVersion;

+ (WapsPopAdView *)sharedWapsPopAdView;


//- (id)getWindowAdView;

@end

@interface AppConnect(WapsWAdView)

+ (void)initPopAd;

+ (id)showPopAd:(UIViewController *)controller;

@end
