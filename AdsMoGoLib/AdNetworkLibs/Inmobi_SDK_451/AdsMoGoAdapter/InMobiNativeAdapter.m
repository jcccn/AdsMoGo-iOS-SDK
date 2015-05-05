//
//  InMobiNativeAdapter.m
//  mogoNativeDemo
//
//  Created by Castiel Chen on 15/1/7.
//  Copyright (c) 2015年 ___ADSMOGO___. All rights reserved.
//

#import "InMobiNativeAdapter.h"
#import "IMNative.h"
#import "InMobi.h"
#import "AdsMogoNativeAdInfo.h"

@implementation InMobiNativeAdapter


+ (AdMoGoNativeAdNetworkType)networkType{

    return AdMoGoNativeAdNetworkTypeInMobi;
}

+ (void)load {
    [[AdMoGoNativeRegistry sharedRegistry] registerClass:self];
}

- (void)loadAd:(int)adcount{
    [InMobi setLogLevel:IMLogLevelVerbose];
    [InMobi initialize:[self.ration objectForKey:@"k"]];
    self.native = [[IMNative alloc] initWithAppId:[self.ration objectForKey:@"k"]];
    self.native.delegate = self;
    [self.native loadAd];
}

-(void)nativeAdDidFinishLoading:(IMNative*)native
{
    NSError *error;
    NSData *data = [native.content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *imobiDict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:&error];
    NSMutableArray *mutableArray = [[NSMutableArray alloc] init];
    NSDictionary *keydict = [self inmobiinbis];
    AdsMogoNativeAdInfo *adsMogoNativeInfo =[[AdsMogoNativeAdInfo alloc]init];
    [adsMogoNativeInfo setValue:[imobiDict objectForKey:[keydict objectForKey:@"title"]] forKey:AdsMoGoNativeMoGoTitle];
    [adsMogoNativeInfo setValue:[[imobiDict objectForKey:[keydict objectForKey:@"icon"]] objectForKey:@"url"] forKey:AdsMoGoNativeMoGoIconUrl];
     [adsMogoNativeInfo setValue:[[imobiDict objectForKey:[keydict objectForKey:@"icon"]] objectForKey:@"width"] forKey:AdsMoGoNativeMoGoIconWidth];
     [adsMogoNativeInfo setValue:[[imobiDict objectForKey:[keydict objectForKey:@"icon"]] objectForKey:@"height"] forKey:AdsMoGoNativeMoGoIconHeight];
    [adsMogoNativeInfo setValue:[imobiDict objectForKey:[keydict objectForKey:@"description"]] forKey:AdsMoGoNativeMoGoDesc];
    [adsMogoNativeInfo setValue:[[imobiDict objectForKey:[keydict objectForKey:@"screenshots"]] objectForKey:@"url"] forKey:AdsMoGoNativeMoGoImageUrl];
     [adsMogoNativeInfo setValue:[[imobiDict objectForKey:[keydict objectForKey:@"screenshots"]] objectForKey:@"width"] forKey:AdsMoGoNativeMoGoImageWidth];
     [adsMogoNativeInfo setValue:[[imobiDict objectForKey:[keydict objectForKey:@"screenshots"]] objectForKey:@"height"] forKey:AdsMoGoNativeMoGoImageHeight];
    
    [adsMogoNativeInfo setValue:[imobiDict objectForKey:[keydict objectForKey:@"rating"]] forKey:AdsMoGoNativeMoGoRating];
    
    [adsMogoNativeInfo setValue:imobiDict forKey:AdsMoGoNativeMoGoPdata];
    [adsMogoNativeInfo setValue:[self getMogoJsonByDic:adsMogoNativeInfo] forKey:AdsMoGoNativeMoGoJsonStr];
    [mutableArray addObject:adsMogoNativeInfo];
    [adsMogoNativeInfo release];
    [self adMogoNativeSuccessAd:mutableArray];
}

-(void)nativeAd:(IMNative*)native didFailWithError:(IMError*)error
{
    [self adMogoNativeFailAd:-1];
}

- (NSDictionary*)dictFromNativeContent:(NSString*)nativeContent {
    
    if (nativeContent==nil) {
        return nil;
    }
    NSData* data = [nativeContent dataUsingEncoding:NSUTF8StringEncoding];
    NSError* error = nil;
    NSDictionary* jsonDict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSMutableDictionary* nativeJsonDict = [NSMutableDictionary dictionaryWithDictionary:jsonDict];
    return nativeJsonDict;
}


//展示广告
-(void)attachAdView:(UIView*)view nativeData:(AdsMogoNativeAdInfo*)info{
    [super attachAdView:view nativeData:info];
    [self.native attachToView:view];
}

//点击广告
-(void)clickAd:(AdsMogoNativeAdInfo*)info{
    [super clickAd:info];
    NSDictionary *dict = [info valueForKey:AdsMoGoNativeMoGoPdata];
     NSDictionary *keydict = [self inmobiinbis];
    NSString *url = [dict valueForKey:[keydict objectForKey:@"url"]];
    NSURL* URL = [NSURL URLWithString:url];
    [[UIApplication sharedApplication] openURL:URL];
    [self.native handleClick:nil];
}

//停止请求广告
- (void)stopAd{
}

//请求广告超时
- (void)loadAdTimeOut:(NSTimer*)theTimer{
     [super loadAdTimeOut:theTimer];
    [self adMogoNativeFailAd:-1];
}



-(void)dealloc{
    if (_native) {
        [_native release],_native =nil;
    }
    [super dealloc];
  
}
@end
