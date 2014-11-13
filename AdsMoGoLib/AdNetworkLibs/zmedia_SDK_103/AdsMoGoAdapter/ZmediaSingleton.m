//
//  ZmediaSingleton.m
//  wanghaotest
//
//  Created by mogo on 14-7-28.
//
//

#import "ZmediaSingleton.h"
static ZmediaSingleton *ins;
@implementation ZmediaSingleton
@synthesize delegate;


+ (id)shareInstance{
    
    if (!ins) {
        ins = [[ZmediaSingleton alloc] init];
    }
    
    return ins;
    
}


#pragma mark -
#pragma mark ZMSDKBannerDelegate method

-(void)ZMSDKIntervalViewDelegateRequestSuccess:(BOOL)flag{
    if ([self.delegate respondsToSelector:@selector(ZMSDKIntervalViewDelegateRequestSuccess:)]) {
        [self.delegate ZMSDKIntervalViewDelegateRequestSuccess:flag];
    }
}

-(void)ZMSDKBannerDelegateRequestSuccess:(BOOL)flag{
    if ([self.delegate respondsToSelector:@selector(ZMSDKBannerDelegateRequestSuccess:)]) {
        [self.delegate ZMSDKBannerDelegateRequestSuccess:flag];
    }
}

-(void)ZMSDKBannerDelegateShowSuccess:(BOOL)flag{
    if ([self.delegate respondsToSelector:@selector(ZMSDKBannerDelegateShowSuccess:)]) {
        [self.delegate ZMSDKBannerDelegateShowSuccess:flag];
    }
}//banner是否显示成功

-(void)ZMSDKBannerDelegateClick{
    if ([self.delegate respondsToSelector:@selector(ZMSDKBannerDelegateClick)]) {
        [self.delegate ZMSDKBannerDelegateClick];
    }
}//banner点击


-(void)ZMSDKIntervalViewDelegateLoadSuccess:(BOOL)flag{
    if ([self.delegate respondsToSelector:@selector(ZMSDKIntervalViewDelegateLoadSuccess:)]) {
        [self.delegate ZMSDKIntervalViewDelegateLoadSuccess:flag];
    }
}
-(void)ZMSDKIntervalViewDelegateShowSuccess:(BOOL)flag{
    if ([self.delegate respondsToSelector:@selector(ZMSDKIntervalViewDelegateShowSuccess:)]) {
        [self.delegate ZMSDKIntervalViewDelegateShowSuccess:flag];
    }
}
-(void)ZMSDKIntervalViewDelegateClick{
    if ([self.delegate respondsToSelector:@selector(ZMSDKIntervalViewDelegateClick)]) {
        [self.delegate ZMSDKIntervalViewDelegateClick];
    }
}

-(void)ZMSDKIntervalViewDelegateClose{
    if ([self.delegate respondsToSelector:@selector(ZMSDKIntervalViewDelegateClose)]) {
        [self.delegate ZMSDKIntervalViewDelegateClose];
    }
}

@end
