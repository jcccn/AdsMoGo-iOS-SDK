//
//  PBInterstitialSingleton.m
//  TestMOGOSDKAPI
//
//  Created by Daxiong on 14-3-27.
//  Copyright (c) 2014年 Daxiong. All rights reserved.
//

#import "PunchBoxAd.h"
#import "PBInterstitialSingleton.h"

static PBInterstitialSingleton *ins;

@interface PBInterstitialSingleton ()<PBInterstitialDelegate>{
    
    
    
}

@property (retain)NSString *punchBoxID;
@property (retain)NSString *placementID;

@end

@implementation PBInterstitialSingleton

@synthesize isReady;
@synthesize isError;
@synthesize delegate;
@synthesize punchBoxID;
@synthesize placementID;


+ (id)shareInstanceWithPID:(NSString *)pid{
    
    if (!ins) {
        ins = [[PBInterstitialSingleton alloc] initWithPid:pid];
    }
    
    return ins;
    
}

- (id)initWithPid:(NSString *)pid{
    
    if ((self = [super init])) {
        self.isError = NO;
        self.isReady = NO;
        [self initPunchBoxAdWithPid:pid];
    }
    
    return self;
}


//init puchBoxAd
- (void) initPunchBoxAdWithPid:(NSString *)pid{
    
    self.punchBoxID = pid;
    [PunchBoxAd startSession:pid];
    
}

//try to init interstitial ad
- (void) initInterstitialWithPlaceId:(NSString *)placeId{
    
    self.placementID = placeId;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        [self loadInterstitial];
        
    });
    
}

- (void)loadInterstitial{

    PBADRequest *adRequest = [PBADRequest request];
    adRequest.placementID = self.placementID;
    [PBInterstitial sharedInterstitial].delegate = self;
//    [PBInterstitial sharedInterstitial].orientationSupported = PBOrientationSupported_Auto;
    [[PBInterstitial sharedInterstitial] loadInterstitial:adRequest];
    
}

- (BOOL)showInterstitialWithScale:(float)scale{
    
    if (self.isReady) {
        
//        BOOL isShow = [[PBInterstitial sharedInterstitial] showInterstitialOnRootView:[UIApplication sharedApplication].keyWindow withScale:scale];
        
        BOOL isShow = [[PBInterstitial sharedInterstitial] showInterstitialWithScale:scale];
        
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
#pragma mark PBInterstitialDelegate method
// 弹出广告加载完成
- (void)pbInterstitialDidLoadAd:(PBInterstitial *)pbInterstitial{
    
    self.isReady = YES;
    self.isError = NO;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pbInterstitialDidLoadAd:)]) {
        [self.delegate pbInterstitialDidLoadAd:pbInterstitial];
    }
    
}

// 弹出广告加载错误
- (void)pbInterstitial:(PBInterstitial *)pbInterstitial
loadAdFailureWithError:(PBRequestError *)requestError{
    self.isReady = NO;
    self.isError = YES;
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pbInterstitial:loadAdFailureWithError::)]) {
        [self.delegate pbInterstitial:pbInterstitial loadAdFailureWithError:requestError];
    }
    
    [self loadInterstitial];
    
}

// 弹出广告打开完成
- (void)pbInterstitialDidPresentScreen:(PBInterstitial *)pbInterstitial{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pbInterstitialDidPresentScreen:)]) {
        [self.delegate pbInterstitialDidPresentScreen:pbInterstitial];
    }
    
}

// 弹出广告将要关闭
- (void)pbInterstitialWillDismissScreen:(PBInterstitial *)pbInterstitial{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pbInterstitialWillDismissScreen:)]) {
        [self.delegate pbInterstitialWillDismissScreen:pbInterstitial];
    }
    
}

// 弹出广告关闭完成
- (void)pbInterstitialDidDismissScreen:(PBInterstitial *)pbInterstitial{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(pbInterstitialDidDismissScreen:)]) {
        [self.delegate pbInterstitialDidDismissScreen:pbInterstitial];
    }
    
    [self loadInterstitial];
    
}


@end
