//
//  WQSplashADView.h
//  ORMMA
//
//  Created by aaaa aaaa on 13-2-28.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WQADViewBaseClass : UIView

@property BOOL isViewable;
@property BOOL storeKitEnabled;
-(WQADViewBaseClass*) initWithFrame:(CGRect)pFrame andAdSloatID:(NSString*)pAdSlotID andAccountKey:(NSString*)pAccountKey withLocationEnabled:(BOOL)pLocationEnabled;
-(void) setAdSlotID:(NSString*)pAdSlotID andAccountKey:(NSString*)pAccountKey;
-(void) loadAd;
-(void) showAd;
-(void) pauseVideo;
-(void) continueVideo;
-(BOOL) isAdReady;
-(void) stopLoadingAd;
-(void) handleGetAdFinishedAllLoaded:(BOOL)pAllLoaded;
-(void) handleGetAdFaild;
-(void) handleAdDismissed;
-(void) handleAdPresentModalView;
-(void) handleAdDismissModelView;
-(void) handleAdPresent;
-(NSString*) parametersForControllingPackageUpdating;
-(NSString*) controllingPackageInfoFileName;
-(NSString*) controllingPackageDirectory;
-(NSString*) contentDirectory;

@end



