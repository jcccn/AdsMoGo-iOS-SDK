//
//  UMUFPTableView.h
//  UFP
//
//  Created by liu yu on 12/17/11.
//  Updated by liu yu on 12/30/14.
//  Copyright 2007-2015 Alimama.com. All rights reserved.
//  Version 5.3.2
//
//  Support Email: mobilesupport@list.alibaba-inc.com

#import <UIKit/UIKit.h>

@class CLLocation;
@protocol UMUFPTableViewDataLoadDelegate;

/**
 
 UMUFPTableView is a class that provide and manage promoter datas, making all the releated custom possible.
 
 */

@interface UMUFPTableView : UITableView

@property (nonatomic, copy) NSString *mKeywords;        //keywords for the promoters data, promoter list will return according to this property, default is @""
@property (nonatomic, copy) NSString *mTags;            //tags for the current user, default is @""
@property (nonatomic)           BOOL mAutoFill;         //shows whether automatic add other promoters when data of this position is not enough
@property (nonatomic, readonly) BOOL mIsAllLoaded;      //shows whether there are promoters list left to load
@property (nonatomic, readonly) BOOL mIsLoading;        //shows whether exists unfinished promoters request in background
@property (nonatomic, readonly) NSMutableArray *mPromoterDatas; //all the loaded promoters list for the releated appkey / slot_id
@property (nonatomic) NSInteger mRequestCount;          //number of promoters for every load more request, default is 10
@property (nonatomic, assign)   id<UMUFPTableViewDataLoadDelegate> dataLoadDelegate; //dataLoadDelegate for tableview
@property (nonatomic, readonly) NSInteger mNewPromoterCount;    //number of new promoters, default is -1(no new promoter)

@property (nonatomic) BOOL mShouldSendImpressionReportAutomaticly; // Default is YES, shows whether automatic send impression report after promoter list loaded

/** 
 
 This method start the promoter data load in background, promoter data will be load until this method called
 
 */

- (void)requestPromoterDataInBackground;

/** 
 
 This method request more promoter data in background, should called after requestPromoterDataInBackground, as some initialization should be done in requestPromoterDataInBackground
 
 */

- (void)requestMorePromoterInBackground;

/** 
 
 This method return a UMUFPTableView object
 
 @param  frame frame for the tableView 
 @param  style tableview style, UITableViewStylePlain or UITableViewStyleGrouped 
 @param  appkey appkey get from www.umeng.com, if you want use ufp service only, set this parameter empty
 @param  slotId slotId get from ufp.umeng.com
 @param  controller view controller releated to the view that the table view added into

 @return a UMUFPTableView object
 
 */

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style appkey:(NSString *)appkey slotId:(NSString *)slotId currentViewController:(UIViewController *)controller;

/**
 
 This method send impression report for inputed promoters, call this method only when mShouldSendImpressionReportAutomaticly is NO
 
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
 
 自定义的入口被展现
 
 @param  slotId 自定义的入口所关联的广告位ID，即入口点击后，所展示的广告区域对应的广告位ID

 */

+ (void)customEntranceShown:(NSString *)slotId;

/**
 
 自定义的入口被点击
 
 @param  slotId 自定义的入口所关联的广告位ID，即入口点击后，所展示的广告区域对应的广告位ID
 
 */

+ (void)customEntranceClicked:(NSString *)slotId;

/**
 
 This method check whether the app releated the promoter info installed
 
 @param  promoterInfo promoter info of the app to be checked

 @return a bool value, YES is installed, else NO
 */

+ (BOOL)isAppInstalled:(NSDictionary *)promoterInfo;

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
 
 UMUFPTableViewDataLoadDelegate is a protocol for UMUFPTableView.
 Optional methods of the protocol allow the delegate to capture UMUFPTableView releated events, and perform other actions.
 
 */

@protocol UMUFPTableViewDataLoadDelegate <NSObject>

@optional

- (void)UMUFPTableViewDidLoadDataFinish:(UMUFPTableView *)tableview promoters:(NSArray *)promoters; //called when promoter list loaded
- (void)UMUFPTableView:(UMUFPTableView *)tableview didLoadDataFailWithError:(NSError *)error; //called when promoter list loaded failed for some reason
- (void)UMUFPTableView:(UMUFPTableView *)tableview didClickedPromoterAtIndex:(NSInteger)promoterIndex; //called when table cell clicked, current action is go to app store

- (void)UMUFPTableView:(UMUFPTableView *)tableview didStartToLoadDetailPageAtIndex:(NSInteger)promoterIndex; //For StoreKit, start to load storekit
- (void)UMUFPTableView:(UMUFPTableView *)tableview didReadyToShowDetailPageAtIndex:(NSInteger)promoterIndex; //For StoreKit, load storekit finished

@end

