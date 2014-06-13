//
//  AdChinaSShareAdapterQQ.m
//  AdChinaSShareKit
//
//  Created by mogo_wenyand on 13-12-6.
//  Copyright (c) 2013年 Daxiong. All rights reserved.
//

#import "AdChinaSShareAdapterQQ.h"
#import "AdChinaSSharePlatformRegistry.h"
#import <objc/runtime.h>
#import <objc/message.h>

#define  NOTFONTQQMESSAGE   @"您未安装QQ"
#define  NOTFONTOPENAPIMESSAGE   @"您安装的QQ版本不支持OpenApi"

#define showMessageAlert(title,msg,del,cancelTitle,otherTitle)			[[[[UIAlertView alloc] initWithTitle:title message:msg delegate:del cancelButtonTitle:cancelTitle otherButtonTitles:otherTitle, nil] autorelease] show]

#define   mogoHtml      @"html"
#define   mogoImg       @"img"
#define   mogoText      @"text"
#define   mogoAudio     @"audio"
#define   mogoVideo     @"video"

@interface AdChinaSShareAdapterQQ()<TencentSessionDelegate,QQApiInterfaceDelegate>{
    
}
@end


@implementation AdChinaSShareAdapterQQ
+ (void)load{
    [[AdChinaSSharePlatformRegistry sharedRegistry] registerClass:self];
}

+ (int)registryType{
    return AdChinaSShareAdapterTypeSinaQQfriend;
    
}
 static AdChinaSShareAdapterQQ * adapterQQ;
+(AdChinaSShareAdapterQQ*)shareMyClass{
    return adapterQQ;
}

- (void)share{
    adapterQQ =self;
    [self resetOpenURLMethod];
    if([self.infoData objectForKey:k_AdChinaSShareKitQQClientId]){
       tencentOAuth = [[TencentOAuth alloc] initWithAppId:[self.infoData objectForKey:k_AdChinaSShareKitQQClientId] andDelegate:self];
    }
    NSString *shareType=[[self.infoData objectForKey:k_AdChinaSShareKitQQShareType]lowercaseString];
    if ([shareType isEqualToString:mogoHtml]) {
        [self shareHtml];
    }else if([shareType isEqualToString:mogoAudio]){
        [self shareAudio];
    }else if([shareType isEqualToString:mogoVideo]){
        [self shareVideo];
    }else if([shareType isEqualToString:mogoImg]){
        [self shareHtml];
    }else if([shareType isEqualToString:mogoText]){
        [self shareText];
    }
}


-(void)resetOpenURLMethod{
    Method ori_MethodRotate =  class_getInstanceMethod([self class], @selector(myapplication:openURL:sourceApplication:annotation:));
    Method my_MethodRotate = class_getInstanceMethod([[[UIApplication sharedApplication]delegate]class], @selector(application:openURL:sourceApplication:annotation:));
    method_exchangeImplementations(ori_MethodRotate, my_MethodRotate);
}


-(BOOL)myapplication:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
     [QQApiInterface handleOpenURL:url delegate:[AdChinaSShareAdapterQQ shareMyClass]];
    if (YES == [TencentOAuth CanHandleOpenURL:url])
    {
        return [TencentOAuth HandleOpenURL:url];
    }
    BOOL isReturn=NO;
//    BOOL (*isCanReturnMethod)(id,SEL,UIApplication * application ,NSURL *url ,NSString *sourceApplication,id annotation) = NULL;
//    SEL regTypeSel = NSSelectorFromString(@"mogoapplication:openURL:sourceApplication:annotation:");
//    if ([self methodForSelector:regTypeSel]) {
//        isCanReturnMethod = (BOOL (*)(id,SEL,UIApplication * application ,NSURL *url ,NSString *sourceApplication,id annotation))[[self class] instanceMethodForSelector:regTypeSel];
//        isReturn=isCanReturnMethod(self,regTypeSel,application,url,sourceApplication,annotation);
//    }
    return  isReturn;
}


