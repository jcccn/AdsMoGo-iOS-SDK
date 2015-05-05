//
//  AdMoGoLogCenter.h
//  AdsMogo
//
//  Created by Daxiong on 14-2-21.
//
//

#import <Foundation/Foundation.h>

#ifndef MGNLog
#define MGNLog(lv,fmt, ...) \
if([[AdMoGoNativeLogCenter shareInstance]canLog:lv]){\
    AdMoGoNativeLogLeve logleve = [[AdMoGoNativeLogCenter shareInstance]getLogLeveFlag];\
    if((logleve & AdMoGoNativeLogError)==AdMoGoNativeLogError && lv ==MGNE){\
        NSLog((@"ADSMOGO-Log Error: " fmt), ##__VA_ARGS__);\
    }\
    if((logleve & AdMoGoNativeLogDebug)==AdMoGoNativeLogDebug && lv == MGND){\
        NSLog((@"ADSMOGO-Log Debug" "<FUNCTION:%s>: " fmt),__FUNCTION__, ##__VA_ARGS__);\
    }\
    if((logleve & AdMoGoNativeLogTemp)==AdMoGoNativeLogTemp && lv == MGNT){\
        NSLog((@"ADSMOGO-Log Warning: " fmt), ##__VA_ARGS__);\
    }\
    if((logleve & AdMoGoNativeLogProduction)==AdMoGoNativeLogProduction && lv == MGNP){\
        NSLog((@"ADSMOGO-Log Info" "<FUNCTION:%s>: " fmt),__FUNCTION__, ##__VA_ARGS__);\
    }\
}

//        NSLog((@"ADSMOGO-" "<FUNCTION:%s>-" "<LINE:%d>: " fmt),__FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif


typedef enum {
    AdMoGoNativeLogProduction = 1<<0,
    AdMoGoNativeLogDebug      = 1<<1,
    AdMoGoNativeLogNone       = 1<<2,
    AdMoGoNativeLogTemp       = 1<<3,
    AdMoGoNativeLogError      = 1<<4
}AdMoGoNativeLogLeve;

typedef enum {
    MGNP      = 1<<0,
    MGND      = 1<<1,
    MGNN      = 1<<2,
    MGNT      = 1<<3,
    MGNE      = 1<<4
}AdMoGoNativeLogLeveSample;

@interface AdMoGoNativeLogCenter : NSObject

+ (AdMoGoNativeLogCenter *)shareInstance;
- (BOOL)canLog:(int)levelFlag;
- (void)setLogLeveFlag:(AdMoGoNativeLogLeve)levelFlag;
- (AdMoGoNativeLogLeve)getLogLeveFlag;
@end
