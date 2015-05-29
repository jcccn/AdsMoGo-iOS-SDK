//
//  JWMobSingleton.h
//  wanghaotest
//
//  Created by MOGO on 15-4-24.
//
//

#import <Foundation/Foundation.h>
@protocol JWMobSingletonDelegate <NSObject>
- (void)requestAdSuccess;
- (void)requestAdFail;
- (void)loadAdSuccess;
- (void)loadAdFail;
- (void)adClose;
@end
@interface JWMobSingleton : NSObject
@property (assign) id<JWMobSingletonDelegate> delegate;
+ (id)shareInstance;
- (void)setJWinitByID:(NSString *)idstr;
- (void)loadAd;
- (void)showAd;
@end
