//
//  AdMoGoFullScreen.h
//  AdsMogo
//
//  Created by MOGO on 13-2-19.
//
//

#import <Foundation/Foundation.h>
#import "AdMoGoWebBrowserControllerUserDelegate.h"
#import "AdViewType.h"
#import "AdMoGoAdNetworkAdapter.h"
#import "AdMoGoInterstitialDelegate.h"

@class AdMoGoAdNetworkAdapter;



@interface AdMoGoInterstitial : NSObject{
    
}

@property(nonatomic,assign) id<AdMoGoInterstitialDelegate> delegate;
@property(nonatomic,assign) id<AdMoGoWebBrowserControllerUserDelegate> adWebBrowswerDelegate;
//@property(nonatomic,retain) AdMoGoAdNetworkAdapter *adapter;
//@property(nonatomic,retain) NSTimer *timer;
//@property (nonatomic,readonly) NSString *configKey;
//@property(nonatomic,retain) NSString *mogoAppKey;

- (id) initWithAppKey:(NSString *)ak
            isRefresh:(BOOL)refreshed
           adInterval:(int)adInterval
               adType:(AdViewType)type
   adMoGoViewDelegate:(id<AdMoGoInterstitialDelegate>)delegate;


/**
 *进入展示时机
 *isWait:如果没有广告展示是否等待
 */
- (void)interstitialShow:(BOOL)isWait;

/**
 *离开展示时机
 */
- (void)interstitialCancel;


/*
    展示全屏
 */
-(void) present;

/*
    销毁全屏
 */
-(void) stopInterstitial;

/**
 *播放视频
 */
-(void)playVideoAd;

/*
    暂支持安沃插屏旋转
 */
- (void)interstitialorientationChanged:(UIInterfaceOrientation)orientation;

- (BOOL)isFullScreen;

@end
