//
//  UMUFPWebView.h
//  UFP
//
//  Created by liu yu on 1/9/12.
//  Updated by liu yu on 1/20/14.
//  Copyright 2010-2014 Umeng.com. All rights reserved.
//  Version 4.7.1

#import <UIKit/UIKit.h>

@class CLLocation;

/**
 
 UMUFPWebView is a subclass of UIWebView that supports Ads impression in webview.
 
 */

@interface UMUFPWebView : UIWebView {
@private
    NSString *_mAppkey;
    NSString *_mSlotId;     
    NSString *_mKeywords;
    
    BOOL _mAutoFill;
}

@property (nonatomic) BOOL  mAutoFill; //shows whether automatic add other promoters when data of this position is not enough
@property (nonatomic, copy) NSString *mKeywords; //keywords for the promoters data, promoter list will return according to this property, default is @""
@property (nonatomic, copy) NSString *mTags;     //tags for the current user, default is @""

/** 
 
 This method return a UMUFPWebView object
 
 @param  frame frame for the UMUFPWebView 
 @param  appkey appkey get from www.umeng.com, if you want use ufp service only, set this parameter empty
 @param  slotId slotId get from ufp.umeng.com
 
 @return a UMUFPWebView object
 */

- (id)initWithFrame:(CGRect)frame appKey:(NSString *)appkey slotId:(NSString *)slotId;

/** 
 
 This method start the releated url request load
 
 */

- (void)startLoadRequest;

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

