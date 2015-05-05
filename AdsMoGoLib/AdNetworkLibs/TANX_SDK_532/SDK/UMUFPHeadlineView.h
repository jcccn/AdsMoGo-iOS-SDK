//
//  UMUFPHeadlineView.h
//  UFP
//
//  Created by liu yu on 5/18/12.
//  Updated by liu yu on 12/30/14.
//  Copyright 2007-2015 Alimama.com. All rights reserved.
//  Version 5.3.2
//
//  Support Email: mobilesupport@list.alibaba-inc.com

#import <UIKit/UIKit.h>

@class CLLocation;

@protocol UMHeadlineViewDelegate;

@interface UMUFPHeadlineView : UIView

@property (nonatomic) BOOL  mAutoFill;            //default is true
@property (nonatomic, copy) NSString *mKeywords;  //keywords for the promoters data, promoter list will return according to this property, default is @""
@property (nonatomic, copy) NSString *mTags;      //tags for the current user, default is @""
@property (nonatomic) float mIntervalDuration;    //duration for the promoter present time，default is 15s
@property (nonatomic, assign) id<UMHeadlineViewDelegate> delegate; //delegate
@property (nonatomic, retain) UIView  *mLoadingWaitView; //view displayed when query promoter list from server, default is a picture named headview_placeholder.jpg

/**
 
 This method return a UMUFPHeadlineView object
 
 @param  frame frame for the headView view
 @param  appkey appkey get from www.umeng.com
 @param  slotId slotId get from ufp.umeng.com
 @param  controller view controller releated to the view that the headView view added into
 
 @return a UMUFPHeadlineView object
 */

- (id)initWithFrame:(CGRect)frame appKey:(NSString *)appkey slotId:(NSString *)slotId currentViewController:(UIViewController *)controller;

/**
 
 This method start the promoter data load in background, promoter data will be load until this method called
 
 */

- (void)requestPromoterDataInBackground;

/**
 
 This method reset the default auto switching between promoters
 
 */

- (void)reScheduleAutoSwitching;

/**
 
 This method set channel for this app, the default channel is App Store, call this method if you want to set channel for another value, don't need to call this method among different views, only once is enough
 
 @param  channel channel name for the app
 
 */

+ (void)setAppChannel:(NSString *)channel;

/**
 
 This method set current location
 
 @param  location current location
 
 */

+ (void)setLocation:(CLLocation *)location;

@end

/**
 
 This category provides data api
 
 */

@interface UMUFPHeadlineView (API)

/**
 
 This method shows whether promoters ready to shown
 
 @return bool value
 */

- (BOOL)readyToShown;

/**
 
 This method return promoter list that ready for showing
 
 @return promoters list
 */

- (NSArray *)promoters;

/**
 
 This method send impression report for inputed promoters [Used when you want to self define the headview according to the mPromoterDatas property, this case express report need to be send yourself]
 
 @param promoters promoter list
 
 */

- (void)sendExpressReportForPromoters:(NSArray *)promoters;

/**
 
 This method called when promoter clicked [Used when you want to self define the headview according to the mPromoterDatas property, this case click report need to be send yourself]
 
 @param  promoter info of the clicked promoter
 @param  index index of the clicked promoter in the promoter array
 
 */

- (void)didClickPromoterAtIndex:(NSDictionary *)promoter index:(NSInteger)index;

@end

@protocol UMHeadlineViewDelegate <NSObject>

@optional

- (void)UMHeadlineView:(UMUFPHeadlineView *)headView didLoadDataFinish:(NSInteger)promotersAmount; //called when promoter list loaded from the server
- (void)UMHeadlineView:(UMUFPHeadlineView *)headView didLoadDataFailWithError:(NSError *)error; //called when promoter list loaded failed for some reason, for example network problem or the promoter list is empty
- (void)UMHeadlineView:(UMUFPHeadlineView *)headView didClickedPromoterAtIndex:(NSInteger)index;   //called when headView clicked

@end