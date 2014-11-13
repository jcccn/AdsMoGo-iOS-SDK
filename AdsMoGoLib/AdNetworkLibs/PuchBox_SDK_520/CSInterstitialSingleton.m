//
//  PBInterstitialSingleton.m
//  TestMOGOSDKAPI
//
//  Created by Daxiong on 14-3-27.
//  Copyright (c) 2014年 Daxiong. All rights reserved.
//

#import "ChanceAd.h"
#import "CSInterstitialSingleton.h"

static CSInterstitialSingleton *ins;

@interface CSInterstitialSingleton ()<CSInterstitialDelegate>{
    
    
    
}

@property (retain)NSString *publisherID;
@property (retain)NSString *placementID;

@end

@implementation CSInterstitialSingleton

@synthesize isReady;
@synthesize isError;
@synthesize delegate;
@synthesize publisherID;
@synthesize placementID;


+ (id)shareInstanceWithPID:(NSString *)pid{
    
    if (!ins) {
        ins = [[CSInterstitialSingleton alloc] initWithPid:pid];
    }
    
    return ins;
    
}

- (id)initWithPid:(NSString *)pid{
    
    if ((self = [super init])) {
        self.isError = NO;
        self.isReady = NO;
        [self initChanceAdWithPid:pid];
    }
    
    return self;
}


//init puchBoxAd
- (void) initChanceAdWithPid:(NSString *)pid{
    
    self.publisherID = pid;
    [ChanceAd startSession:pid];
    
}

//try to init interstitial ad
- (void) initInterstitialWithPlaceId:(NSString *)placeId{
    
    self.placementID = placeId;
    if ((self.isReady == NO) && (self.isError==YES)) {
        self.isError = NO;
        self.isReady = NO;
        [self loadInterstitial];
    }
    else{
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [self loadInterstitial];
        });
    }
    
}

- (void)loadInterstitial{

    CSADRequest *adRequest = [CSADRequest request];
    adRequest.placementID = self.placementID;
    [CSInterstitial sharedInterstitial].delegate = self;

    [[CSInterstitial sharedInterstitial] loadInterstitial:adRequest];
    
}

- (BOOL)showInterstitialWithScale:(float)scale{
    
    if (self.isReady) {
        BOOL isShow = [[CSInterstitial sharedInterstitial] showInterstitialWithScale:scale];
        
        if (isShow) {
            self.isReady = NO;
            self.isError = NO;
        }
        return isShow;
        
    }else{
        
        return NO;
        
    }
    
}

#pragma mark -
#pragma mark CSInterstitialDelegate method

// 弹出广告加载完成
- (void)csInterstitialDidLoadAd:(CSInterstitial *)csInterstitial{
    self.isReady = YES;
    self.isError = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(csInterstitialDidLoadAd:)]) {
        [self.delegate csInterstitialDidLoadAd:csInterstitial];
    }
}

// 弹出广告加载错误
- (void)csInterstitial:(CSInterstitial *)csInterstitial
loadAdFailureWithError:(CSRequestError *)requestError{
    self.isReady = NO;
    self.isError = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(csInterstitial:loadAdFailureWithError::)]) {
        [self.delegate csInterstitial:csInterstitial loadAdFailureWithError:requestError];
    }
}

// 弹出广告打开完成
- (void)csInterstitialDidPresentScreen:(CSInterstitial *)csInterstitial{
    if (self.delegate && [self.delegate respondsToSelector:@selector(csInterstitialDidPresentScreen:)]) {
        [self.delegate csInterstitialDidPresentScreen:csInterstitial];
    }
}

// 倒计时结束
- (void)csInterstitialCountDownFinished:(CSInterstitial *)csInterstitial{

}

// 弹出广告将要关闭
- (void)csInterstitialWillDismissScreen:(CSInterstitial *)csInterstitial{
    if (self.delegate && [self.delegate respondsToSelector:@selector(csInterstitialWillDismissScreen:)]) {
        [self.delegate csInterstitialWillDismissScreen:csInterstitial];
    }
}

// 弹出广告关闭完成
- (void)csInterstitialDidDismissScreen:(CSInterstitial *)csInterstitial{
    if (self.delegate && [self.delegate respondsToSelector:@selector(csInterstitialDidDismissScreen:)]) {
        [self.delegate csInterstitialDidDismissScreen:csInterstitial];
    }
    
    [self loadInterstitial];
}




@end
