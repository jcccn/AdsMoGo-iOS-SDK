//
//  UMUFPDialog.h
//  UFP
//
//  Created by liu yu on 4/23/12.
//  Updated by liu yu on 1/20/14.
//  Copyright 2010-2014 Umeng.com. All rights reserved.
//  Version 4.7.1

#import <UIKit/UIKit.h>

@class CLLocation;

typedef enum {
    UMUFPDialogPageTypeWap = 0, // webview style
    UMUFPDialogPageTypeApp = 1, // native style
    UMUFPDialogPageTypeDefault = UMUFPDialogPageTypeWap,
} UMUFPDialogPageType;

@protocol UMUFPDialogDelegate;

@interface UMUFPDialog : UIView {
@private
    id<UMUFPDialogDelegate> _delegate;
}

@property (nonatomic) UMUFPDialogPageType pageType;             // Content style: wap or native
@property (nonatomic, assign) id<UMUFPDialogDelegate> delegate; // delegate
@property (nonatomic) BOOL shouldShowAfterDataLoaded;           // Default is YES
@property (nonatomic) BOOL shouldShowDefaultCloseBtn;           // Default is YES
@property (nonatomic, readonly) BOOL dialogReadyToShown;        // Whether the dialog is ready to shown, dialog becomes ready to shown when all the releated resource loaded
@property (nonatomic) CGFloat   contentMargin;                 // Margin of content to the edge of dialog
@property (nonatomic, readonly) NSDictionary *mPromoterInfo;   //promoter info for the releated appkey / slot_id

/**
 
 This method return a UMUFPDialog object
 
 @param  appkey appkey get from www.umeng.com
 @param  slotId slotId get from www.ufp.umeng.com
 @param  controller current view controller
 
 @return a UMUFPDialog object
 */

- (id)initWithAppkey:(NSString *)appkey slotId:(NSString *)slotId currentViewController:(UIViewController *)controller;

/**
 
 This method help to do auto frame adjust according to the releated promoter settings
 
 */

- (void)autoAdjustViewFrameForOritationChange;

/**
 
 Start releated data loading, dialog will show after all the releated data loaded and shouldShowAfterDataLoaded is Opened
 
 */

- (void)showAlertView;

/**
 
 Hide alertview if alert is shown [Used when you want to self define the close button]
 
 */

- (void)hideAlertView;

/**
 
 This method used to send express report for the promoter to be shown [Used when you want to self define the dialog according to the mPromoterInfo property, this case express report need to be send yourself]
 
 */

- (void)sendExpressReport;

/**
 
 This method called when promoter click event happend, handle log report and jump [Used when you want to self define the dialog according to the mPromoterInfo property, this case click report need to be send yourself]
 
 */

- (void)didClickedPromoter;

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

@protocol UMUFPDialogDelegate <NSObject>

@optional

- (void)dialog:(UMUFPDialog *)dialog didLoadDataFinish:(NSDictionary *)promoterInfo; //called when promoter list loaded from the server
- (void)dialog:(UMUFPDialog *)dialog didLoadDataFailWithError:(NSError *)error; //called when promoter list loaded failed for some reason, for example network problem or the promoter list is empty

- (void)dialogReadyToShow:(UMUFPDialog *)dialog;   //called when shouldShowAfterDataLoaded is Closed and dialog is ready to shown
- (void)dialogWillShow:(UMUFPDialog *)dialog;      //called when will appear the 1st time, implement this mothod if you want to change animation for the dialog appear or do something else before dialog appear
- (void)dialogWillDisappear:(UMUFPDialog *)dialog; //called before dialog will disappear

- (void)didClickDialog:(UMUFPDialog *)dialog; // called when dialog is clicked
- (void)dialog:(UMUFPDialog *)dialog openAdsForFlag:(NSString *)flagStr;

@end