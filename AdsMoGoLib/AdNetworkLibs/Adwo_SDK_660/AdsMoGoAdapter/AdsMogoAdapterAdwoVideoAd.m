//
//  AdsMogoAdapterAdwoVideoAd.m
//  wanghaotest
//
//  Created by ChaSel Chen on 15-4-3.
//
//

#import "AdsMogoAdapterAdwoVideoAd.h"
#import "AdMoGoConfigDataCenter.h"
#import "AdMoGoAdNetworkConfig.h"
#import "AdMoGoConfigData.h"
#import "AdMoGoDeviceInfoHelper.h"
static NSString* const adwoResponseErrorInfoList[] = {
  @"操作成功",
  @"广告初始化失败",
  @"当前广告已调用了加载接口",
  @"不该为空的参数为空",
  @"参数值非法",
  @"非法广告对象句柄",
  @"代理为空或adwoGetBaseViewController方法没实现",
  @"非法的广告对象句柄引用计数",
  @"意料之外的错误",
  @"广告请求太过频繁",
  @"广告加载失败",
  @"全屏广告已经展示过",
  @"全屏广告还没准备好来展示",
  @"全屏广告资源破损",
  @"开屏全屏广告正在请求",
  @"当前全屏已设置为自动展示",
  @"当前事件触发型广告已被禁用",
  @"没找到相应合法尺寸的事件触发型广告",
  
  @"服务器繁忙",
  @"当前没有广告",
  @"未知请求错误",
  @"PID不存在",
  @"PID未被激活",
  @"请求数据有问题",
  @"接收到的数据有问题",
  @"当前IP下广告已经投放完",
  @"当前广告都已经投放完",
  @"没有低优先级广告",
  @"开发者在Adwo官网注册的Bundle ID与当前应用的Bundle ID不一致",
  @"服务器响应出错",
  @"设备当前没连网络，或网络信号不好",
  @"请求URL出错"
};
@interface AdsMogoAdapterAdwoVideoAd()<AWAdViewDelegate>{
  BOOL isReady;
  BOOL isStop;
  UIView *mAdView;
  NSTimer *timer;
}




@end




@implementation AdsMogoAdapterAdwoVideoAd
+ (AdMoGoAdNetworkType)networkType{
  return AdMoGoAdNetworkTypeAdwo;
}

+ (void)load{
  [[AdMoGoAdAPIVideoNetworkRegistry sharedRegistry] registerClass:self];
}

-(BOOL)isReadyPresentInterstitial{
  return isReady;
}

- (void)getAd{
  isStop = NO;
  isReady = NO;
  AdMoGoConfigDataCenter *configDataCenter = [AdMoGoConfigDataCenter singleton];
  
  AdMoGoConfigData *configData = [configDataCenter.config_dict objectForKey:[self getConfigKey]];
  
  [self adapterDidStartRequestAd:self];
  AdViewType type =[configData.ad_type intValue];
  switch (type) {
    case AdViewTypeVideo:
      break;
    default:
      [self adapter:self didFailAd:nil];
      return;
      break;
  }
  
  NSString *appid = [self.ration objectForKey:@"key"];
  
  //    #define ADWO_PUBLISH_ID_FOR_DEMO        @"536a9c813d1a47f8a6a56b55638d904e"
  
  
  // 创建一个视频信息流广告对象
  mAdView = AdwoAdCreateImplantAd(appid, NO, self, nil, ADWOSDK_FSAD_SHOW_FORM_VIDEO);
  // 加载视频信息流广告
  if(!AdwoAdLoadImplantAd(mAdView, NULL))
  {
    NSLog(@"植入性广告加载失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
    
    // 移除视频信息流广告对象
    AdwoAdRemoveAndDestroyImplantAd(mAdView);
    mAdView = nil;
  }else{
    isReady=YES;
    [self adapter:self didReceiveInterstitialScreenAd:nil];
    MGLog(MGT, @"安沃加载成功...");
    return;
  }
  
  id _timeInterval = [self.ration objectForKey:@"to"];
  if ([_timeInterval isKindOfClass:[NSNumber class]]) {
    timer = [[NSTimer scheduledTimerWithTimeInterval:[_timeInterval doubleValue] target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
  }
  else{
    timer = [[NSTimer scheduledTimerWithTimeInterval:AdapterTimeOut15 target:self selector:@selector(loadAdTimeOut:) userInfo:nil repeats:NO] retain];
  }
  
}


- (UIViewController*)adwoGetBaseViewController
{
  UIViewController *viewContoller  = [self rootViewControllerForPresent];
  return viewContoller;
}

- (void)adwoAdViewDidFailToLoadAd:(UIView*)adView
{
  NSLog(@"植入性广告请求失败，由于：%@", adwoResponseErrorInfoList[AdwoAdGetLatestErrorCode()]);
  [self stopTimer];
  [self adapter:self didFailAd:nil];
}


- (void)stopTimer {
  if (timer) {
    [timer invalidate];
    [timer release];
    timer = nil;
  }
}
- (void)loadAdTimeOut:(NSTimer*)theTimer {
  [self stopTimer];
  [self stopBeingDelegate];
  [self adapter:self didFailAd:nil];
}



-(void)playVideoAd{
  UIViewController *viewController  = [self rootViewControllerForPresent];
  AdwoAdShowImplantAd(mAdView, viewController.view);
  // 激活植入性广告
  AdwoAdImplantAdActivate(mAdView);
}


- (void)adwoUserClosedVideoAd:(int)forceClose
{

    
    [self adapter:self didDismissScreen:nil];
}
- (void)adwoUserPlayVideoAd
{
  [self adapter:self didShowAd:nil];
}


-(void)stopBeingDelegate{
  if(mAdView != nil)
  {
    AdwoAdRemoveAndDestroyImplantAd(mAdView);
    mAdView = nil;
  }
}

- (void)dealloc {
  
  [self stopBeingDelegate];
  
  [super dealloc];
}

@end
