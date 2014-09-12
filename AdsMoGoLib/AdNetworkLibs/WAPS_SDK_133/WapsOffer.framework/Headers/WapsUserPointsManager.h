#import <Foundation/Foundation.h>
#import "WapsFetchResponseProtocol.h"
#import "AppConnect.h"
#import "WapsTBXML.h"


typedef enum {
    kWapsUserAccountRequestTagGetPoints = 0,
    kWapsUserAccountRequestTagSpendPoints,
    kWapsUserAccountRequestTagAwardPoints,
    kWapsUserAccountRequestTagMAX
} WapsUserAccountRequestTag;

@class WapsUserPointsRequestHandler;
@class WapsUserPoints;

@interface WapsUserPointsManager : NSObject <WapsFetchResponseDelegate> {
    WapsUserPoints *userPointsObj_;
    WapsUserPointsRequestHandler *userPointsGetPointsObj_;
    WapsUserPointsRequestHandler *userPointsSpendPointsObj_;

    BOOL waitingForResponse_;
}

+ (WapsUserPointsManager *)sharedWapsUserPointsManager;

- (void)getPoints;

- (void)spendPoints:(int)points;

- (void)awardPoints:(int)points;

- (void)fetchResponseSuccessWithData:(void *)dataObj withRequestTag:(int)aTag;

- (void)fetchResponseError:(WapsResponseError)errorType errorDescription:(id)errorDescObj requestTag:(int)aTag;

- (void)updateUserAccountObjWithTBXMLElement:(WapsTBXMLElement *)userAccElement;

- (void)releaseUserAccount;

@property(nonatomic, readonly) WapsUserPoints *userPointsObj;

@end


@interface AppConnect (WapsUserPointsManager)

+ (void)getPoints;

+ (void)spendPoints:(int)points;

+ (void)awardPoints:(int)points;

+ (void)showDefaultEarnedCurrencyAlert;

@end
