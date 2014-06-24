//
//  UMUFPTextLinkView.h
//  UFP
//
//  Created by liu yu on 2/20/12.
//  Updated by liu yu on 1/20/14.
//  Copyright 2010-2014 Umeng.com. All rights reserved.
//  Version 4.7.1

#import <UIKit/UIKit.h>

@class CLLocation;
@class UMUFPTextLinkInternal;

@protocol UMUFPTextLinkViewDelegate;

@interface UMUFPTextLinkView : UIView {
@private
    float _mIntervalDuration; 

    id<UMUFPTextLinkViewDelegate> _delegate;    
    UMUFPTextLinkInternal *_mTextLinkInternal;
}

@property (nonatomic, copy)   NSString *mKeywords; //keywords for the promoters data, promoter list will return according to this property, default is @""
@property (nonatomic, copy)   NSString *mTags;     //tags for the current user, default is @""
@property (nonatomic, retain) UIColor *mBackgroundColor;   //background color for label
@property (nonatomic, assign) id<UMUFPTextLinkViewDelegate> delegate; 
@property (nonatomic) float   mIntervalDuration;           //duration for the promoter present time，default is 15s 
@property (nonatomic, retain) UIFont *mTitleLabelFont;     //default is systemFont 14.0
@property (nonatomic) CGRect  mTitleLabelFrame;            //frame for title label

/** 
 
 This method create and return a UMUFPTextLinkView object
 
 @param  frame frame for the UMUFPTextLinkView 
 @param  appkey appkey get from www.umeng.com, if you want use ufp service only, set this parameter empty
 @param  slotId slotId get from ufp.umeng.com
 @param  controller view controller releated to the view that the textlink view added into
 
 @return a UMUFPTextLinkView object
 
 */

- (id)initWithFrame:(CGRect)frame appKey:(NSString *)appkey slotId:(NSString *)slotId currentViewController:(UIViewController *)controller;

/** 
 
 This method start the promoter data load in background, promoter data will be load until this method called
 
 */

- (void)requestPromoterDataInBackground;

/**
 
 This method help to do frame adjust according to current oritation
 
 */

- (void)autoAdjustViewFrameForOritationChange;

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

@protocol UMUFPTextLinkViewDelegate <NSObject>

@optional

- (void)UMUFPTextLinkView:(UMUFPTextLinkView *)textLinkView didLoadDataFinish:(NSInteger)promotersAmount; 
- (void)UMUFPTextLinkView:(UMUFPTextLinkView *)textLinkView didLoadDataFailWithError:(NSError *)error; 
- (void)UMUFPTextLinkView:(UMUFPTextLinkView *)textLinkView didClickPromoterForUrl:(NSURL *)url; 
- (void)UMUFPTextLinkView:(UMUFPTextLinkView *)textLinkView didClickedPromoterAtIndex:(NSInteger)index;   

@end
