//
//  UMUFPCreditsWallViewController.h
//  UFP
//
//  Created by liuyu on 9/24/13.
//  Updated by liu yu on 1/20/14.
//  Copyright 2010-2014 Umeng.com. All rights reserved.
//  Version 4.7.1

#import <UIKit/UIKit.h>

@class CLLocation;
@protocol UMUFPCreditsWallDelegate;

@interface UMUFPCreditsWallViewController : UIViewController

@property (nonatomic, copy) NSString *mKeywords; //keywords for the promoters data, promoter list will return according to this property, default is @""
@property (nonatomic, copy) NSString *mTags;     //tags for the current user, default is @""
@property (nonatomic)           BOOL mAutoFill;  //shows whether automatic add other promoters when data of this position is not enough
@property (nonatomic, copy) NSString *mUserID;   //id for the current user, default is @""

@property (nonatomic, assign) id<UMUFPCreditsWallDelegate> delegate; //delegate for the view controller

/**
 
 This method create and return a UMUFPCreditsWallViewController object
 
 @param  appkey appkey get from www.umeng.com
 @param  slotId slotId get from ufp.umeng.com
 
 @return a UMUFPCreditsWallViewController object
 
 */

- (id)initWithAppkey:(NSString *)appkey slotId:(NSString *)slotId;

/**
 
 This method present the current credits wall
 
 @param  viewController view controller to present the created credits wall
 
 */

- (void)presentCreditsWallWithViewController:(UIViewController *)viewController;

/**
 
 This method check remained credit for the current user
 
 @param  userId user id
 @param  slotId slot id get from ufp.umeng.com
 @param  completionHandler actions to be executed after the request finished
 
 */

+ (void)checkRemainedCreditsForUser:(NSString *)userId withSlotId:(NSString *)slotId andCompletionHandler:(void (^)(NSDictionary *creditsDic, BOOL flag))completionHandler;

/**
 
 This method consume given amount of credit for the current user
 
 @param  credit amount of credit to be consumed
 @param  userId user id
 @param  slotId slot id get from ufp.umeng.com
 @param  completionHandler actions to be executed after the request finished
 
 */

+ (void)consumeCreditsInAmount:(NSInteger)credit forUser:(NSString *)userId withSlotId:(NSString *)slotId andCompletionHandler:(void (^)(NSDictionary *result, BOOL flag))completionHandler;

/**
 
 This method set current location
 
 @param  location current location
 
 */

+ (void)setLocation:(CLLocation *)location;

@end

/**
 
 UMUFPCreditsWallDelegate is a protocol for UMUFPCreditsWallViewController.
 Optional methods of the protocol allow the delegate to capture UMUFPCreditsWallViewController releated events, and perform other actions.
 
 */

@protocol UMUFPCreditsWallDelegate <NSObject>

@optional

- (void)creditsWallWillDisappear:(UMUFPCreditsWallViewController *)viewController; // called when the left navigation bar item clicked and the current view controller will be closed
- (void)didLoadDataFinished:(UMUFPCreditsWallViewController *)viewController; //call when promoter data load finished
- (void)didLoadDataFailWithError:(UMUFPCreditsWallViewController *)viewController error:(NSError *)error; //call when promoter data load failed
- (void)didClickedPromoterAtIndex:(UMUFPCreditsWallViewController *)viewController index:(NSInteger)promoterIndex promoterData:(NSDictionary *)promoterData; //called when promoter clicked

@end
