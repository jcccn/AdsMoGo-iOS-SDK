//
//  AdMogoNativeAdapterTanx.m
//  mogoNativeDemo
//
//  Created by Castiel Chen on 15/2/10.
//  Copyright (c) 2015年 ___ADSMOGO___. All rights reserved.
//

#import "AdMogoNativeAdapterTanx.h"
#import "AdsMogoNativeAdInfo.h"

@interface AdMogoNativeAdapterTanx(){
    int tanx_ad_count;
}
@end

@implementation AdMogoNativeAdapterTanx


+ (AdMoGoNativeAdNetworkType)networkType{
    return AdMoGoNativeAdNetworkTypeTanx;
}

+ (void)load {
    [[AdMoGoNativeRegistry sharedRegistry] registerClass:self];
}


- (void)loadAd:(int)adcount{
    tanx_ad_count =adcount;
    self->mDataManager = [[UMUFPFeedsDataManager alloc] initWithAppkey:nil slotId:[self.appKeys objectForKey:@"SlotID"] currentViewController:[self getAdMogoViewController]];
    self->mDataManager.delegate = (id<UMUFPFeedsDataManagerDelegate>)self;
    self->mDataManager.mContext = @"context";
    [self->mDataManager requestPromoterDataInBackground];
}


- (void)UMUFPFeedsDataManager:(UMUFPFeedsDataManager *)dataManager didLoadDataFinished:(MMUFeedsDataObject *)promotersInfo{
    NSMutableArray * array =[[NSMutableArray alloc]init];
    for (id objc in promotersInfo.promoters) {
        if (tanx_ad_count<=array.count) {
            break;  //返回数量超过了请求数量
        }
        AdsMogoNativeAdInfo *adsMogoNativeInfo =[[AdsMogoNativeAdInfo alloc]init];
        [adsMogoNativeInfo setValue:[objc objectForKey:@"title"] forKey:AdsMoGoNativeMoGoTitle];
        [adsMogoNativeInfo setValue:[objc objectForKey:@"icon"] forKey:AdsMoGoNativeMoGoIconUrl];
        [adsMogoNativeInfo setValue:[objc objectForKey:@"img"] forKey:AdsMoGoNativeMoGoImageUrl];
        [adsMogoNativeInfo setValue:[objc objectForKey:@"url"] forKey:AdsMoGoNativeMoGoLinkUrl];
        [adsMogoNativeInfo setValue:objc forKey:AdsMoGoNativeMoGoPdata];
        [adsMogoNativeInfo setValue:[self getMogoJsonByDic:adsMogoNativeInfo] forKey:AdsMoGoNativeMoGoJsonStr];
        [array addObject:adsMogoNativeInfo];
        [adsMogoNativeInfo release];
    }
    [self adMogoNativeSuccessAd:array];
} //called when promoter list loaded
- (void)UMUFPFeedsDataManager:(UMUFPFeedsDataManager *)dataManager didLoadDataFailWithError:(NSError *)error{
    
    [self adMogoNativeFailAd:-1];
}//called when promoter list loaded failed for some reason
- (void)UMUFPFeedsDataManager:(UMUFPFeedsDataManager *)dataManager didClickedPromoterAtIndex:(NSInteger)promoterIndex{

    
}

- (void)loadAdTimeOut:(NSTimer*)theTimer{
     [self adMogoNativeFailAd:-1];
}

-(void)dealloc{
    [super dealloc];
    if (mDataManager) {
        [mDataManager release],mDataManager=nil;
    }
}
@end
