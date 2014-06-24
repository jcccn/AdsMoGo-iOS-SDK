//
//  UMUFPHandleView.h
//  UFP
//
//  Created by liu yu on 2/16/12.
//  Updated by liu yu on 1/20/14.
//  Copyright 2010-2014 Umeng.com. All rights reserved.
//  Version 4.7.1

#import <UIKit/UIKit.h>

@class CLLocation;
@class UMUFPBadgeView;

@protocol UMUFPHandleViewDelegate;

/**
 
 UMUFPHandleView is a subclass of UIView and enables self-defined interface for Ads.
 
 */

@interface UMUFPHandleView : UIView {
@private
    id<UMUFPHandleViewDelegate> _delegate;
}

@property (nonatomic) BOOL  mAutoFill; //shows whether automatic add other promoters when data of this position is not enough
@property (nonatomic, copy) NSString *mKeywords; //keywords for the promoters data, promoter list will return according to this property, default is @""
@property (nonatomic, copy) NSString *mTags;    //tags for the current user, default is @""
@property (nonatomic, assign) id<UMUFPHandleViewDelegate> delegate; //delegate for banner view

@property (nonatomic, retain)   UMUFPBadgeView *mBadgeView;     //badge view for new promoter notice
@property (nonatomic, readonly) NSInteger mNewPromoterCount;    //number of new promoters, default is -1(no new promoter)
@property (nonatomic) BOOL      mNewPromoterNoticeEnabled;      // whether show badge view for the number of new promoters, default is YES
@property (nonatomic, readonly) NSMutableArray *mPromoterDatas; //all the loaded promoters list for the releated appkey / slot_id

@property (nonatomic, readonly) UILabel *mEntranceTitleLabel; //entrance title label for the handleview, default text is @""

/** 
 
 This method create and return a UMUFPHandleView object
 
 @param  frame frame for the UMUFPHandleView 
 @param  appkey appkey get from www.umeng.com
 @param  slotId slotId get from ufp.umeng.com
 @param  controller view controller releated to the view that the handle view added into
 
 @return a UMUFPHandleView object
 
*/

- (id)initWithFrame:(CGRect)frame appKey:(NSString *)appkey slotId:(NSString *)slotId currentViewController:(UIViewController *)controller;

/** 
 
 This method start the promoter data load in background, promoter data will be load until this method called
 
 */

- (void)requestPromoterDataInBackground;

/** 
 
 This method set a local background image for handle view, if not called, handle view load image set on the server
 
 @param  image image for the background of handle
 
 */

- (void)setHandleViewBackgroundImage:(UIImage *)image;

/**
 
 This method show detail content view controller for the handle view【Call this method only if you need to completely self define the entrance】
 
 */

- (void)showHandleViewDetailPage;

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
 
 UMUFPHandleViewDelegate is a protocol for UMUFPHandleView.
 Optional methods of the protocol allow the delegate to capture UMUFPHandleView releated events, and perform other actions.
 
 */

@protocol UMUFPHandleViewDelegate <NSObject>

@optional

- (void)didLoadDataFinished:(UMUFPHandleView *)handleView; // called when promoter data of handleview load finished
- (void)didLoadDataFailWithError:(UMUFPHandleView *)handleView error:(NSError *)error; //call when promoter data load failed, default action is handleview will not shown

- (void)handleViewWillAppear:(UMUFPHandleView *)handleView; //called when handle will appear, implement this mothod if you want to change animation for the handle appear or do something else before handle appear
- (void)failedToOpenContentView:(UMUFPHandleView *)handleView; // called when showHandleViewDetailPage method called, but releated resource is not ready currently, content view failed to be opened

- (void)didClickHandleView:(UMUFPHandleView *)handleView; // called when handleview is clicked and releated content will be shown
- (void)handleViewDidPackUp:(UMUFPHandleView *)handleView; // called when content view will be packed up

- (void)didClickedPromoterAtIndex:(UMUFPHandleView *)handleView index:(NSInteger)promoterIndex promoterData:(NSDictionary *)promoterData; //called when table cell clicked

@end
