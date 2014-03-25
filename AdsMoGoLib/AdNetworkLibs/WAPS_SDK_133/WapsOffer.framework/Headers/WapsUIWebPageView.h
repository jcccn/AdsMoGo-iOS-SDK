#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>


#define WapsUIWEBPAGE_ACTIVITY_INDICATOR_SIZE    60
#define WapsUIWEBPAGE_ACTIVITY_RECT_SIZE            100
#define WapsUIWEBPAGE_LOADING_TEXT_RECT_HEIGHT    20

static const float LOADING_PAGE_START_ALPHA = 0.75f;
static const float LOADING_PAGE_END_ALPHA = 0.0f;
static const float LOADING_PAGE_FADE_TIME = 0.25f;

@protocol WapsUIWebPageViewProtocol <NSObject>

@required

- (void)WapsUIWebPageViewwebRequestCompleted;

- (void)WapsUIWebPageViewwebRequestCanceled;

@end


@interface WapsUIWebPageView : UIView <UIWebViewDelegate> {
    UIWebView *cWebView_;
    NSString *lastClickedURL_;
    BOOL isViewVisible_;
    BOOL isAlertViewVisible_;
    id delegate_;
}

@property(nonatomic) BOOL isViewVisible;
@property(nonatomic) BOOL isAlertViewVisible;
@property (nonatomic, retain)UIView *view;
@property (nonatomic, retain)UIActivityIndicatorView *activity;

- (void)refreshWithFrame:(CGRect)frame;

- (void)refreshWithView:(UIView *)uiView;

- (void)setViewToTransparent:(BOOL)transparent;

- (void)clearWebViewContents;

- (void)parseVideoClickURL:(NSString *)videoClickURL shouldPlayVideo:(BOOL)shouldPlay;

- (void)loadURLRequest:(NSString *)requestURLString withTimeOutInterval:(int)tInterval;

- (void)setDelegate:(id)delegate;

@end
