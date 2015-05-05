//
//  Banner.h
//  yjfSDKDemo_beta1
//
//  Created by emaryjf on 13-2-5.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HMBannerDelegate <NSObject>
@optional
-(void)openBanner:(int)_value;//1 打开成功  2 打开失败

-(void)loadBannerData:(int)_value;//1 加载数据成功 2 加载数据失败
@end


@interface HMBanner : UIView<HMBannerDelegate>
{
    id<HMBannerDelegate> delegate;
    int i;
    int index;
    int timeInter;
    NSString *imagePath;
    UIImageView *imageView;
    UILabel *label;
    UIImageView *downloadView;
    NSMutableArray *array;
    int flag1;
}
@property (nonatomic, assign) id<HMBannerDelegate> delegate;
@property (nonatomic, assign) UIViewController *viewController;
@property (retain) NSMutableData *receivedData;
-(void)showBanner;

- (id)initWithFrame:(CGRect)frame andAppId:(NSString *)appId  andDelegate:(id<HMBannerDelegate>) _delegate;
@end
