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
    
    // 制作微信链接
    if (aciton ==0 || aciton ==1) {
        CGSize newSize = CGSizeMake(140, 140);
        UIGraphicsBeginImageContext(newSize);
        [adImage drawInRect:CGRectMake(0,0,newSize.width,newSize.height * adImage.size.height/adImage.size.width)];
        UIImage* aImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        NSData *myData = UIImageJPEGRepresentation(aImage, 0.5);
        UIImage *myImage = [UIImage imageWithData:myData];
        
        WXMediaMessage *message = [WXMediaMessage message];
        //message.title = adTitle;
        //message.description = adTitle;
        [message setThumbImage:myImage];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = adUrl;
        message.mediaObject = ext;
        
        SendMessageToWXReq* req = [[[SendMessageToWXReq alloc] init]autorelease];
        req.bText = NO;
        //不同分享模式下，title 和 description 表现的不一样
        if (aciton ==0) {
            req.scene = WXSceneSession;
            message.description = adTitle;
        }else{
            req.scene =  WXSceneTimeline;
            message.title = adTitle;
        }
        req.message = message;
        
        
        [WXApi sendReq:req];
    }else if (aciton ==2 )
    {
        // 微博图片和文字分享
        WBMessageObject *message = [WBMessageObject message];
        message.text = [NSString stringWithFormat:@"%@ %@",adTitle,adUrl];
        WBImageObject *image = [WBImageObject object];
        NSData *myData = UIImageJPEGRepresentation(adImage, 1);
        image.imageData = myData;
        message.imageObject = image;
        
        WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:message];
        request.userInfo = nil;
        
        [WeiboSDK sendRequest:request];
    }
}

@end
