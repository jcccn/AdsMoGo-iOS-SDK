/*!
 @header SMAdEventCode.h
 @abstract SMAdEventCode
 @author madhouse
 @version 3.0.5 2013/12/11 Creation
 */

#import <Foundation/Foundation.h>


/*!
 @enum
 @abstract SmartMadCode
 @constant SUCCEED 成功
 @constant INVALID_ID 无效的id
 @constant AD_TOO_MUCH_ON_SCREEN 太多相同的广告位在屏幕上
 @constant INVALID_AREA_OR_BE_COVERD 无效的广告尺寸或广告被覆盖
 @constant NETWORK_ERROR 网络错误
 @constant INVALID_REQUEST 无效请求
 @constant NO_FILL 无广告
 @constant INTERNAL_ERROR 内部错误
 */

typedef enum {
    SUCCEED = 0,
    INVALID_ID = 1,
    AD_TOO_MUCH_ON_SCREEN = 2,
    INVALID_AREA_OR_BE_COVERD = 4,
    NETWORK_ERROR = 6,
    INVALID_REQUEST = 7,
    NO_FILL = 8,
    INTERNAL_ERROR = 9,
}SmartMadCode;


/*!
 @class
 @abstract SMAdEventCode
 */

@interface SMAdEventCode : NSError

@end
