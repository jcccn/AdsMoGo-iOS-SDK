//
//  WQSplashAdView.h
//  ORMMA
//
//  Created by aaaa aaaa on 13-7-11.
//
//

#import "WQADViewBaseClass.h"

@protocol WQSplashADViewDelegate;
@interface WQSplashAdView : WQADViewBaseClass

-(WQSplashAdView*) initWithFrame:(CGRect)pFrame andAdSloatID:(NSString*)pAdSlotID andAccountKey:(NSString*)pAccountKey  withLocationEnabled:(BOOL)pLocationEnabled;
-(void) setAdSlotID:(NSString*)pAdSlotID andAccountKey:(NSString*)pAccountKey;
-(void) loadSplashAd;
-(void) showSplashAd;
-(void) pauseVideo;
-(void) continueVideo;
-(BOOL) isSplashAdReady;
-(void) stopLoadingSplashAd;

@property(assign, nonatomic) id<WQSplashADViewDelegate> delegate;
@property BOOL storeKitEnabled;

@end

@protocol WQSplashADViewDelegate <NSObject>

@optional

-(void)onSplashAdRequestLoaded:(WQSplashAdView*)pAdView allLoaded:(BOOL)pAllLoaded;
-(void)onSplashAdRequestFailed:(WQSplashAdView*)pAdView;
-(void)onSplashAdPresent:(WQSplashAdView*)pAdView;
-(void)onSplashAdDismiss:(WQSplashAdView*)pAdView;
-(void)wqSplashAdWillPresentModalView:(WQSplashAdView*)pAdView;
-(void)wqSplashAdWillDismissModalView:(WQSplashAdView*)pAdView;
-(UIViewController*) controllerForPresentingModelViewInSplashAdView:(WQSplashAdView*)pAdView;
-(void) onSplashAdClicked:(WQSplashAdView*)pAdView;
-(void) onSplashAdViewed:(WQSplashAdView*)pAdView;

@end