#import <Foundation/Foundation.h>
#import "WapsFetchResponseProtocol.h"

extern NSString *kWapsCoreFetcherReturnObjStr;
extern NSString *kWapsCoreFetcherAdStr;

@protocol WapsWebFetcherDelegate

@required

- (id)initRequestWithDelegate:(id <WapsFetchResponseDelegate>)aDelegate andRequestTag:(int)aTag;

@end


#import "WapsTBXML.h"

@class WapsCoreFetcher;

@interface WapsCoreFetcherHandler : NSObject {
    id <WapsFetchResponseDelegate> deleg_;
    int requestTag_;
    WapsCoreFetcher *myFetcher_;
}

- (id)initRequestWithDelegate:(id <WapsFetchResponseDelegate>)aDelegate andRequestTag:(int)aTag;

- (void)makeGenericRequestWithURL:(NSString *)aRequestString
                     alternateURL:(NSString *)alterURL
                           params:(NSMutableDictionary *)aParamsList
                         selector:(SEL)aSelector;

- (void)makeGenericPOSTRequestWithURL:(NSString *)aRequestString
                         alternateURL:(NSString *)alterURL
                                 data:(NSData *)data
                               params:(NSMutableDictionary *)aParamsList
                             selector:(SEL)aSelector;

- (void)makeRequestWithURL:(WapsCoreFetcher *)myFetcher withInvoker:(NSInvocation *)invoker;

- (NSString *)saveReturnObjectAsTBXMLElement:(WapsCoreFetcher *)myFetcher FileName:(NSString *)fileName;

- (WapsTBXMLElement *)parseReturnObjectAsTBXMLElement:(WapsCoreFetcher *)myFetcher;

- (WapsTBXMLElement *)validateResponseReturnedObject:(WapsCoreFetcher *)myFetcher;


@end
