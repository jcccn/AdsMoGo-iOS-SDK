//
//  UMUFPHeadlineView.h
//  UFP
//
//  Created by liu yu on 5/18/12.
//  Updated by liu yu on 1/20/14.
//  Copyright 2010-2014 Umeng.com. All rights reserved.
//  Version 4.7.1

#import <UIKit/UIKit.h>

@class CLLocation;
@class UMUFPHeadlineViewInternal;

@protocol UMHeadlineViewDelegate;

@interface UMUFPHeadlineView : UIView {
@private
    
    float    _mIntervalDuration;
    
    UIView   *_mLoadingWaitView;
    UMUFPHeadlineViewInternal *_mHeadlineViewInternal;
    
    id<UMHeadlineViewDelegate> _delegate;
}

@property (nonatomic) BOOL  mAutoFill;            //default is true
@property (nonatomic, copy) NSString *mKeywords;  //keywords for the promoters data, promoter list will return according to this property, default is @""
@property (nonatomic, copy) NSString *mTags;      //tags for the current user, default is @""
@property (nonatomic) float mIntervalDuration;    //duration for the promoter present time，default is 15s
@property (nonatomic, readonly) NSMutableArray *mPromoterDatas; //all the loaded promoters list for the releated appkey / slot_id
@property (nonatomic, assign) id<UMHeadlineViewDelegate> delegate; //delegate
@property (nonatomic, retain) UIView  *mLoadingWaitView; //view displayed when query promoter list from server, default is a picture named um_headview_placeholder.jgp

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
 
 This method called when promoter clicked [Used when you want to self define the headview according to the mPromoterDatas property, this case click report need to be send yourself]
 
 @param  promoter info of the clicked promoter
 @param  index index of the clicked promoter in the promoter array
 
 */

- (void)didClickPromoterAtIndex:(NSDictionary *)promoter index:(NSInteger)index;

/**
 
 This method send impression report for inputed promoters [Used when you want to self define the headview according to the mPromoterDatas property, this case express report need to be send yourself]
 
 @param promoters promoter list
 
 */

- (void)sendExpressReportForPromoters:(NSArray *)promoters;

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

@protocol UMHeadlineViewDelegate <NSObject>

@optional

- (void)UMHeadlineView:(UMUFPHeadlineView *)headView didLoadDataFinish:(NSInteger)promotersAmount; //called when promoter list loaded from the server
- (void)UMHeadlineView:(UMUFPHeadlineView *)headView didLoadDataFailWithError:(NSError *)error; //called when promoter list loaded failed for some reason, for example network problem or the promoter list is empty
- (void)UMHeadlineView:(UMUFPHeadlineView *)headView didClickPromoterForUrl:(NSURL *)url; //implement this method if you want to handle promoter click event for the case that should open an url in webview
- (void)UMHeadlineView:(UMUFPHeadlineView *)headView didClickedPromoterAtIndex:(NSInteger)index;   //called when headView clicked

@end