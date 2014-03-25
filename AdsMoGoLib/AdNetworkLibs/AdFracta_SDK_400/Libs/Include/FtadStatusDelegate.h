//
//  FtadStatusDelegate.h
//  FtadSdkIos3Lib
//
//  Created by Verna on 11-12-19.
//  Copyright 2011年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@protocol FtadStatusDelegate <NSObject>

//
//
-(void)didFtadReceiveAdFail:(NSString*)adIdentify;
//
//
-(void)didFtadReceiveAdSuccess:(NSString*)adIdentify;
//
//
-(void)didFtadRefreshAd:(NSString*)adIdentify;
//
//
-(void)didFtadClick:(NSString*)adIdentify;
//
//
-(void)willFtadViewClosed:(NSString*)adIdentify;
//
//
-(void)willFtadFullScreenShow:(NSString*)adIdentify;
//
//
-(void)didFtadFullScreenShow:(NSString*)adIdentify;
//
//
-(void)willFtadFullScreenClose:(NSString*)adIdentify;
//
//
-(void)didFtadFullScreenClose:(NSString*)adIdentify;

@end
