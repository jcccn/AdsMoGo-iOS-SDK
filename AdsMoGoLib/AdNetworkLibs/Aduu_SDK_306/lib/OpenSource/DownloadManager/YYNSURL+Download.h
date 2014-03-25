

#import <Foundation/Foundation.h>

@interface NSURL (NSURL_Download) 

- (void)downloadWithDelegate:(id)delegate Title:(NSString *)title WithToFileName:(NSString *)fileName;

@end
