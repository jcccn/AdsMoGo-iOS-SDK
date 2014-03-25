//
//  AdAppRecommendViewController.h
//  ADSDK
//
//  Created by ad on 13-10-9.
//  Copyright (c) 2013年 mrdundun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AdAppRecommendViewController : UIViewController

@property (nonatomic,assign)int layoutType;
@property (nonatomic,strong)NSString * appid;

-(id)initWithLayoutType : (int) type  AppID : (NSString*) appid;

@end
