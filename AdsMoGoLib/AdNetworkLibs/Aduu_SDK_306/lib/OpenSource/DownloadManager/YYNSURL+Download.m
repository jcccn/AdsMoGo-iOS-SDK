

#import "YYNSURL+Download.h"
#import "YYDownloadManager.h"


@implementation NSURL (NSURL_Download)

- (void)downloadWithDelegate:(id)delegate Title:(NSString *)title WithToFileName:(NSString *)fileName
{
	YYDownloadManager *download	=[[YYDownloadManager alloc]init];
	download.title=title;
	download.fileURL=self;
	download.fileName=fileName;
	download.delegate = delegate;
	[download start];
}


@end
