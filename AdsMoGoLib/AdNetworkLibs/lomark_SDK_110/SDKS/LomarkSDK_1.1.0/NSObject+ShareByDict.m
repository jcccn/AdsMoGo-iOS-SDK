//
//  NSObject+ShareByDict.m
//  Sample
//
//  Created by donson on 14-4-2.
//  Copyright (c) 2014年 donson. All rights reserved.
//

#import "NSObject+ShareByDict.h"

@implementation NSObject (ShareByDict)

-(void)ShareByDict:(NSDictionary *)infoDict
{
    NSString *adUrl = [infoDict objectForKey:@"adURL"];
    NSString *adTitle = [infoDict objectForKey:@"adTitle"];
    UIImage  *adImage = [infoDict objectForKey:@"adImage"];
    int aciton = [[infoDict objectForKey:@"adAction"]intValue];
    if (!adTitle) {
        adTitle = @"点媒广告展示";
    }
    
    if (aciton ==0 || aciton ==1) {
        WXMediaMessage *message = [WXMediaMessage message];
        message.title = adTitle;
        
        message.description = adUrl;
        [message setThumbImage:adImage];
        
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = adUrl;
        
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        req.message = message;
        if (aciton ==0) {
            req.scene = WXSceneSession;
        }else{
            req.scene =  WXSceneTimeline;
        }
        
        [WXApi sendReq:req];
    }else if (aciton ==2 )
    {
        WBMessageObject *message = [WBMessageObject message];
        
        message.text = adTitle;
        WBWebpageObject *webpage = [WBWebpageObject object];
        webpage.objectID = @"identifier1";
        webpage.title = adTitle;
        webpage.description = adUrl;
        webpage.thumbnailData = UIImageJPEGRepresentation(adImage, 0.5);
        webpage.webpageUrl = adUrl;
        message.mediaObject = webpage;
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        request.userInfo = nil;
        
        [WeiboSDK sendRequest:request];
    }
}

@end
