//
//  EGORefreshTableHeaderView.h
//  Demo
//
//  Created by Devin Doty on 10/14/09October14.
//  Copyright 2009 enormego. All rights reserved.
//



#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum{
	YYPullRefreshPulling = 0,
	YYPullRefreshNormal,
	YYPullRefreshLoading,	
} YYPullRefreshState;

@protocol YYRefreshTableHeaderDelegate;
@interface YYPullUpRefreshView : UIView {
	
	id _delegate;
	YYPullRefreshState _state;

	UILabel *_lastUpdatedLabel;
	UILabel *_statusLabel;
	CALayer *_arrowImage;
	UIActivityIndicatorView *_activityView;
	

}

@property(nonatomic,assign) id <YYRefreshTableHeaderDelegate> delegate;

- (void)refreshLastUpdatedDate;
- (void)egoRefreshScrollViewDidScroll:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDidEndDragging:(UIScrollView *)scrollView;
- (void)egoRefreshScrollViewDataSourceDidFinishedLoading:(UIScrollView *)scrollView;

@end
@protocol YYRefreshTableHeaderDelegate
- (void)egoRefreshTableHeaderDidTriggerRefresh:(YYPullUpRefreshView*)view;
- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(YYPullUpRefreshView*)view;
@optional
- (NSDate*)egoRefreshTableHeaderDataSourceLastUpdated:(YYPullUpRefreshView*)view;
@end
