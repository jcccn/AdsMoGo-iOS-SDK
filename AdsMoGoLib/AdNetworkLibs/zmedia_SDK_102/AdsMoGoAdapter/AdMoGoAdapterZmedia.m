//
//  AdMoGoAdapterZmedia.m
//  wanghaotest
//
//  Created by mogo on 14-7-28.
//
//

#import "AdMoGoAdapterZmedia.h"
#import  "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
@implementation AdMoGoAdapterZmedia
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetwokrTypeZmedia;
}

+(void)load{
    [[AdMoGoAdSDKBannerNetworkRegistry sharedRegistry] registerClass:self];
}

-(void)getAd{
    isStopTimer = NO;
    isStop = NO;
    isSuccess = NO;
    isFail= NO;
    
    id _timeInterval = [self.ration objectForKey:@"to"];
    if ([_timeInterval isKindOfClass:[NSNumber class]]) {
        timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    else{
        timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut8 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
    }
    
    NSString *publishID = [[self.ration objectForKey:@"key"] objectForKey:@"PublishID"];
    
    NSString *ADSpace = [[self.ration objectForKey:@"key"] objectForKey:@"ADSpace"];
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:adMoGoCore.config_key];
    
    if ([configData islocationOn]) {
         [ZMSDK createSharedObjectWithPublishID:publishID andLocation:YES];
    }else{
        [ZMSDK createSharedObjectWithPublishID:publishID andLocation:NO];
    }
   

    ZmediaSingleton *zmediasingletion = [ZmediaSingleton shareInstance];
    zmediasingletion.delegate = self;
    [ZMSDK setRequestDelegate:zmediasingletion];
    
    adView = [ZMSDK GetBannerWithADSpace:ADSpace];
    
//    NSLog(@"adview %@",adView);
    self.adNetworkView = adView;
    if (isFail) {
        [adMoGoCore adapter:self didFailAd:nil];
    }else{
        CGRect frame = self.adNetworkView.frame;
        frame.origin.x = 0;
        frame.origin.y = 0;
        self.adNetworkView.frame = frame;
         [adMoGoCore adapter:self didReceiveAdView:self.adNetworkView];
    }
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

- (void)loadAdTimeOut:(NSTimer*)theTimer {
    
    if (isStop) {
        return;
    }
    
    [self stopTimer];
    
    [adMoGoCore adapter:self didFailAd:nil];
}

- (void)dealloc {
    isStop = YES;
    
    adView.delegate = nil;
//    [ZMSDK setRequestDelegate:nil];
	[super dealloc];
}


- (void)stopAd{
   
    NSString *ADSpace = [[self.ration objectForKey:@"key"] objectForKey:@"ADSpace"];
    [ZMSDK hiddenBannerWithADSpace:ADSpace];
    ZmediaSingleton *zmediasingletion = [ZmediaSingleton shareInstance];
    zmediasingletion.delegate = nil;
}

- (void)stopBeingDelegate {
    adView.delegate = nil;
}

-(void)ZMSDKBannerDelegateClick{

    
}


-(void)ZMSDKBannerDelegateRequestSuccess:(BOOL)flag{
    if (isStop) {
        return;
    }
    [self stopTimer];
    if (isSuccess ==  isFail && isFail ==NO) {
        if (flag) {
            isSuccess = YES;
            
           
        }else{
            isFail = YES;
            
        }
    }
    
}

@end
