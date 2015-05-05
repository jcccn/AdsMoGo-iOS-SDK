//
//  TalkingDataAdAntiFraud.h
//  TalkingData
//
//  Created by liweiqiang on 14-4-28.
//  Copyright (c) 2014年 TendCloud. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    AdNetworkDOMOB,
    AdNetworkLIMEI, 
    AdNetworkYOUMI,
    AdNetworkYIQILIAN
} AdNetwork;

@interface TalkingDataAdAntiFraud : NSObject

+ (void)onAdDisplay:(AdNetwork)adNetwork adId:(NSString *)adId targetAppId:(NSString *)targetAppId mediaId:(NSString *)mediaId impressionId:(NSString *)impressionId;
+ (void)onAdClick:(AdNetwork)adNetwork adId:(NSString *)adId targetAppId:(NSString *)targetAppId mediaId:(NSString *)mediaId clickId:(NSString *)clickId;

@end
