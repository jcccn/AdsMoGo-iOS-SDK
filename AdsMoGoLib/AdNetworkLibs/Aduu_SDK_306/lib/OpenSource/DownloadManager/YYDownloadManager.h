

#import <Foundation/Foundation.h>
@class YYDownloadManager;
@protocol YYDownloadManagerDelegate <NSObject>
- (void) downloadManagerDataDownloadFinished: (NSString *) fileName object:(YYDownloadManager*)obj;
- (void) downloadManagerDataDownloadFailed: (NSString *) reason object:(YYDownloadManager*)obj;
@end

@interface YYDownloadManager : NSObject {
	
@private
	id <YYDownloadManagerDelegate> _delegate;
	
	NSString	*_title;
	NSURL		*_fileURL;
	NSString	*_fileName;
	

	NSUInteger _currentSize;
	
	NSNumber *_totalFileSize;
	NSURLConnection *_URLConnection;
	NSString *_zipPath;
}

@property (nonatomic, assign) id <YYDownloadManagerDelegate> delegate;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSURL *fileURL;
@property (nonatomic, retain) NSString *zipPath;
@property (nonatomic, retain) NSString *fileName;
@property (nonatomic, assign) NSUInteger currentSize;
@property (nonatomic, retain) NSNumber *totalFileSize;
@property (nonatomic, retain) NSURLConnection *URLConnection;



- (void)start;
- (void)createProgressionAlertWithMessage:(NSString *)message;

- (void)writeToFile:(NSData *)data;

@end



