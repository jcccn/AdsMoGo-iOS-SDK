//
//  YJFCustomScore.h
//  YJFSDK2.0
//
//  Created by emaryjf on 14-5-30.
//  Copyright (c) 2014年 emaryjf. All rights reserved.
//

#import <Foundation/Foundation.h>
@protocol HMCustomScoreDelegate <NSObject>
@optional
- (void) getDataSuccess;
- (void) getDataFailed;
@end

@interface HMCustomScore : NSObject<NSURLConnectionDelegate,HMCustomScoreDelegate>
{
    id<HMCustomScoreDelegate> delegate;
}
+ (HMCustomScore *)shareInstance;
+ (void)destroyInstance;
-(void) getScoreData:(int)pageSize : (int)pageNumber;
-(void) clickToAppStore:(NSString *)adId : (int)adType : (NSString *)adUrl : (NSString *)appUrl;
@property(assign) id<HMCustomScoreDelegate> delegate;
@property (retain) NSMutableData *receiveData;
@property (nonatomic, retain) NSMutableArray* array;
@property int pageCount;
@property (nonatomic,copy) NSString *jsonStr;
@end
