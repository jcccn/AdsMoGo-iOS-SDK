//
//  PagodaPearl.h
//  PagodaPearl
//
//  Created by cloud on 14-10-28.
//  Copyright (c) 2014年 cloud. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum{
    requestPagodaPearlSuccess = 0,
    requestPagodaPearlErrorOne,
    requestPagodaPearlErrorTwo,
    requestPagodaPearlErrorThree,
    requestPagodaPearlErrorFour,
    requestPagodaPearlErrorFive,
    requestPagodaPearlErrorSix
}RequestPagodaPearlResult;

typedef enum{
    showPagodaPearlSuccess = 0,
    showPagodaPearlFail
}ShowPagodaPearlResult;

typedef enum{
    closePagodaPearlSuccess = 0,
    closePagodaPearlFail
}ClosePagodaPearlResult;

typedef enum {
    networkNotReachable = 0,
    networkWIFI,
    networkWWAN
}NetworkType;

@protocol PagodaPearlDelegate <NSObject>

@optional
- (void)requestPagodaPearlResult:(RequestPagodaPearlResult)result;

- (void)showPagodaPearlResult:(ShowPagodaPearlResult)result;

- (void)closePagodaPearlResult:(ClosePagodaPearlResult)result;

- (void)getNetworkType:(NetworkType)type;

@end


@interface PagodaPearl : NSObject

+ (void)initPagodaFoundation:(NSString *)foundation viewController:(UIViewController *)viewController delegate:(id<PagodaPearlDelegate>) delegate;

+ (void)requestPagodaPearl;

+ (void)showPagodaPearl;


+ (void)whetherLoadAfterShow:(BOOL)isNoLoading;

+ (NSString *)getVersion;

+ (void)getDevices:(NSString *)devices;

@end
