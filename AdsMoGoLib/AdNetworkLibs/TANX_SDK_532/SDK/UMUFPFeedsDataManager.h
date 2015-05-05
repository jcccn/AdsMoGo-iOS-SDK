//
//  UMUFPFeedsDataManager.h
//  UFP
//
//  Created by liuyu on 9/11/13.
//  Updated by liu yu on 12/30/14.
//  Copyright 2007-2015 Alimama.com. All rights reserved.
//  Version 5.3.2
//
//  Support Email: mobilesupport@list.alibaba-inc.com

#import <Foundation/Foundation.h>

@class CLLocation;

typedef enum {
    UMUFPDisplayTypeBigImage = 0,
    UMUFPDisplayTypeIcons = 1,
    UMUFPDisplayTypeSmallImage = 2,
    UMUFPDisplayTypeDefault = UMUFPDisplayTypeBigImage,
    UMUFPDisplayTypeUnknow = 3,
} UMUFPDisplayType;

typedef enum {
    UMUFPFeedsDataTypeApp = 0,
    UMUFPFeedsDataTypeTbItem = 1,
    UMUFPFeedsDataTypeUnknow = 3,
} UMUFPFeedsDataType;

@class MMUFeedsDataObject;
@protocol UMUFPFeedsDataManagerDelegate;

@interface UMUFPFeedsDataManager : NSObject

@property (nonatomic, copy) NSString *mContext;         //context for the promoters data, default is @""
@property (nonatomic, copy) NSString *mKeywords;        //keywords for the promoters data, promoter list will return according to this property, default is @""
@property (nonatomic, copy) NSString *mTags;            //tags for the current user, default is @""
@property (nonatomic)           BOOL mAutoFill;         //shows whether automatic add other promoters when data of this position is not enough
@property (nonatomic) BOOL mHorizontalScrollEnabled;    //shows whether allow horizontal scroll to switch promoter, default is YES

@property (nonatomic, readonly) BOOL mReadyToShown;      //shows whether data ready to show
@property (nonatomic, copy) NSString *mSlotID;
@property (nonatomic) UIEdgeInsets mContentInsetForPromoterCell; //default UIEdgeInsetsZero, additional area around content

@property (nonatomic, assign)   id<UMUFPFeedsDataManagerDelegate> delegate; //delegate for datamanager

/**
 
 This method return a UMUFPPromoterDatasManager object
 
 @param  appkey please set this parameter empty
 @param  slotId unique id for the releated promotion
 @param  controller view controller releated to the view that the promoter to be shown
 
 @return a UMUFPPromoterDatasManager object
 
 */

- (id)initWithAppkey:(NSString *)appkey slotId:(NSString *)slotId currentViewController:(UIViewController *)controller;

/**
 
 This method start the promoter data load in background, promoter data will be load until this method called
 
 */

- (void)requestPromoterDataInBackground;

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

@interface UMUFPFeedsDataManager (API)

/**
 
 This method return promoter list for current slot id
 
 @return promoter list
 
 */

- (MMUFeedsDataObject *)promotersInfo;

/**
 
 This method called when promoter clicked
 
 @param  promoter info of the clicked promoter
 @param  index index of the clicked promoter in the promoter array
 @param  dataObject
 
 */

- (void)sendImpressionReportForPromoters:(NSArray *)promoters fromDataObject:(MMUFeedsDataObject *)dataObject;

/**
 
 This method called when promoter clicked
 
 @param  promoter info of the clicked promoter
 @param  index index of the clicked promoter in the promoter array
 @param  dataObject
 
 */

- (void)didClickPromoterAtIndex:(NSDictionary *)promoter index:(NSInteger)index fromDataObject:(MMUFeedsDataObject *)dataObject;

@end

@protocol UMUFPFeedsDataManagerDelegate <NSObject>

@optional

- (void)UMUFPFeedsDataManager:(UMUFPFeedsDataManager *)dataManager didLoadDataFinished:(MMUFeedsDataObject *)promotersInfo; //called when promoter list loaded
- (void)UMUFPFeedsDataManager:(UMUFPFeedsDataManager *)dataManager didLoadDataFailWithError:(NSError *)error; //called when promoter list loaded failed for some reason
- (void)UMUFPFeedsDataManager:(UMUFPFeedsDataManager *)dataManager didClickedPromoterAtIndex:(NSInteger)promoterIndex; //called when table cell clicked, current action is go to app store

@end

#import "MMUPromotersDataObject.h"

@interface MMUFeedsDataObject : MMUPromotersDataObject <NSCopying>

- (NSInteger)displayType;
- (NSInteger)feedsDataType;

@end
