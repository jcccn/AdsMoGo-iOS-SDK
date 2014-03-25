//
//  AdMoGoAdapterZhiXunSplash.m
//  wanghaotest
//
//  Created by mogo on 14-2-25.
//
//
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoAdapterZhiXunSplash.h"

@implementation AdMoGoAdapterZhiXunSplash
+ (AdMoGoAdNetworkType)networkType{
    return AdMoGoAdNetworkTypeZhiXun;
}

+ (void)load{
    [[AdMoGoAdSDKSplashNetworkRegistry sharedRegistry] registerClass:self];
}

- (void)getAd{
    isFail = NO;
    isSuccess = NO;
    isStop = NO;
    isLoaded = NO;
    
    AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
    
    AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:splashAds.config_key];
    
    AdViewType type =[configData.ad_type intValue];
    
	if (type == AdViewTypeSplash) {
        
        NSString *key = [self.ration objectForKey:@"key"];
        CGRect rect = CGRectZero;
        NSString *imageName = [self.splashAds getBackgroundImageName];
        imageName = [NSString stringWithFormat:@"%@.png",imageName];
        LAYOUT_TYPE laytoutype = type320_50;
        if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) {
            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ) {
                rect=CGRectMake(0, 0, 1024, 768);
                laytoutype=type1024_768;
            }else{
                rect=CGRectMake(0, 0, 768, 1024);
                laytoutype=type768_1024;
            }
            
        }else{
            if (UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation) ) {
                //判断是否是iPhone5
                if (CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) {
                    rect=CGRectMake(0, 0, 568, 320);
                }else
                {
                    rect=CGRectMake(0, 0, 480, 320);
                }
                laytoutype=type480_320;
            }else{
                //判断是否是iPhone5
                if (CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size)) {
                    rect=CGRectMake(0, 0, 320, 568);
                }else
                {
                    rect=CGRectMake(0, 0, 320, 480);
                }
                laytoutype=type320_480;
            }
            
            
        }
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splashadfinish) name:@"adArriveRecivedFinishNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splashaderror) name:@"adArriveRecivedErrorNotification" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(splashadclick) name:@"adArriveClickNotification" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(splashadclose) name:@"adArriveSplashCloseNotification" object:nil];
        
        AdSplashController * adSplash=[[AdSplashController alloc] initWithPublisherId:key window:[self.splashAds getWindow] defaultName:imageName defaultrect:rect layoutType:laytoutype X:0 Y:0];
        [adSplash start];
        
        [self.splashAds adapterDidStartRequestSplashAd:self];
        id _timeInterval = [self.ration objectForKey:@"to"];
        if (_timeInterval && [_timeInterval isKindOfClass:[NSNumber class]]) {
            timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
        else{
            timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut12 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
        }
    }
    else{
        [self adFailWith:nil];
    }
}

- (void)adSuccess:(id) _awSplash{
    if (isSuccess==isFail && isSuccess == NO) {
        isSuccess = YES;
        [self.splashAds adSplashSuccess:self withSplash:_awSplash];
    }
}

- (void)adFailWith:(NSError *)error{
    if (isSuccess==isFail && isFail == NO) {
        isFail = YES;
        [self.splashAds adSplashFail:self withError:error];
    }
}

- (void)dealloc {
    [super dealloc];
}

- (void)stopTimer {
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
    [self stopTimer];
    [self stopBeingDelegate];
    [self adFailWith:nil];
}

- (void)stopBeingDelegate {
    /*2013*/
}

#pragma mark ZhiXunNotification Delegate
// 当开屏广告被成功加载后，回调该方法
-(void)splashadfinish{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adSuccess:nil];
    
}

// 当开屏广告加载失败后，回调该方法
-(void)splashaderror
{
    if (isStop) {
        return;
    }
    [self stopTimer];
    [self adFailWith:nil];
}

-(void)splashadclick{
    if ([self.splashAds respondsToSelector:@selector(sendClickCountWithAdAdpter:)]) {
        [self.splashAds sendClickCountWithAdAdpter:self];
    }
}

-(void)splashadclose{
    [self.splashAds adSplash:self didDismiss:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
