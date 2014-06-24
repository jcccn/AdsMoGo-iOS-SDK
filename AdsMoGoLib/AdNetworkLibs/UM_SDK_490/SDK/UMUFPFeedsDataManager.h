//
//  UMUFPFeedsDataManager.h
//  UFP
//
//  Created by liuyu on 9/11/13.
//  Updated by liu yu on 1/20/14.
//  Copyright 2010-2014 Umeng.com. All rights reserved.
//  Version 4.7.1

#import <Foundation/Foundation.h>

@class CLLocation;

typedef enum {
    UMUFPDisplayTypeBigImage = 0,
    UMUFPDisplayTypeIcon = 1,
    UMUFPDisplayTypeDefault = UMUFPDisplayTypeBigImage,
    UMUFPDisplayTypeUnknow = 2,
} UMUFPDisplayType;

typedef enum {
    UMUFPFeedsDataTypeApp = 0,
    UMUFPFeedsDataTypeTbItem = 1,
    UMUFPFeedsDataTypeTuan = 2,
    UMUFPFeedsDataTypeUnknow = 3,
} UMUFPFeedsDataType;

@protocol UMUFPFeedsDataManagerDelegate;

@interface UMUFPFeedsDataManager : NSObject

@property (nonatomic, copy) NSString *mContext;         //context for the promoters data, default is @""
@property (nonatomic, copy) NSString *mKeywords;        //keywords for the promoters data, promoter list will return according to this property, default is @""
@property (nonatomic, copy) NSString *mTags;            //tags for the current user, default is @""
@property (nonatomic)           BOOL mAutoFill;         //shows whether automatic add other promoters when data of this position is not enough
@property (nonatomic, readonly) BOOL mIsLoading;        //shows whether exists unfinished promoters request in background
@property (nonatomic, readonly) NSMutableArray *mPromoterDatas; //all the loaded promoters list for the releated appkey / slot_id

@property (nonatomic) BOOL mHorizontalScrollEnabled;    //shows whether allow horizontal scroll to switch promoter, default is YES

@property (nonatomic, readonly) UMUFPDisplayType mDisplayType; //display type
@property (nonatomic, readonly) UMUFPFeedsDataType mFeedsDataType; //data type
@property (nonatomic, readonly) BOOL mReadyToShown; //

@property (nonatomic, assign)   id<UMUFPFeedsDataManagerDelegate> delegate; //delegate for datamanager

/**
 
 This method start the promoter data load in background, promoter data will be load until this method called
 
 */

- (void)requestPromoterDataInBackground;

/**
 
 This method return a UMUFPPromoterDatasManager object
 
 @param  appkey appkey get from www.umeng.com, if you want use ufp service only, set this parameter empty
 @param  slotId slotId get from ufp.umeng.com
 @param  controller view controller releated to the view that the promoter to be shown
 
 @return a UMUFPPromoterDatasManager object
 
 */

- (id)initWithAppkey:(NSString *)appkey slotId:(NSString *)slotId currentViewController:(UIViewController *)controller;

/**
 
 This method send impression report for inputed promoters, call this method only when you need to self-define the promoter cell completely
 
 @param promoters promoter list
 
 */

- (void)sendImpressionReportForPromoters:(NSArray *)promoters;

/**
 
 This method called when promoter clicked
 
 @param  promoter info of the clicked promoter
 @param  index index of the clicked promoter in the promoter array
 
 */

- (void)didClickPromoterAtIndex:(NSDictionary *)promoter index:(NSInteger)index;

/**
 
 This method return recommend height for promoter cell
 
 @return height
 
 */

- (CGFloat)recommendHeightForPromoterCell;

/**
 
 This method return a promoter cell according to the loaded promoters info
 
 @param  tableView tableView to show promoter cell
 @param  indexPath indexPath of the cell to show promoter
 
 */

- (UITableViewCell *)tableView:(UITableView *)tableView promoterCellForRowAtIndexPath:(NSIndexPath *)indexPath;

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

@protocol UMUFPFeedsDataManagerDelegate <NSObject>

@optional

- (void)UMUFPFeedsDataManager:(UMUFPFeedsDataManager *)dataManager didLoadDataFinished:(NSArray *)promoters; //called when promoter list loaded
- (void)UMUFPFeedsDataManager:(UMUFPFeedsDataManager *)dataManager didLoadDataFailWithError:(NSError *)error; //called when promoter list loaded failed for some reason
- (void)UMUFPFeedsDataManager:(UMUFPFeedsDataManager *)dataManager didClickedPromoterAtIndex:(NSInteger)promoterIndex; //called when table cell clicked, current action is go to app store
- (UIView *)UMUFPFeedsDataManager:(UMUFPFeedsDataManager *)dataManager contentViewForPromoter:(NSDictionary *)promoter; //self-defined content view for promoter

@end

