//
//  IZPADView.h
//  IZPADView
//
//  Created by Tang Gang on 11-4-12.
//  Copyright 2011 izp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum _model {
    MODEL_TEST,
    MODEL_RELEASE
} Model ;

typedef enum _adType{
    AD_TYPE_BANNER=1,
    AD_TYPE_FULLSCRENN,
} AdType ;




@protocol IZPDelegate;

@interface IZPView : UIView {
    
}

+ (void)setPID:(NSString *)pid adType:(AdType)type model:(Model)model;
- (id)initWithFrame:(CGRect)frame;
- (void)setDelegate:(id)delegate;
- (void)start;
- (void)pause;
@end