- (void)shareText{
    QQApiTextObject *txtObj = [QQApiTextObject objectWithText:[self.infoData objectForKey:k_AdChinaSShareKitQQImage]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:txtObj];
    [QQApiInterface sendReq:req];
}
- (void)shareImage{
    NSData * shareImage=[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.infoData objectForKey:k_AdChinaSShareKitQQImage]]];
    NSData * thumbImage =[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.infoData objectForKey:k_AdChinaSSahreKitQQThumbImage]]];
    QQApiImageObject *imgObj = [QQApiImageObject objectWithData:shareImage
                                               previewImageData:thumbImage
                                                          title:[self.infoData objectForKey:k_AdChinaSShareKitQQShareTitle]
                                                    description:[self.infoData objectForKey:k_AdChinaSSahreKitQQDetail]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:imgObj];
    [QQApiInterface sendReq:req];
}

-(void)shareAudio{
    QQApiAudioObject *audioObj =
    [QQApiAudioObject objectWithURL:[NSURL URLWithString:[self.infoData objectForKey:k_AdChinaSShareKitQQClickurl]]
                              title:[self.infoData objectForKey:k_AdChinaSShareKitQQShareTitle]
                        description:[self.infoData objectForKey:k_AdChinaSSahreKitQQDetail]
                    previewImageURL:[NSURL URLWithString:[self.infoData objectForKey:k_AdChinaSSahreKitQQThumbImage]]];
    
   [audioObj setFlashURL:[NSURL URLWithString:[self.infoData objectForKey:k_AdChinaSShareKitQQImage]]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:audioObj];
    [QQApiInterface sendReq:req];
}
-(void)shareVideo{
    QQApiVideoObject *videoObj = [QQApiVideoObject objectWithURL:[NSURL URLWithString:[self.infoData objectForKey:k_AdChinaSShareKitQQClickurl]]
                                                           title:[self.infoData objectForKey:k_AdChinaSShareKitQQShareTitle]
                                                     description:[self.infoData objectForKey:k_AdChinaSSahreKitQQDetail]
                                                previewImageData:[NSData dataWithContentsOfURL:[NSURL URLWithString:[self.infoData objectForKey:k_AdChinaSSahreKitQQThumbImage]]]];
    [videoObj setFlashURL:[NSURL URLWithString:[self.infoData objectForKey:k_AdChinaSShareKitQQImage]]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:videoObj];
    [QQApiInterface sendReq:req];
}

-(void)shareHtml{
    QQApiNewsObject *newsObj = [QQApiNewsObject
                                objectWithURL:[NSURL URLWithString:[self.infoData objectForKey:k_AdChinaSShareKitQQImage]]
                                title:[self.infoData objectForKey:k_AdChinaSShareKitQQShareTitle]
                                description:[self.infoData objectForKey:k_AdChinaSSahreKitQQDetail]
                                previewImageURL:[NSURL URLWithString:[self.infoData objectForKey:k_AdChinaSSahreKitQQThumbImage]]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    [QQApiInterface sendReq:req];
}


#pragma mark -
#pragma mark TencentSessionDelegate
- (void)tencentDidLogin{
    if (tencentOAuth.accessToken && [tencentOAuth.accessToken length] != 0 ) {
            //登陆成功，记录登陆用户的openid、token以及过期时间
        [AdChinaSShareKit MogoLog:@"登陆成功"];

    }else{
        [AdChinaSShareKit MogoLog:@"登陆不成功"];
    }
}

- (void)tencentDidNotLogin:(BOOL)cancelled{
    NSString *strLog = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [AdChinaSShareKit MogoLog:strLog];
}
/**
 * 登录时网络有问题的回调
 */
- (void)tencentDidNotNetWork{
    NSString *strLog = [NSString stringWithFormat:@"%s",__FUNCTION__];
    [AdChinaSShareKit MogoLog:strLog];
}

- (void)onReq:(QQBaseReq *)req{
    
}
/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp{
    BOOL flag=NO;
    switch (resp.type)
    {
        case ESENDMESSAGETOQQRESPTYPE:
        {
            if (resp.errorDescription==nil||[resp.errorDescription isEqualToString:@""]) {
                flag=YES;
            }else{
                flag=NO;
            }
        }
    }  
        if (self.shareKit.delegate && [self.shareKit.delegate respondsToSelector:@selector(shareFinish:shareType:)]) {
            [self.shareKit.delegate performSelector:@selector(shareFinish:shareType:) withObject:[NSNumber numberWithBool:flag] withObject:[NSNumber numberWithInt:[AdChinaSShareAdapterQQ registryType]]];
        }
  [self resetOpenURLMethod];
}
/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response{
    NSString *strLog = [NSString stringWithFormat:@"%@",response];
    [AdChinaSShareKit MogoLog:strLog];
}

@end
