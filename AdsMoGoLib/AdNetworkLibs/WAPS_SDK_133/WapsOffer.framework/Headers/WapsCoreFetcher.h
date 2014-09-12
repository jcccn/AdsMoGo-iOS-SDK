#import <UIKit/UIKit.h>
#import "WapsLog.h"


@interface WapsCoreFetcher : NSObject {

    int requestTag_;
    int retryCount_;
    NSInteger responseCode_;
    NSTimeInterval requestTimeout_;
    NSInvocation *invocation_;
    NSString *requestMethod_;
    NSDictionary *postParameters_;
    BOOL hasFetched_;
    NSString *baseURL_;
    NSString *alternateURL_;
    NSDictionary *bindings_;
    NSError *error_;
    NSMutableData *data_;
    NSData *POSTdata_;
}

@property int requestTag;
@property(nonatomic, readonly) int retryCount;
@property(nonatomic, retain) NSInvocation *invocation;
@property(nonatomic, retain) NSString *requestMethod;
@property(nonatomic, retain) NSDictionary *postParameters;
@property(nonatomic) BOOL hasFetched;
@property(nonatomic, retain) NSString *baseURL;
@property(nonatomic, retain) NSString *alternateURL;
@property(nonatomic, retain) NSDictionary *bindings;
@property(nonatomic, retain) NSError *error;
@property(nonatomic, retain) NSMutableData *data;
@property(nonatomic, retain) NSData *POSTdata;
@property NSInteger responseCode;
@property(nonatomic) NSTimeInterval requestTimeout;


/*!	\fn fetchAsynchronouslyWithCompletionInvocation: (NSInvocation *) myInvocation
 *	\brief Fetches data asynchronously.
 *
 * Delegate methods for #connection are invoked when a response is received.
 *	\param myInvocation The NSInvocation when a response is received.
 *	\return n/a
 */
- (void)fetchAsynchronouslyWithCompletionInvocation:(NSInvocation *)myInvocation;

- (void)initiateConnection;

/*!	\fn retry
 *	\brief Initiates an asynchonous URL request and increments the retry counter.
 *
 *	\param n/a
 *	\return n/a
 */
- (void)retry;

/*!	\fn requestURL
 *	\brief Retrieves the #baseURL if the retry count is zero, or the #alternateURL otherwise.
 *
 *	\param n/a
 *	\return The #baseURL or #alternateURL depending on retry count.
 */
- (NSString *)requestURL;

/*!	\fn urlEncodedBindings
 *	\brief Retrieves the parameter list when a URL request is made.
 *
 *	\param n/a
 *	\return An NSString of all the URL parameters.
 */
- (NSString *)urlEncodedBindings;

/*!	\fn hasError
 *	\brief Indicates whether an error has occured with the URL request.
 *
 *	\param n/a
 *	\return TRUE is an error has occured, FALSE otherwise.
 */
- (BOOL)hasError;

@end
