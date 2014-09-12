#import <UIKit/UIKit.h>

#define LOG_SILENT 0
#define LOG_DEBUG 1
#define LOG_URL_DEBUG 2
#define LOG_CLICK_DEBUG 3
#define LOG_ACTIVE_DEBUG 4
#define LOG_EXCEPTION 5
#define LOG_NONFATAL_ERROR 6
#define LOG_ALL 7

@interface WapsLog : NSObject {

}

+ (void)setLogThreshold:(int)myThreshhold;

+ (void)logWithLevel:(int)myLevel format:(NSString *)myFormat, ...;
@end
