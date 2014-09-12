#import <Foundation/Foundation.h>
#import "WapsTBXML.h"


@interface WapsUserPoints : NSObject {
@private
    int points_;
    NSString *pointsID_;
    NSString *currencyName_;
}

@property(getter=getPointsValue, nonatomic) int points;
@property(nonatomic, retain) NSString *pointsID;
@property(getter=getPointsName, nonatomic, retain) NSString *currencyName;

+ (NSString *)getPointsName;

+ (int *)getPointsValue;

- (id)initWithTBXML:(WapsTBXMLElement *)aXMLElement;

- (void)updateWithTBXML:(WapsTBXMLElement *)aXMLElement shouldCheckEarnedPoints:(BOOL)checkEarnedPoints;

@end
