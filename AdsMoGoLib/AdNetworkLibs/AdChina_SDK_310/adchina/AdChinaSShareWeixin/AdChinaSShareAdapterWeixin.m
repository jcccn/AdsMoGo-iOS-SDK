//
//  AdChinaSShareWeixin.m
//  AdChinaSShareKit
//
//  Created by mogo_wenyand on 13-12-2.
//  Copyright (c) 2013年 Daxiong. All rights reserved.
//

#import "AdChinaSShareAdapterWeixin.h"
#import "AdChinaSSharePlatformRegistry.h"
#import "WXApi.h"
#import "WXApiObject.h"

#define  IsTest   0


#define   mogoHtml      @"html"
#define   mogoImg       @"img"
#define   mogoText      @"text"
#define   mogoAudio     @"audio"
#define   mogoVideo     @"video"
#define showMessageAlert(title,msg,del,cancelTitle,otherTitle)			[[[[UIAlertView alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil] autorelease] show]


@interface AdChinaSShareAdapterWeixin ()<WXApiDelegate>
{
    WXMediaMessage *message;
}
@end

@implementation AdChinaSShareAdapterWeixin
+ (void)load{
    [[AdChinaSSharePlatformRegistry sharedRegistry] registerClass:self];
}
static AdChinaSShareAdapterWeixin* adapterwx;
+(AdChinaSShareAdapterWeixin*)shareMyClass{
    return adapterwx;
}
+ (int)registryType{
    return AdChinaSShareAdapterTypeSinaWeiWx;
}
- (void)share{
    adapterwx =self;
    NSString *shareType=[[self.infoData objectForKey:k_AdChinaSShareKitWeixinShareType]lowercaseString];
    [self resetOpenURLMethod];
    if ([self.infoData objectForKey:k_AdChinaSShareKitWeixinClientId]) {
        [WXApi registerApp:[self.infoData objectForKey:k_AdChinaSShareKitWeixinClientId]];
    }
    if (![WXApi isWXAppInstalled]) {
        NSString *strMsg = @"您未安装微信";
        [AdChinaSShareKit MogoLog:strMsg];
        showMessageAlert(@"",strMsg,self, @"OK", nil);
        [[AdChinaSShareKit sharedRegistry]setinShare:NO];
        return;
    }else if (![WXApi isWXAppSupportApi]){
        NSString *strMsg = @"您安装的微信版本不支持OpenApi";
        [AdChinaSShareKit MogoLog:strMsg];
        showMessageAlert(@"",strMsg,self, @"OK", nil);
        [[AdChinaSShareKit sharedRegistry]setinShare:NO];
        return;
    }
    
    message=[WXMediaMessage message];
    message.title=[self.infoData objectForKey:k_AdChinaSShareKitWeixinTitle];
    message.description=[self.infoData objectForKey:k_AdChinaSSahreKitWeixinDetail];
    NSString * thumbDataURL=[self.infoData objectForKey:k_AdChinaSSahreKitWeixinThumbImage];
    if (thumbDataURL!=nil&&![thumbDataURL isEqualToString:@""]) {
        message.thumbData=[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.infoData objectForKey:k_AdChinaSSahreKitWeixinThumbImage]]];
    }
    
    if ([shareType isEqualToString:mogoHtml]) {
        [self shareHtml];
    }else if([shareType isEqualToString:mogoAudio]){
        [self shareAudio];
    }else if([shareType isEqualToString:mogoVideo]){
        [self shareVideo];
    }else if([shareType isEqualToString:mogoImg]){
        [self shareImage];
    }else if([shareType isEqualToString:mogoText]){
        [self shareText];
    }
}
- (void)shareText{
    if ([self.infoData objectForKey:k_AdChinaSShareKitWeixinContext]) {
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init] autorelease];
        req.text = [self.infoData objectForKey:k_AdChinaSShareKitWeixinContext];
        req.bText = YES;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    }
}
-(void)resetOpenURLMethod{
    Class  apClass=[[[UIApplication sharedApplication]delegate]class];
    Method new_method=class_getInstanceMethod([self class], @selector(myapplication:openURL:sourceApplication:annotation:));
    class_replaceMethod(apClass, @selector(application:openURL:sourceApplication:annotation:),method_getImplementation(new_method), method_getTypeEncoding(new_method));
}

