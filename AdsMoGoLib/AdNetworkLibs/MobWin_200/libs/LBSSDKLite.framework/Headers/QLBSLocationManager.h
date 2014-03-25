//
//  QLBSLocateManager.h
//  LBSSDK
//
//  Created by easelin on 11-10-14.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@class QLBSLocationManager;

@protocol QLBSLocationManagerDelegate<NSObject>
@required
/** 
 *	@brief 定位成功回调
 */
- (void)lbsLocationManager:(QLBSLocationManager *)manager locateSuccess:(CLLocation *)location;
/** 
 *	@brief 定位失败回调
 */
- (void)lbsLocationManager:(QLBSLocationManager *)manager locateFailed:(NSError *)error;
@optional
/** 
 *	@brief 定位超时回调，带入一个精度最高的，假如没有Gps，location参数为nil
 */
- (void)lbsLocationManager:(QLBSLocationManager *)manager locateTimeOut:(CLLocation *)location;
@end

/**
 *	@brief 定位载体
 */
@interface QLBSLocationManager : NSObject<CLLocationManagerDelegate>
{
@private    
	id<QLBSLocationManagerDelegate> _delegate;
	CLLocationManager       *_sys_manager;
	CLLocation              *_last_location;
	NSTimer                 *_timer;
	CLLocationAccuracy       _locateAccuracy;
	NSTimeInterval           _locateTimeOut;
	float					 _sysVersion;
	BOOL                     _isUpdatingLocation;
	BOOL                     _isAlwaysLocate;
	BOOL                     _isHasTimeOut;
    BOOL                     _isIncAskTimeOut;
}
/** 
 *	@brief 回调指针
 */
@property (nonatomic, assign) id<QLBSLocationManagerDelegate> delegate;
/** 
 *	@brief 是否在定位过程
 */
@property (nonatomic, readonly) BOOL isUpdatingLocation;
/** 
 *	@brief 定位精度
 *	@note 默认为kCLLocationAccuracyHundredMeters，请勿将该值设置到很高精度，比如kCLLocationAccuracyBest，因为一般情况下面没法到达该精度的要求，会在超时时间过后返回一个精度最高的值
 */
@property (nonatomic) CLLocationAccuracy locateAccuracy;
/** 
 *	@brief 定位超时时间
 *	@note 默认为10s，假如在超时时间内，系统还未找到符合 locateAccuracy 精度的要求，将在该超时时间后返回一个精度最高的值(假如有的话)
 */
@property (nonatomic) NSTimeInterval locateTimeOut;
/** 
 *	@brief 开始定位，一直到超时或者找到符合精度要求的GPS或者定位失败都会会自动调用stopLocate
 */
- (BOOL)startLocate;
/** 
 *	@brief 带入选择性的定位
 *	@param[in] always 这个表示是否需要在一直定位下去，即使找到了合适的GPS或者超时已到，但是定位失败还是会停止
 *	@param[in] timeOut 这个表示是否需要回调超时，在整个定位过程，无论是否是一直定位，只有一次超时回调
 */
- (BOOL)startLocate:(BOOL)always timeOutOption:(BOOL)timeOut;
/** 
 *	@brief 取消定位
 */
- (void)stopLocate;
/** 
 *	@brief 是否能够定位，这个函数用于在定位前来判断定位服务是否开着
 *	@note iOS4.2以下系统，当总定位服务开着，但是App的定位服务关闭，该值还是返回YES，但是定位会有失败回调
 */
- (BOOL)isAppAbleLocate;
/** 
 *	@brief 设置定位提示语(>iOS3.2)
 */
- (BOOL)setPurposeString:(NSString *)str;
/**
 *  @brief 超时时间是否包括了系统询问提示框的时间，默认YES
 *  @note 这个参数假如为YES，那么超时时间将从用户点击了确认后，第一次系统的位置信息回调开始计算，排除了用户在提示框的等待时间
 */
@property (nonatomic) BOOL isIncAskTimeOut;
@end
