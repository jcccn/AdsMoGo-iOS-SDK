//
//  AdMoGoAdapterRmobInterstitial.m
//  wanghaotest
//
//  Created by MOGO on 14-10-31.
//
//

#import "AdMoGoAdapterRmobInterstitial.h"

@implementation AdMoGoAdapterRmobInterstitial
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeRmob;
}

+ (void)load{
    [[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    isStopTimer = NO;
    isSuccess = NO;
    NSString *adzoneid = [[ration objectForKey:@"key"] objectForKey:@"adzoneid"];
    NSString *publisherID = [[ration objectForKey:@"key"] objectForKey:@"publisher ID"];
    BOOL testMode = [[self.ration objectForKey:@"testmodel"] intValue];
    
    [self adapterDidStartRequestAd:self];
    
    if (testMode) {
        _rmobInterstitial = [[RmobInterstitial alloc] initWithAppId:publisherID adzoneid:adzoneid adSize:RMOB_INTERSTITIALAD_SIZE_100 mode:ModeTest];
    }else{
        _rmobInterstitial = [[RmobInterstitial alloc] initWithAppId:publisherID adzoneid:adzoneid adSize:RMOB_INTERSTITIALAD_SIZE_100 mode:ModeRelease];
    }
        // 设置插屏广告的Delegate
        _rmobInterstitial.delegate = self;
    
    
}

- (BOOL)isReadyPresentInterstitial{
    return YES;
}

-(void)stopBeingDelegate{
    if(_rmobInterstitial){
        // 芒果调用多盟取消展示
       
        _rmobInterstitial.delegate = nil;
        [_rmobInterstitial release],_rmobInterstitial = nil;
    }
}

- (void)presentInterstitial{
    
    // 加载一条插屏广告
    [_rmobInterstitial loadRequest];
    
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
}

- (void)stopAd{
    [self stopBeingDelegate];
    isStop = YES;
}

- (void)dealloc {
    [super dealloc];
}


- (void)stopTimer {
    if (!isStopTimer) {
        isStopTimer = YES;
    }else{
        return;
    }
    if (timer) {
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

/*2013*/
- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop) {
        return;
    }
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];
}


- (void)rmobInterstitialDidReceiveAd
{
    NSLog(@"Rmobinterstitial Did Receive Ad,ad is ready.");
    if (isStop) {
        return;
    }
    if (isSuccess==NO) {
        isSuccess = YES;
    }else{
        return;
    }
    
    [self stopTimer];
    
    [self adapter:self didReceiveInterstitialScreenAd:_rmobInterstitial];
    
    
    // 在需要呈现插屏广告前，先通过isReady方法检查广告是否就绪
    if (_rmobInterstitial.isReady)
    {
        // 呈现插屏广告
        UIViewController *viewcontroller =  [self rootViewControllerForPresent];
        
        [_rmobInterstitial presentFromRootViewController:viewcontroller];
        [self adapter:self didShowAd:_rmobInterstitial];
    }
}

- (void)rmobInterstitialDidReceiveError:(NSError *)error;
{
    NSLog(@"rmobInterstitial Did Receive Error: %@",error);
    if(isStop){
        return;
    }
    
    [self stopTimer];
    
    [self adapter:self didFailAd:nil];
}

#pragma mark Display-Time Lifecycle Notifications

- (void)rmobInterstitialWillPresentScreen
{
    NSLog(@"Rmobinterstitial Will PresentScreen");
    [self adapter:self willPresent:_rmobInterstitial];
    
}

- (void)rmobInterstitialWillDismissScreen
{
    NSLog(@"Rmobinterstitial Will DismissScreen");
}

- (void)rmobInterstitialDidDismissScreen
{
    NSLog(@"Rmobinterstitial Did DismissScreen");
    [self adapter:self didDismissScreen:_rmobInterstitial];
}

//广告被点击
- (void)rmobAdDidClicked {
    NSLog(@"rmob interstitial Did Clicked.");
    [self specialSendRecordNum];
}

@end
