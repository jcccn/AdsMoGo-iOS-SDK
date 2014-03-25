
#import <UIKit/UIKit.h>
#import "YYDownloadManager.h"

#define DELEGATE_CALLBACK(X, Y) if (self.delegate && [self.delegate respondsToSelector:@selector(X)]) [self.delegate performSelector:@selector(X) withObject:Y];
@implementation YYDownloadManager


///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)start
{
	if (_fileURL == nil) {
		
		return;
	}
    if (_delegate) {
        [_delegate retain];
    }
	NSURLRequest *request = [NSURLRequest requestWithURL:_fileURL];
	self.URLConnection = [NSURLConnection connectionWithRequest:request delegate:self];
	if (_URLConnection) {
		[self createProgressionAlertWithMessage:_title];
	} else {
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)createProgressionAlertWithMessage:(NSString *)message 
{	
	
}

-(void)cancelLoadAction:(UIButton *)sender{
	[_URLConnection cancel];
	NSError *error;
	NSString *filePath=[NSString stringWithFormat:@"%@",_fileName];
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath]){
		[[NSFileManager defaultManager] removeItemAtPath:filePath error:&error];
	}
}

///////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response 
{
	self.currentSize = 0;
    self.totalFileSize = [NSNumber numberWithLongLong:[response expectedContentLength]];
	
	// Check for bad connection
	if ([response expectedContentLength] < 0)
	{
		NSString *reason = [NSString stringWithFormat:@"Invalid URL [%@]", [_fileURL absoluteString]];
	//	DELEGATE_CALLBACK(downloadManagerDataDownloadFailed:, reason);
        if ([_delegate respondsToSelector:@selector(downloadManagerDataDownloadFailed:object:)]) {
            [_delegate downloadManagerDataDownloadFailed:reason object:self];
        }
		[connection cancel];
		return;
	}
	
	if ([response suggestedFilename])
		DELEGATE_CALLBACK(downloadManagerDidReceiveData:, [response suggestedFilename]);
	
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data 
{
    [self writeToFile:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error 
{
	//[_progressAlertView dismissWithClickedButtonIndex:0 animated:YES];
	
}
-(void)writeToFile:(NSData *)data{
	NSString *filePath=[NSString stringWithFormat:@"%@",_fileName];
	if([[NSFileManager defaultManager] fileExistsAtPath:filePath] == NO){
		[[NSFileManager defaultManager] createFileAtPath:filePath contents:nil attributes:nil];
	}
	FILE *file = fopen([_fileName UTF8String], [@"ab+" UTF8String]);
	if(file != NULL){
		fseek(file, 0, SEEK_END);
	}
	int readSize = [data length];
	fwrite((const void *)[data bytes], readSize, 1, file);
	fclose(file);
}



///////////////////////////////////////////////////////////////////////////////////////////////////
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
	
	//DELEGATE_CALLBACK(downloadManagerDataDownloadFinished:, _fileName);
    if ([_delegate respondsToSelector:@selector(downloadManagerDataDownloadFinished:object:)]) {
        [_delegate downloadManagerDataDownloadFinished:_fileName object:self];
    }
}
///////////////////////////////////////////////////////////////////////////////////////////////////
@synthesize delegate = _delegate;
@synthesize title = _title;
@synthesize fileURL = _fileURL;
@synthesize fileName = _fileName;
@synthesize zipPath = _zipPath;
@synthesize currentSize = _currentSize;
@synthesize totalFileSize = _totalFileSize;
@synthesize URLConnection = _URLConnection;

//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    [_zipPath release];
    //_delegate = nil;
    [_title release];
    [_fileURL release];
    [_fileName release];
    [_totalFileSize release];
    [_URLConnection release];
	
    [super dealloc];
}


@end








