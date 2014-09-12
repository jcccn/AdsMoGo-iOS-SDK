//
//  AdMoGoAdapterZmediaFullScreen.m
//  wanghaotest
//
//  Created by mogo on 14-7-28.
//
//

#import "AdMoGoAdapterZmediaFullScreen.h"

@implementation AdMoGoAdapterZmediaFullScreen
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetwokrTypeZmedia;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd {
    isError = NO;
    isReady = NO;
    isPresent = NO;
    isStop = NO;
    isSuccess = NO;
    NSString *publishID = [[self.ration objectForKey:@"key"] objectForKey:@"PublishID"];
    
    NSString *ADSpace = [[self.ration objectForKey:@"key"] objectForKey:@"ADSpace"];
    ZmediaSingleton *zmediasingletion = [ZmediaSingleton shareInstance];
    zmediasingletion.delegate = self;
    [ZMSDK createSharedObjectWithPublishID:publishID];
    [ZMSDK sharedObject].AllianceFlag = 1;//值为1.将插屏广告流程分成加载与展示两步     值为0.调用一次方法即自动完成加载及显示两个过程
    [ZMSDK setRequestDelegate:zmediasingletion];
    [ZMSDK GetIntervalWithADSpace:ADSpace];
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    
    [self performSelectorOnMainThread:@selector(showZMIntersitial) withObject:nil waitUntilDone:NO];
    
    
}

- (void)showZMIntersitial{
    NSString *ADSpace = [[self.ration objectForKey:@"key"] objectForKey:@"ADSpace"];
    [ZMSDK showIntervalWithADSpace:ADSpace];
    [self adapter:self didShowAd:nil];
}

- (void)dealloc {
    NSLog(@"%s",__func__);
    isStop = YES;
    
    
	[super dealloc];
}

- (void)stopBeingDelegate {
}

- (void)stopAd{
    isStop = YES;
    ZmediaSingleton *zmediasingletion = [ZmediaSingleton shareInstance];
    zmediasingletion.delegate = nil;
    NSString *ADSpace = [[self.ration objectForKey:@"key"] objectForKey:@"ADSpace"];
    [ZMSDK DestructionIntervalWithADSpace:ADSpace];
}

-(void)ZMSDKIntervalViewDelegateClick{
    [self specialSendRecordNum];
}


-(void)ZMSDKIntervalViewDelegateClose{
   [self adapter:self didDismissScreen:nil];
}



-(void)ZMSDKIntervalViewDelegateLoadSuccess:(BOOL)flag{
    NSLog(@"插屏加载%@ %@",(flag?@"成功":@"失败"),self);
}
-(void)ZMSDKIntervalViewDelegateRequestSuccess:(BOOL)flag{
    NSLog(@"插屏请求%@ %@",(flag?@"成功":@"失败"),self);
    [self stopTimer];
    if (flag) {
        isReady = YES;
        
        [self adReviceStatus:YES];
    }else{
        [self adReviceStatus:NO];
    }
}
-(void)ZMSDKIntervalViewDelegateShowSuccess:(BOOL)flag{
    NSLog(@"插屏展示%@ %@",(flag?@"成功":@"失败"),self);
    if (flag) {
        
    }else{
        
    }
    
}

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    if (isStop || isError || isReady ||isPresent) {
        return;
    }
    isError = YES;
    [self stopTimer];
//    [self adapter:self didFailAd:nil];
    [self adReviceStatus:NO];
}

- (void)stopTimer {
    dispatch_sync(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void){
        if (timer) {
            [timer invalidate];
            [timer release];
            timer = nil;
        }
    });
}

- (void)adReviceStatus:(BOOL)flag{
    if (isError==isSuccess && isError == NO) {
        if (flag) {
            isSuccess = YES;
            
            [self adapter:self didReceiveInterstitialScreenAd:nil];
        }else{
            isError = NO;
            [self adapter:self didFailAd:nil];
        }
    }
}

@end
