//
//  initServer.h
//  yjfSDKDemo_beta1
//
//  Created by nemo on 13-1-27.
//  Copyright (c) 2013年 emaryjf. All rights reserved.
//

#import <Foundation/Foundation.h>



@protocol InitResultDelegate <NSObject>
-(void)initSuccess;
-(void)initFailed;
@end

@interface HMInitServer : NSObject<NSURLConnectionDelegate>
{
    id<InitResultDelegate> delegate;
}

-(void) getInitEscoreData:(id<InitResultDelegate>)_delegate;

@end