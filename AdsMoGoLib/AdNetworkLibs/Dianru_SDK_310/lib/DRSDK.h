#define DR_INSERSCREEN  3   //插播广告
#define DR_FULLSCREEN   4   //全屏广告
#define DR_BANNER       5   //BANNER
#define DR_ENTER        @"enter"    //进入试图调用
#define DR_CLOSE        @"close"    //关闭试图调用
#define DR_CLICK        @"click"    //点击广告
#define DR_JUMP         @"jump"     //跳转广告
#define DR_CLOSE_MAIN   @"exit"//关闭点入广告
/*
 key:applicationKey
 isuse:是否开启定位
 appuserid:用户提供的唯一标示, 推荐使用应用程序的用户名
 */
#define DR_INIT(key, isuse, userid) [Aceaffgfcdhfbhhbchb initialize:key location:isuse appuserid:userid];
#define DR_SHOW(type, view) [Aceaffgfcdhfbhhbchb show:type on:view];
#define DR_CREATE(type, cb) [Aceaffgfcdhfbhhbchb create:type callback:cb];
typedef void (^scoreResultCallback)(int result);
typedef void (^spendScoreResultCallback)(Boolean result);
typedef void (^createCallback) (int type, UIView *view);
@interface Aceaffgfcdhfbhhbchb : NSObject<NSURLConnectionDelegate>
+(void)initialize:(NSString *)key location:(BOOL)value appuserid:(NSString *)appuserid;
+(void)show:(NSInteger)space on:(UIView *)view;
+(void)create:(NSInteger)space callback:(createCallback)callback;
#pragma mark 获取积分/积分回调 callback ?
@end
