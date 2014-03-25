//
//  DianRuSDK.h
//  DianRuSDK
//
//  Created by  on 12-3-28.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol DianRuSDKDelegate <NSObject>
@required
/*介绍:
 *		设置广告类型
 *	    0为Banner广告，1为插入式广告，2为全屏广告
 */
- (int)adType;

/*介绍:
 *		应用程序唯一标识，由点入网站提供
 */
- (NSString *)applicationKey;


/*介绍:
 *		返回应用程序View以供SDK展示广告
 */
- (UIViewController *)viewControllerForPresentingModalView;


/*介绍:
 *		当有新的广告条的时候，SDK会通过以下代理通知调用者
 */
-(void)didReceiveAdView:(UIView*)adView;

@optional

/*介绍:
 *		只能用于Banner广告，用来控制是否在横竖屏切换时，仍然采用竖屏时候的广告大小
 */

- (BOOL)shouldUsingOrientationRelatedContent;


/*介绍:
 *		只能用于插入式广告和全屏广告，用来控制广告的最大展示时间
 */
- (int)adDisplayTime;


/*介绍:
 *		用户可以设置一些关键字
 */
- (NSString *)keyWords;

/*介绍:
 *      只能用于插入式广告和全屏广告，查看广告是否消失； 返回YES广告消失
 */

- (void)adDisappearResult:(BOOL)isDisappear;

@end

@interface DianRuSDK:UIView<CLLocationManagerDelegate,NSXMLParserDelegate,UIAlertViewDelegate>
{
    
}

+(void)requestAdmobileViewWithDelegate:(id<DianRuSDKDelegate>)delegate;

@end
