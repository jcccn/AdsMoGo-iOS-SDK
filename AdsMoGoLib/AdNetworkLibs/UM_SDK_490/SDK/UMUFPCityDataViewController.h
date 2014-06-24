//
//  UMUFPCityDataViewController.h
//  UFP
//
//  Created by liuyu on 8/19/13.
//  Copyright (c) 2013 Realcent. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UMUFPCityDataDelegate;

@interface UMUFPCityDataViewController : UIViewController {
    
    UISearchBar *_mSearchBar;
    UISearchDisplayController *_mSearchDC;
    
    UITableView *_mTableView;
}

@property (nonatomic, copy) NSString *selectedCityName;
@property (nonatomic, assign) id<UMUFPCityDataDelegate> delegate;

@end

@protocol UMUFPCityDataDelegate <NSObject>

@optional

- (void)cityDataViewController:(UMUFPCityDataViewController *)viewController selectedCityWithData:(NSDictionary *)cityData;

@end
