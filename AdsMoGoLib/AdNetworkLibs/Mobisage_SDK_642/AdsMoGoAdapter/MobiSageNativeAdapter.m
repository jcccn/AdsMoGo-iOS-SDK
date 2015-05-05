//
//  MobiSageNativeAdapter.m
//  test
//
//  Created by Castiel Chen on 15/1/21.
//  Copyright (c) 2015年 Castiel Chen. All rights reserved.
//

#import "MobiSageNativeAdapter.h"
#import "MobiSageAdFactory.h"
#import "MobiSageNative.h"
#import "MobiSageSDK.h"
#import "AdsMogoNativeAdInfo.h"


@interface MobiSageNativeAdapter (){
    int requestCount;
    NSMutableArray * adArray;
    BOOL isTimerOut;
    AdsMogoNativeAdInfo* clickInfo;
}
@end



@implementation MobiSageNativeAdapter

+ (AdMoGoNativeAdNetworkType)networkType{
    return AdMoGoNativeAdNetworkTypeMobiSage;
}

+ (void)load {
    [[AdMoGoNativeRegistry sharedRegistry] registerClass:self];
}


- (void)loadAd:(int)adcount{
    isTimerOut =NO;
    adArray =[[NSMutableArray alloc]init];
    
    [[MobiSageManager getInstance] setPublisherID:[self.appKeys objectForKey:@"PublisherID"] auditFlag:MS_Test_Audit_Flag];
    
    nativeGroup=[[MobiSageAdFactory alloc]init];
    nativeGroup.delegate=self;
    nativeGroup.options=@{@"disableToLoad":@(YES)};//
    nativeGroup.capacity=adcount;//请求广告数量
    requestCount =adcount;
    [nativeGroup requestWithWidth:320.0f slotToken:[self.appKeys objectForKey:@"slotToken"] completion:nil];

}
//展示广告
-(void)attachAdView:(UIView*)view nativeData:(AdsMogoNativeAdInfo*)info{
    [super attachAdView:view nativeData:info];
    [view addSubview:[info valueForKey:AdsMoGoNativeMoGoPdata]];
    [view bringSubviewToFront:[info valueForKey:AdsMoGoNativeMoGoPdata]];
}
//点击广告
-(void)clickAd:(AdsMogoNativeAdInfo*)info{
    [super clickAd:info];
}
//请求广告超时
- (void)loadAdTimeOut:(NSTimer*)theTimer{
    isTimerOut =YES;
    [super loadAdTimeOut:theTimer];
    if (adArray&&adArray.count>1) {
        [self adMogoNativeSuccessAd:adArray];
    }else{
        [self adMogoNativeFailAd:-1];
    }
}


-(void)mobiSageAdFactorySuccessToRequest:(MobiSageAdFactory*) aNative
{
    
}
-(void)mobiSageAdFactoryFaildToRequest:(MobiSageAdFactory*) aNative withError:(NSError*) error
{
    [self adMogoNativeFailAd:-1];
    
}
-(void)mobiSageNativeSuccessToRequest:(MobiSageNative*) aNative
{
    
}
-(void)mobiSageNativeFaildToRequest:(MobiSageNative*) aNative withError:(NSError*) error
{
    
}
//广告被点击
-(void)mobiSageNativeClick:(MobiSageNative*) aNative
{
    if (clickInfo) {
        [clickInfo release],clickInfo =nil;
    }
    clickInfo =[[AdsMogoNativeAdInfo alloc]init];
    [clickInfo setValue:[aNative.content objectForKey:@"title"] forKey:AdsMoGoNativeMoGoTitle];
    [clickInfo setValue:[aNative.content objectForKey:@"logo"] forKey:AdsMoGoNativeMoGoIconUrl];
    [clickInfo setValue:[aNative.content objectForKey:@"desc"] forKey:AdsMoGoNativeMoGoDesc];
    [clickInfo setValue:[aNative.content objectForKey:@"image"] forKey:AdsMoGoNativeMoGoImageUrl];
    [clickInfo setValue:aNative forKey:AdsMoGoNativeMoGoPdata];
    [clickInfo setValue:[self getMogoJsonByDic:clickInfo] forKey:AdsMoGoNativeMoGoJsonStr];
    [self clickAd:clickInfo];
}
//广告已展示
-(void)mobiSageNativeAppeared:(MobiSageNative*) aNative
{
    
}
//广告加载..
-(void)mobiSageNativeSuccessToLoaded:(MobiSageNative*) aNative {
    AdsMogoNativeAdInfo *adsMogoNativeInfo =[[AdsMogoNativeAdInfo alloc]init];
        [adsMogoNativeInfo setValue:[aNative.content objectForKey:@"title"] forKey:AdsMoGoNativeMoGoTitle];
        [adsMogoNativeInfo setValue:[aNative.content objectForKey:@"logo"] forKey:AdsMoGoNativeMoGoIconUrl];
        [adsMogoNativeInfo setValue:[aNative.content objectForKey:@"desc"] forKey:AdsMoGoNativeMoGoDesc];
        [adsMogoNativeInfo setValue:[aNative.content objectForKey:@"image"] forKey:AdsMoGoNativeMoGoImageUrl];
        [adsMogoNativeInfo setValue:aNative forKey:AdsMoGoNativeMoGoPdata];
        [adsMogoNativeInfo setValue:[self getMogoJsonByDic:adsMogoNativeInfo] forKey:AdsMoGoNativeMoGoJsonStr];
    [adArray addObject:adsMogoNativeInfo];
    [adsMogoNativeInfo release];
    if (requestCount==[adArray count]) {
        [self adMogoNativeSuccessAd:adArray];
    }
}
-(void)mobiSageNativeFaildToLoaded:(MobiSageNative*) aNative withError:(NSError*) error{
        [self adMogoNativeFailAd:-1];
}

-(void)dealloc{
    if (nativeGroup) {
        [nativeGroup release],nativeGroup=nil;
    }
    
    if(clickInfo){
        [clickInfo release],clickInfo=nil;
    }
    [super dealloc];
}


@end
