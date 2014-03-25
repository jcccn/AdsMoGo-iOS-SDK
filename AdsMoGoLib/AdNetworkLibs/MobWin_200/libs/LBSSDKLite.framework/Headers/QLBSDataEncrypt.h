//
//  QLBSDataEncrypt.h
//  LBSSDK
//
//  Created by lin ease on 12-5-18.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

#ifndef LBSSDK_QLBSDataEncrypt_h
#define LBSSDK_QLBSDataEncrypt_h

#if defined(__cplusplus)
extern "C" {
#endif

/**
 *	@brief 计算经纬度之间的距离
 *	@param[in] alat A维度
 *	@param[in] alog A经度
 *	@param[in] blat B维度
 *	@param[in] blog B经度
 *	@return 两点间距离(km)
 */
extern double qlbsCalculateDistance(double alat, double alog, double blat, double blog);
    
/**
 *	@brief 判断经纬度是否符合定位平台的定位范围，目前定位平台只是针对国内的Gps有效
 *	@note 假如不符合定位平台的范围，服务器可能返回异常
 *	@param[in] lat 维度
 *	@param[in] log 经度
 *	@return 是否处于定位平台有效的国内Gps范围
 */
extern BOOL qlbsIsPlatformSupport(double lat, double log);

/**
 *	@brief 获取定位平台api所需要的地理位置信息加密buffer
 *	@note 输出加密buffer，假如失败，返回nil
 *	@param[in] accName 定位平台的账户名，必要参数
 *	@param[in] accPassword 定位平台的账户密码，必要参数
 *	@param[in] lat 定位纬度，必要参数
 *	@param[in] log 定位经度，必要参数
 *	@param[in] timeInterval 定位的时间戳，非必要参数
 *	@param[in] usr 定位的用户，可以是QQ，可以是其它东西，非必要参数
 *	@return 加密buffer
 */
extern NSData * qlbsExportPlatformDeviceData(NSString * accName, NSString * accPassword, double lat, double log, double timeInterval, NSString * usr);

#if defined(__cplusplus)
}
#endif	
	
#endif
