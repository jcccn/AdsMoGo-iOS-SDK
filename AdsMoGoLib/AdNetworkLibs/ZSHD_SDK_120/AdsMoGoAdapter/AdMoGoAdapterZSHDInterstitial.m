//
//  AdMoGoAdapterLimeiInterstitial.m
//  wanghaotest
//
//  Created by MOGO on 13-9-11.
//
//

#import "AdMoGoAdapterZSHDInterstitial.h"
#import "AdMoGoAdNetworkRegistry.h"
#import "AdMoGoAdNetworkAdapter+Helpers.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"

@implementation AdMoGoAdapterZSHDInterstitial



+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypePagodaPearl;
}

+ (void)load {
	[[AdMoGoAdSDKInterstitialNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isStop = NO;
    isReady = NO;
    isStopTimer = NO;
    iserror = NO;
    id key = [self.ration objectForKey:@"key"];
    NSLog(@"Key:%@",key);

    if ([key isKindOfClass:[NSString class]]) {
         UIViewController *viewController = [self rootViewControllerForPresent];
//        [PagodaPearl initPagodaFoundation:@"0000A803130000ED" viewController:viewController delegate:self];
        [PagodaPearl initPagodaFoundation:key viewController:viewController delegate:self];
        [PagodaPearl requestPagodaPearl];
        [PagodaPearl whetherLoadAfterShow:NO];
        NSLog(@"SDK Version：%@",[PagodaPearl getVersion]);
        [PagodaPearl getDevices:@"iphone"];
        
        [self adapterDidStartRequestAd:self];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if ([_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
    else{
        [self adapter:self didFailAd:nil];
        return;
    }


}

- (void)stopBeingDelegate{
    
}


- (void)stopAd{
    [self stopTimer];
}

- (void)stopTimer{
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
    
    [super loadAdTimeOut:theTimer];
    
    [self stopTimer];
    [self stopBeingDelegate];
    [self adapter:self didFailAd:nil];

}

- (void)dealloc {
    
    [super dealloc];
}

- (BOOL)isReadyPresentInterstitial{
    return isReady;
}

- (void)presentInterstitial{
    [PagodaPearl showPagodaPearl];
}

- (void)loadNextAdapter{
    [self adapter:self didDismissScreen:nil];
}

- (void)loadFail{
     [self adapter:self didFailAd:nil];
}


#pragma mark - PagodaPearl delegate
- (void)getNetworkType:(NetworkType)type{
    
    if (type == networkWIFI) {
        NSLog(@"当前网络状态为WI-FI");
    } else if (type == networkWWAN){
        NSLog(@"当前网络状态为WWAN");
    } else {
        NSLog(@"当前网络状态未获取到，请判断网络后重新请求！");
    }
    
}

- (void)requestPagodaPearlResult:(RequestPagodaPearlResult)result{
    if (isStop) {
        return;
    }
    [self stopTimer];
    if (result == requestPagodaPearlSuccess) {
        NSLog(@"请求数据成功");
        if (isReady) {
            return;
        }
        isReady = YES;
        [self adapter:self didReceiveInterstitialScreenAd:result];
        NSLog(@"芒果发送成功");
        return;

    } else if (result == requestPagodaPearlErrorOne){
        NSLog(@"请求数据失败，错误 --1--");
    } else if (result == requestPagodaPearlErrorTwo){
        NSLog(@"请求数据失败，错误 --2--");
    } else if (result == requestPagodaPearlErrorThree){
        NSLog(@"请求数据失败，错误 --3--");
    } else if (result == requestPagodaPearlErrorFour){
        NSLog(@"请求数据失败，错误 --4--");
    } else if (result == requestPagodaPearlErrorFive){
        NSLog(@"请求数据失败，错误 --5--");
    } else if (result == requestPagodaPearlErrorSix){
        NSLog(@"请求数据失败，错误 --6--");
    }
}

- (void)showPagodaPearlResult:(ShowPagodaPearlResult)result{
    
    if (result == showPagodaPearlSuccess) {
        NSLog(@"展示成功");
        [self adapter:self willPresent:result];
        [self adapter:self didShowAd:result];
    } else{
        NSLog(@"展示失败");
        [self adapter:self didDismissScreen:result];
    }
    
}

- (void)closePagodaPearlResult:(ClosePagodaPearlResult)result{
    
    if (result == closePagodaPearlSuccess) {
        NSLog(@"关闭成功");
        [self adapter:self didDismissScreen:result];

    } else{
        NSLog(@"关闭失败");
        [self adapter:self didDismissScreen:result];
    }
}


@end
