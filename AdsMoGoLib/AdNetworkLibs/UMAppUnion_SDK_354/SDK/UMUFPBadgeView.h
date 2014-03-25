//
//  UMUFPBadgeView.h
//  UFP
//
//  Created by liu yu on 04/02/13.
//  Updated by liu yu on 04/02/13.
//  Copyright 2010-2013 Umeng.com. All rights reserved.
//  Version 3.5.4

#import <UIKit/UIKit.h>

@interface UMUFPBadgeView : UIView
{
    UILabel *badgeNumberLabel;
}

@property (nonatomic) BOOL shouldShowBadgeNumberLabel; // Default is YES
@property (nonatomic, retain) UIImageView *badgeBackgroundView; // Background view for the badge

- (void)updateNewMessageCount:(NSInteger)unreadCount;

@end
