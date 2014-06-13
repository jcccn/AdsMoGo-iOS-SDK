//
//  AdMoGoView.h
//  mogosdk
//
//  Created by MOGO on 12-5-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "AdMoGoDelegateProtocol.h"
#import "AdMoGoWebBrowserControllerUserDelegate.h"
#import "AdViewType.h"
#import "AdMoGoViewAnimationDelegate.h"


typedef NS_OPTIONS(NSUInteger, AdMoGoViewPointType) {
    AdMoGoViewPointTypeTop_left       = 1 << 0,
    AdMoGoViewPointTypeTop_middle     = 1 << 1,
    AdMoGoViewPointTypeTop_right      = 1 << 2,
    
    AdMoGoViewPointTypeMiddle_left    = 1 << 3,
    AdMoGoViewPointTypeMiddle_middle  = 1 << 4,
    AdMoGoViewPointTypeMiddle_right   = 1 << 5,
    
    AdMoGoViewPointTypeDown_left      = 1 << 6,
    AdMoGoViewPointTypeDown_middle    = 1 << 7,
    AdMoGoViewPointTypeDown_right     = 1 << 8,
    AdMoGoViewPointTypeCustom         = 1 << 9,
};

@interface AdMoGoView : UIView{
    
    BOOL isStop;
    
}
@property(nonatomic,assign) id<AdMoGoDelegate> delegate;



@property(nonatomic,assign) id<AdMoGoWebBrowserControllerUserDelegate> adWebBrowswerDelegate;

@property(nonatomic,assign) id<AdMoGoViewAnimationDelegate> adAnimationDelegate;

/*
    ak:开发appkey
    type:请求广告类型
    delegate:代理对象
 */
- (id) initWithAppKey:(NSString *)ak
               adType:(AdViewType)type
   adMoGoViewDelegate:(id<AdMoGoDelegate>) delegate;

/*
 ak:开发appkey
 type:请求广告类型
 delegate:代理对象
 AdPointType:广告位置
 */
-(id)initWithAppKey:(NSString *)ak adType:(AdViewType)type adMoGoViewDelegate:(id<AdMoGoDelegate>)delegate adViewPointType:(AdMoGoViewPointType) AdPointType;

/*
    返回位置类型
 */
-(AdMoGoViewPointType)getViewPointType;

/*
    设置位置类型
 */
-(void)setViewPointType:(AdMoGoViewPointType)viewPointType;

@end