-(BOOL)myapplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
  return  [WXApi handleOpenURL:url delegate:[AdChinaSShareAdapterWeixin shareMyClass]];
}
-(void)shareImage{
    NSString * shareurl=[self.infoData objectForKey:k_AdChinaSShareKitWeixinContext];
    if (shareurl) {
        WXImageObject *ext = [WXImageObject object];
        [ext setImageData:[NSData dataWithContentsOfURL:[NSURL URLWithString:shareurl]]];
        message.mediaObject = ext;
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    }
}
-(void)shareVideo{
    NSString * shareurl=[self.infoData objectForKey:k_AdChinaSSahreKitWeixinclickurl];
    if (shareurl) {
        WXVideoObject *ext = [WXVideoObject object];
        //TODO:判断当前网络环境怎样
        if (true) {
            [ext setVideoUrl:shareurl];
        }else{
            [ext setVideoLowBandUrl:shareurl];
        }
        message.mediaObject = ext;
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        req.scene = WXSceneSession;
        [WXApi sendReq:req];
    }
}

-(void)shareAudio{
    NSString * shareurl=[self.infoData objectForKey:k_AdChinaSShareKitWeixinContext];
    NSString * clickshareurl=[self.infoData objectForKey:k_AdChinaSSahreKitWeixinclickurl];
    if (shareurl) {
    WXMusicObject *ext = [WXMusicObject object];
    [ext setMusicUrl:clickshareurl];
    [ext setMusicDataUrl:shareurl];
    message.mediaObject=ext;
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
    }
}
-(void)shareHtml{
    NSString * shareurl=[self.infoData objectForKey:k_AdChinaSShareKitWeixinContext];
    if (shareurl) {
    WXWebpageObject *ext = [WXWebpageObject object];
    [ext setWebpageUrl:shareurl];
    message.mediaObject = ext;
    SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    [WXApi sendReq:req];
    }
}

 
#pragma mark -
#pragma mark WXApi delegate
- (void)onResp:(BaseResp *)resp{
    NSString *strLog = [NSString stringWithFormat:@"%@",resp];
    [AdChinaSShareKit MogoLog:strLog];
    BOOL  success;
    if([resp isKindOfClass:[SendMessageToWXResp class]])
    {
        switch (resp.errCode) {
            case WXSuccess:
                success=YES;
                break;
            case WXErrCodeCommon:
                success=NO;
                break;
            case WXErrCodeUserCancel:
                 success=NO;
                break;
            case WXErrCodeSentFail:
                 success=NO;
                break;
            case WXErrCodeAuthDeny:
                 success=NO;
                break;
            case WXErrCodeUnsupport:
                 success=NO;
                break;
            default:
                success=NO;
                break;
        }
        if (success) {
            [AdChinaSShareKit MogoLog:@"登陆成功"];
        } else {
            [AdChinaSShareKit MogoLog:@"登陆失败"];
        }

        if (self.shareKit.delegate && [self.shareKit.delegate respondsToSelector:@selector(shareFinish:shareType:)]) {
            [self.shareKit.delegate performSelector:@selector(shareFinish:shareType:) withObject:[NSNumber numberWithBool:success] withObject:[NSNumber numberWithInt:[AdChinaSShareAdapterWeixin registryType]]];
        }
        NSString *strMsg = [NSString stringWithFormat:@"errcode:%d", resp.errCode];
        [AdChinaSShareKit MogoLog:strMsg];
    }
}





@end
