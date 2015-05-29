//
//  AdMoGoNativeAdapterDoMob.m
//  mogoNativeDemo
//
//  Created by MOGO on 15-5-12.
//  Copyright (c) 2015年 ___ADSMOGO___. All rights reserved.
//

#import "AdMoGoNativeAdapterDMb.h"
#import "DMNativeAd.h"
#import "AdsMogoNativeAdInfo.h"
@interface AdMoGoNativeAdapterDMb()<DMNativeAdDelegate>{
    DMNativeAd *__nativeAd;
}
//@property(nonatomic,retain) DMNativeAd *nativeAd;
@end
@implementation AdMoGoNativeAdapterDMb
+ (AdMoGoNativeAdNetworkType)networkType{
    return AdMoGoNativeAdNetworkTypeDMb;
}

+ (void)load {
    [[AdMoGoNativeRegistry sharedRegistry] registerClass:self];
}
- (void)loadAd:(int)adcount{

    NSString *publisherID = [self.appKeys objectForKey:@"PublisherId"];
    NSString *placementID = [self.appKeys objectForKey:@"PlacementId"];
    __nativeAd = [[DMNativeAd alloc] initWithPublisherId:publisherID
                                                placementId:placementID
                                         rootViewController:[self getAdMogoViewController]
                                                   delegate:self];
    
    [__nativeAd loadAd];
}


//数据加载成功
- (void)dmNativeAdSuccessToLoadAd:(DMNativeAdModel *)adDataModel{
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    AdsMogoNativeAdInfo *adsMogoNativeInfo =[[AdsMogoNativeAdInfo alloc] init];
    [adsMogoNativeInfo setValue:adDataModel.adTitle forKey:AdsMoGoNativeMoGoTitle];
    [adsMogoNativeInfo setValue:adDataModel.adIcon.adUrl forKey:AdsMoGoNativeMoGoIconUrl];
    [adsMogoNativeInfo setValue:[NSNumber numberWithUnsignedLong:adDataModel.adIcon.adWidth] forKey:AdsMoGoNativeMoGoIconWidth];
    [adsMogoNativeInfo setValue:[NSNumber numberWithUnsignedLong:adDataModel.adIcon.adHeight] forKey:AdsMoGoNativeMoGoIconHeight];
    [adsMogoNativeInfo setValue:adDataModel.adDescription forKey:AdsMoGoNativeMoGoDesc];
    [adsMogoNativeInfo setValue:adDataModel.adMedia.adUrl forKey:AdsMoGoNativeMoGoImageUrl];
    [adsMogoNativeInfo setValue:[NSNumber numberWithUnsignedLong:adDataModel.adMedia.adWidth] forKey:AdsMoGoNativeMoGoImageWidth];
    [adsMogoNativeInfo setValue:[NSNumber numberWithUnsignedLong:adDataModel.adMedia.adHeight] forKey:AdsMoGoNativeMoGoImageHeight];
    [adsMogoNativeInfo setValue:[NSNumber numberWithUnsignedLong:adDataModel.adRatings] forKey:AdsMoGoNativeMoGoRating];
    [adsMogoNativeInfo setValue:adsMogoNativeInfo forKey:AdsMoGoNativeMoGoPdata];
    [adsMogoNativeInfo setValue:[self getMogoJsonByDic:adsMogoNativeInfo] forKey:AdsMoGoNativeMoGoJsonStr];
    
    [mutableArray addObject:adsMogoNativeInfo];
    [adsMogoNativeInfo release];
    [self adMogoNativeSuccessAd:mutableArray];
}

//数据加载失败
- (void)dmNativeAdFailToLoadAdWithError:(NSError *)error{
    [self adMogoNativeFailAd:-1];
}

//展示广告
-(void)attachAdView:(UIView*)view nativeData:(AdsMogoNativeAdInfo*)info{
    [super attachAdView:view nativeData:info];
    [__nativeAd performSelectorOnMainThread:@selector(trackImpression) withObject:nil waitUntilDone:NO];
}

//点击广告
-(void)clickAd:(AdsMogoNativeAdInfo*)info{
    [super clickAd:info];
    [__nativeAd processClickAction];
}
//请求广告超时
- (void)loadAdTimeOut:(NSTimer*)theTimer{
    [super loadAdTimeOut:theTimer];
    [self adMogoNativeFailAd:-1];
}

-(void)dealloc{
    if (__nativeAd) {
        __nativeAd.delegate = nil;
        [__nativeAd release],
        __nativeAd =nil;
    }
    [super dealloc];
    
}


@end
