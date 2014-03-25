#import <UIKit/UIKit.h>
#import "WapsUIWebPageView.h"
#import "AppConnect.h"


@class WapsUINavigationBarView;

@interface WapsOffersWebView : WapsUIWebPageView {
    WapsUINavigationBarView *navBar_;
    UIViewController *parentVController_;
    BOOL enableNavBar;
    BOOL enableAutoJudge;
    BOOL flagOrientationManaged;
    NSString *isSelectorVisible_;
    NSString *orientationType_;
    NSString *firstOrientation_;
    int primaryColorCode_;
    UIColor *userDefinedColor_;
    UIActivityIndicatorView *activityIndicator_;
}

@property(nonatomic, assign) UIViewController *parentVController_;
@property(nonatomic, retain) NSString *isSelectorVisible_;
@property(nonatomic, retain) WapsUINavigationBarView *navBar;
@property(nonatomic, retain) UIActivityIndicatorView *activityIndicator_;
@property(nonatomic, retain) NSString *orientationType;


- (id)initWithFrame:(CGRect)frame enableNavBar:(BOOL)enableNavigationBar autoJudge:(BOOL)judge;

- (void)refreshWithFrame:(CGRect)frame enableNavBar:(BOOL)enableNavigationBar autoJudge:(BOOL)judge;

- (void)setCustomNavBarImage:(UIImage *)image;

- (void)loadViewWithURL:(NSString *)URLString;

- (NSString *)setUpOffersURLWithServiceURL:(NSString *)serviceURL;

- (void)refreshWebView;


@end