//
//  UMUFPBadgeView.h
//  UFP
//
//  Created by liu yu on 04/02/13.
//  Updated by liu yu on 09/03/14.
//  Copyright 2007-2014 Alimama.com. All rights reserved.
//  Version 5.2.0
//
//  Support Email: mobilesupport@list.alibaba-inc.com

#import <UIKit/UIKit.h>

@class UMUFPImageView;

/**
 
 UMUFPBadgeView is a class for new promoter notice.
 
 */

@interface UMUFPBadgeView : UIView

@property (nonatomic) BOOL shouldShowBadgeNumberLabel; // Default is YES
@property (nonatomic, retain) UILabel *badgeNumberLabel; // Badge number label
@property (nonatomic, retain) UMUFPImageView *badgeBackgroundView; // Background view for the badge

/**
 
 This method update number of unread messages
 
 @param unreadCount number of unread messages, possible values: -1(no unread emssage), 0(many unread message), a positive integer
 
 */

- (void)updateNewMessageCount:(NSInteger)unreadCount;

@end