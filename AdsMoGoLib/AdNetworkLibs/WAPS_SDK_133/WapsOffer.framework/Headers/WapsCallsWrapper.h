#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface WapsCallsWrapper : UIViewController {
    UIInterfaceOrientation currentInterfaceOrientation;
}

@property(assign) UIInterfaceOrientation currentInterfaceOrientation;

+ (WapsCallsWrapper *)sharedWapsCallsWrapper;

- (void)updateViewsWithOrientation:(UIInterfaceOrientation)interfaceOrientation;

- (void)moveViewToFront;

- (void)showBoxCloseNotification:(NSNotification *)notifierObj;
@end
