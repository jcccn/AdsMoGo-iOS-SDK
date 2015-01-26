//
//  WQInterstitialAdView.h
//  ORMMA
//
//  Created by aaaa aaaa on 13-7-11.
//
//

#import "WQADViewBaseClass.h"

@protocol WQInterstitialAdViewDelegate;
NS_CLASS_AVAILABLE_IOS(5_0)
@interface WQInterstitialAdView : WQADViewBaseClass

@property BOOL storeKitEnabled;

-(WQInterstitialAdView*) initWithFrame:(CGRect)pFrame andAdSloatID:(NSString*)pAdSlotID andAccountKey:(NSString*)pAccountKey withLocationEnabled:(BOOL)pLocationEnabled;
-(void) setAdSlotID:(NSString*)pAdSlotID andAccountKey:(NSString*)pAccountKey;
-(void) loadInterstitialAd;
-(void) showInterstitialAd;
-(void) pauseVideo;
-(void) continueVideo;
-(BOOL) isInterstitialAdReady;
-(void) stopLoadingInterstitialAd;

@property(assign, nonatomic) id<WQInterstitialAdViewDelegate> delegate;

@end

@protocol WQInterstitialAdViewDelegate <NSObject>
//当插屏广告被成功加载后，回调该方法，pAllLoaded 为 true，表示所有的广告已经加载完成（一次广告加载可能会加载多条广告）
-(void) onInterstitialAdRequestLoaded:(WQInterstitialAdView*)pAdView  allLoaded:(BOOL)pAllLoaded;
//当插屏广告被加载失败后，回调该方法
-(void) onInterstitialAdRequestFailed:(WQInterstitialAdView*)pAdView;
//当插屏广告要展示出来前，回调该方法
-(void) onInterstitialAdPresent:(WQInterstitialAdView*)pAdView;
//当插屏广告被关闭后，回调改方法，广告视图已经被移除
-(void) onInterstitialAdDismiss:(WQInterstitialAdView*)pAdView;
//当要呈现 Modal View 时，回调该方法，如打开内置浏览器
-(void) wqInterstitialAdWillPresentModalView:(WQInterstitialAdView*)pAdView;
//当呈现的 Modal View 即将关闭时，回调该方法，如关闭内置浏览器
-(void) wqInterstitialAdDidDismissModalView:(WQInterstitialAdView*)pAdView;
//SDK用presentModalViewController的方式来打开广告内部的链接，这里需要返回一个view controller用作presentingViewController
-(UIViewController*) controllerForPresentingModelViewInInterstitialAdView:(WQInterstitialAdView*)pAdView;
//当广告展示成功的时候，回调该方法
-(void) onInterstitialAdViewed:(WQInterstitialAdView*)pAdView;

@end