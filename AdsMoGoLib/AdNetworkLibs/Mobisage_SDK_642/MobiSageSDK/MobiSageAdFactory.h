//
//  MobiSageAdFactory.h
//  mobiSageSDK
//
//  Created by fwang.work on 14/7/16.
//  Copyright (c) 2014年 adsage. All rights reserved.
//

typedef void (^MobiSageAdFactoryCompletionCallBack)(NSArray* adViews);

@class MobiSageAdFactory;


@protocol MobiSageAdFactoryDelegate<NSObject>

-(void)mobiSageAdFactorySuccessToRequest:(MobiSageAdFactory*) aNative;
-(void)mobiSageAdFactoryFaildToRequest:(MobiSageAdFactory*) aNative withError:(NSError*) error;
@end


@interface MobiSageAdFactory : NSObject

@property (nonatomic, assign) id<MobiSageAdFactoryDelegate> delegate;

@property (nonatomic) int capacity;//请求广告的数量,最多10个.

@property (nonatomic,strong) NSString* style; //广告模板类型;@"classic", @"image", @"simple1", @"simple2", @"image_slide"

@property (nonatomic, readonly) NSArray *adViews;//返回广告对象

@property (nonatomic,strong)  NSMutableDictionary* options;//高级可选控制项:
//(disableToLoad:YES 设置广告图片资源不去加载)
//(refreshInterval:30 设置轮播时间)


//请求广告组资源.(width=期望广告view的宽度.我们会根据width,等比缩放广告view,并返回给你height).
-(void) requestWithWidth:(CGFloat) width
               slotToken:(NSString *)slotToken
              completion:(MobiSageAdFactoryCompletionCallBack)completion;

//请求广告组资源.(height=期望广告view的宽度.我们会根据height,等比缩放广告view,并返回给你width).
-(void) requestWithHeight:(CGFloat) height
                slotToken:(NSString *)slotToken
               completion:(MobiSageAdFactoryCompletionCallBack)completion;

//请求广告组资源.(size=期望广告view的size.我们会自适应填充广告内容.宽高比在0.5-2之间为有效size).
-(void) requestWithSize:(CGSize) size
              slotToken:(NSString *)slotToken
             completion:(MobiSageAdFactoryCompletionCallBack)completion;

//设置请求广告的分类,分类名称以英文","为分割符; inverse=NO,表示请求分类中的广告;inverse=YES,表示剔除分类中的广告;
-(void) setAdTag:(NSString*) tag inverse:(BOOL) inverse;

//customtag的内容详见说明文档
-(void) setCustomTag:(NSDictionary*) tag;
@end




