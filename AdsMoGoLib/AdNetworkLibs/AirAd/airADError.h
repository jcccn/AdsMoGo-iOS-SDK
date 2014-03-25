//
//  airADError.h
//  airADKit
//
//  Created by Qian Kun on 12/26/11.
//  Copyright (c) 2011 MitianTech. All rights reserved.
//

enum ErrorCode{
  //如果设置没有正确的appId,会发送此错误
  kAErrorAppIDFailed,
  
  //如果请求广告的位置处于国外,会发送此错误
  kAErrorIPIllegal,
  
  //请求正常,但无广告
  kAErrorNoAdFill,
  
  //网络加载错误
  kAErrorNetworkError,
  
  //服务器加载错误
  kAErrorServerError,
  
  //其他参数设置错误
  kAErrorInvalidParameter,
};
