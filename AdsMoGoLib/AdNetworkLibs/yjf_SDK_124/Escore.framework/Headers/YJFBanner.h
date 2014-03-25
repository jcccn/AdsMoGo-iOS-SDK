//
//  Banner.h
//  yjfSDKDemo_beta1
//
//  Created by emaryjf on 13-2-5.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YJFBannerDelegate <NSObject>
@optional
-(void)openBanner:(int)_value;//1 打开成功  2 打开失败

@end


@interface YJFBanner : UIView
{
    id<YJFBannerDelegate> delegate;
    int i;
    int index;
    int timeInter;
    UIImageView *imageView;
    NSMutableArray *array;
    int flag1;
}
@property (assign) id<YJFBannerDelegate> delegate;
@property (nonatomic, retain) id vc;
@property (retain) NSMutableData *receivedData;

- (id)initWithFrame:(CGRect)frame andDelegate:(id<YJFBannerDelegate>) _delegate;
@end
