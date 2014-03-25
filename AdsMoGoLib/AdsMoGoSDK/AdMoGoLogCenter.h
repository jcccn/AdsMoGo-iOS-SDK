//
//  AdMoGoLogCenter.h
//  AdsMogo
//
//  Created by Daxiong on 14-2-21.
//
//

#import <Foundation/Foundation.h>

#ifndef MGLog
#define MGLog(lv,fmt, ...) \
if([[AdMoGoLogCenter shareInstance]canLog:lv]){\
    if([[AdMoGoLogCenter shareInstance]getLogLeveFlag] == AdMoGoLogDebug){\
        NSLog((@"ADSMOGO-Log: " fmt), ##__VA_ARGS__);\
    }else{\
        NSLog((@"ADSMOGO-" "<FUNCTION:%s>: " fmt),__FUNCTION__, ##__VA_ARGS__);\
    }\
}

//        NSLog((@"ADSMOGO-" "<FUNCTION:%s>-" "<LINE:%d>: " fmt),__FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

typedef enum {
    AdMoGoLogProduction = 1<<0,
    AdMoGoLogDebug      = 1<<1,
    AdMoGoLogNone       = 1<<2,
    AdMoGoLogTemp       = 1<<3
}AdMoGoLogLeve;

typedef enum {
    MGP      = 1<<0,
    MGD      = 1<<1,
    MGN      = 1<<2,
    MGT      = 1<<3
}AdMoGoLogLeveSample;

@interface AdMoGoLogCenter : NSObject

+ (AdMoGoLogCenter *)shareInstance;
- (BOOL)canLog:(int)levelFlag;
- (void)setLogLeveFlag:(AdMoGoLogLeve)levelFlag;
- (AdMoGoLogLeve)getLogLeveFlag;
@end
