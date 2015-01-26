//
//  BOADRequestError.h
//  BalintimesO2OmobiAd
//
//  Created by yhw on 14-3-26.
//  Copyright (c) 2014年 Balintimes. All rights reserved.
//

#import <Foundation/Foundation.h>

/// Balintimes O2Omobi AD error domain.
extern NSString * const BOADErrorDomain;

/**
 *  错误编码
 */
typedef NS_ENUM(NSInteger, BOADErrorCode) {
    /**
     *  请求非法，请求参数不正确
     */
    BOADErrorCodeInvalidRequestError,
    /**
     *  网络请求失败
     */
    BOADErrorCodeNetworkError,
    /**
     *  网络请求超时
     */
    BOADErrorCodeTimeoutError,
    /**
     *  请求成功，没有返回广告内容
     */
    BOADErrorCodeNoContentError,
    /**
     *  请求成功，返回广告内容非法
     */
    BOADErrorCodeInvalidContentError,
    /**
     *  加载广告页面出错
     */
    BOADErrorCodeLoadAdPageError,
    /**
     *  间隙广告已经显示
     */
    BOADErrorCodeInterstitialAlreadyUsedError,
    /**
     *  请求成功，返回失败编码
     */
    BOADErrorCodeFailCodeError
};

/**
 *  错误类，用于定义错误编码和描述。
 */
@interface BOADError : NSError

@end
